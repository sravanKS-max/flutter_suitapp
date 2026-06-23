
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

import 'package:suitapps/services/auth_session_service.dart';
import 'package:suitapps/services/customer_api_service.dart';
import 'customer_details_page.dart';

// ─── Design Tokens ───────────────────────────────────────────────
class _T {
  static const primaryBlue   = Color.fromARGB(255, 35, 0, 196);
  static const secondaryBlue = Color(0xFF6F7FDB);
  static const background    = Color(0xFFF5F7FB);
  static const cardBg        = Color(0xFFFFFFFF);
  static const textPrimary   = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const border        = Color(0xFFE5E7EB);
  static const success       = Color(0xFF16A34A);
  static const warning       = Color(0xFFF59E0B);
  static const error         = Color(0xFFDC2626);

  static const xs  = 4.0;
  static const sm  = 8.0;
  static const md  = 12.0;
  static const lg  = 16.0;           
  static const xl  = 24.0;
  static const xxl = 32.0;

  static const rCard   = 16.0;
  static const rButton = 12.0;
  static const rBadge  = 16.0;

  static List<BoxShadow> get shadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static const String font = 'Inter';

  static const pageTitle    = TextStyle(fontFamily: font, fontSize: 20, fontWeight: FontWeight.w700, color: cardBg);
  static const sectionTitle = TextStyle(fontFamily: font, fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary);
  static const cardValue    = TextStyle(fontFamily: font, fontSize: 20, fontWeight: FontWeight.w900, color: textPrimary);
  static const cardTitle    = TextStyle(fontFamily: font, fontSize: 12, fontWeight: FontWeight.w700, color: textSecondary, letterSpacing: 0.4);
  static const buttonText   = TextStyle(fontFamily: font, fontSize: 14, fontWeight: FontWeight.w600);
  static const inputText    = TextStyle(fontFamily: font, fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary);
  static const smallText    = TextStyle(fontFamily: font, fontSize: 11, fontWeight: FontWeight.w500, color: textSecondary);
  static const caption      = TextStyle(fontFamily: font, fontSize: 10, fontWeight: FontWeight.w400, color: textSecondary);
}

// ─── Page ─────────────────────────────────────────────────────────
class ExistingCustomersPage extends StatefulWidget {
  const ExistingCustomersPage({super.key});

  @override
  State<ExistingCustomersPage> createState() => _ExistingCustomersPageState();
}

class _ExistingCustomersPageState extends State<ExistingCustomersPage> {
  final CustomerApiService _service = CustomerApiService();

  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];
  List<Map<String, dynamic>> _sortedByDistanceCustomers = [];
  bool _loading = true;
  String? _error;
  int _selectedRoute = 0;
  late TextEditingController _searchController;
  
  Position? _userLocation;
  bool _gettingLocation = false;
  bool _showByDistance = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_applyFilter);
    _loadCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() { _loading = true; _error = null; _customers = []; });
    try {
      final authService = AuthSessionService();
      final routeInfo  = await authService.getRouteInfo();
      final prefs      = await SharedPreferences.getInstance();
      final companyId  = prefs.getString('CompanyID') ?? prefs.getString('SelectedCompanyId') ?? '';
      final rootId     = routeInfo['routeId'];

      if (rootId == null || rootId.toString().isEmpty || companyId.isEmpty) {
        setState(() { _error = 'Missing route/company information'; });
        return;
      }

      final customers = await _service.fetchCustomers(rootId: rootId, companyId: companyId);
      if (!mounted) return;
      setState(() { 
        _customers = customers;
        _filteredCustomers = customers;
      });
    } catch (e) {
      setState(() { _error = 'Unable to load customers\n$e'; });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  Future<void> _openMap(String lat, String lng) async {
    await launchUrl(
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng'),
      mode: LaunchMode.externalApplication,
    );
  }

  bool _hasLocation(Map<String, dynamic> c) =>
      c['Latitude']  != null && c['Latitude'].toString().isNotEmpty &&
      c['Longitude'] != null && c['Longitude'].toString().isNotEmpty;

  void _applyFilter() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers = _customers;
      } else {
        _filteredCustomers = _customers.where((customer) {
          final name   = customer['AccountName']?.toString().toLowerCase() ?? '';
          final place  = customer['Place']?.toString().toLowerCase() ?? '';
          final city   = customer['City']?.toString().toLowerCase() ?? '';
          final mobile = (customer['Mob']?.toString().isNotEmpty == true)
              ? customer['Mob'].toString().toLowerCase()
              : customer['Phone']?.toString().toLowerCase() ?? '';

          return name.contains(query) || 
                 place.contains(query) || 
                 city.contains(query) || 
                 mobile.contains(query);
        }).toList();
      }
    });
  }

  // ── Haversine Distance Calculation ────────────────────────────────
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371;
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;

  // ── Get Current User Location ─────────────────────────────────────
  Future<void> _getUserLocation() async {
    setState(() => _gettingLocation = true);
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final result = await Geolocator.requestPermission();
        if (result == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission is required')),
            );
          }
          setState(() => _gettingLocation = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _userLocation = position;
        _sortCustomersByDistance();
        _showByDistance = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _gettingLocation = false);
    }
  }

  // ── Sort Customers by Distance ────────────────────────────────────
  void _sortCustomersByDistance() {
    if (_userLocation == null) return;

    final customersWithDistance = _filteredCustomers.where((customer) {
      final lat = customer['Latitude'];
      final lng = customer['Longitude'];
      return lat != null && lng != null && 
             lat.toString().isNotEmpty && lng.toString().isNotEmpty;
    }).map((customer) {
      final distance = _calculateDistance(
        _userLocation!.latitude,
        _userLocation!.longitude,
        double.parse(customer['Latitude'].toString()),
        double.parse(customer['Longitude'].toString()),
      );
      return {...customer, 'distance': distance};
    }).toList();

    customersWithDistance.sort((a, b) => 
        (a['distance'] as double).compareTo(b['distance'] as double));

    setState(() => _sortedByDistanceCustomers = customersWithDistance);
  }

  // ── Build ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayCustomers = _showByDistance ? _sortedByDistanceCustomers : _filteredCustomers;
    
    final nearby    = displayCustomers.where(_hasLocation).toList();
    final noLoc     = _showByDistance ? <Map<String, dynamic>>[] : displayCustomers.where((c) => !_hasLocation(c)).toList();

    return Scaffold(
      backgroundColor: _T.background,
      appBar: AppBar(
        backgroundColor: _T.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text('Existing Customers', style: _T.pageTitle),
        actions: [
          IconButton(
            onPressed: _loadCustomers,
            icon: const Icon(Icons.refresh_rounded, size: 24),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _errorState(_error!)
              : Column(
                  children: [
                    const SizedBox(height: _T.md),
                    // _routeTabs(),
                    // const SizedBox(height: _T.md),
                    _searchBar(),
                    const SizedBox(height: _T.md),
                    _sortToggleBar(),
                    const SizedBox(height: _T.md),
                    Expanded(
                      child: displayCustomers.isEmpty
                          ? _noResultsState()
                          : ListView(
                              padding: const EdgeInsets.symmetric(horizontal: _T.lg),
                              children: [
                                if (_showByDistance) ...[
                                  _sectionHeader('Customers Near You', _T.success, nearby.length),
                                  const SizedBox(height: _T.md),
                                  ...nearby.map((c) => _customerCard(c, true, showDistance: true)),
                                ] else ...[
                                  _sectionHeader('Nearby Customers', _T.success, nearby.length),
                                  const SizedBox(height: _T.md),
                                  ...nearby.map((c) => _customerCard(c, true, showDistance: false)),
                                  if (nearby.isNotEmpty)
                                    const SizedBox(height: _T.xl),
                                  if (noLoc.isNotEmpty)
                                    _sectionHeader('No Location', _T.warning, noLoc.length),
                                  if (noLoc.isNotEmpty)
                                    const SizedBox(height: _T.md),
                                  ...noLoc.map((c) => _customerCard(c, false, showDistance: false)),
                                ],
                                const SizedBox(height: _T.xxl),
                              ],
                            ),
                    ),
                  ],
                ),
    );
  }

  // ── Error State ───────────────────────────────────────────────────
  // Widget _noResultsState() {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(_T.xl),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(_T.lg),
  //             decoration: BoxDecoration(
  //               color: _T.warning.withValues(alpha: 0.08),
  //               shape: BoxShape.circle,
  //             ),
  //             child: const Icon(Icons.search_off_rounded, size: 36, color: _T.warning),
  //           ),
  //           const SizedBox(height: _T.lg),
  //           Text(
  //             'No customers found',
  //             style: _T.sectionTitle,
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: _T.sm),
  //           Text(
  //             'Try searching with different keywords:\nname, place, city, or mobile number',
  //             style: _T.inputText.copyWith(color: _T.textSecondary),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: _T.lg),
  //           _ghostButton(label: 'Clear Search', icon: Icons.clear_rounded, color: _T.primaryBlue, onTap: () {
  //             _searchController.clear();
  //             _applyFilter();
  //           }),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _noResultsState() {
  return SingleChildScrollView(
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(_T.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(_T.lg),
                decoration: BoxDecoration(
                  color: _T.warning.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 36,
                  color: _T.warning,
                ),
              ),

              const SizedBox(height: _T.lg),

              Text(
                'No customers found',
                style: _T.sectionTitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: _T.sm),

              Text(
                'Try searching with different keywords:\nname, place, city, or mobile number',
                style: _T.inputText.copyWith(
                    color: _T.textSecondary),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: _T.lg),

              _ghostButton(
                label: 'Clear Search',
                icon: Icons.clear_rounded,
                color: _T.primaryBlue,
                onTap: () {
                  _searchController.clear();
                  _applyFilter();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _T.lg),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name, place, city, mobile...',
          hintStyle: _T.inputText.copyWith(color: _T.textSecondary.withValues(alpha: 0.6)),
          prefixIcon: const Icon(Icons.search_rounded, color: _T.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: _T.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilter();
                  },
                )
              : null,
          filled: true,
          fillColor: _T.cardBg,
          contentPadding: const EdgeInsets.symmetric(horizontal: _T.md, vertical: _T.md),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_T.rButton),
            borderSide: const BorderSide(color: _T.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_T.rButton),
            borderSide: const BorderSide(color: _T.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_T.rButton),
            borderSide: const BorderSide(color: _T.primaryBlue, width: 2),
          ),
        ),
        style: _T.inputText,
      ),
    );
  }

  // ── Sort Toggle Bar ───────────────────────────────────────────────
  Widget _sortToggleBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _T.lg),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _T.cardBg,
                borderRadius: BorderRadius.circular(_T.rButton),
                border: Border.all(color: _T.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _toggleButton(
                      label: 'All',
                      isActive: !_showByDistance,
                      onTap: () => setState(() => _showByDistance = false),
                    ),
                  ),
                  Expanded(
                    child: _toggleButton(
                      label: 'Near Me',
                      isActive: _showByDistance,
                      onTap: () async {
                        if (_userLocation == null) {
                          await _getUserLocation();
                        }
                        if (_userLocation != null) {
                          setState(() => _showByDistance = true);
                        }
                      },
                      isLoading: _gettingLocation,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: _T.md),
          decoration: BoxDecoration(
            color: isActive ? _T.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(_T.rButton),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isActive ? Colors.white : _T.primaryBlue,
                    ),
                  ),
                )
              : Text(
                  label,
                  style: _T.buttonText.copyWith(
                    color: isActive ? Colors.white : _T.textSecondary,
                  ),
                ),
        ),
      ),
    );
  }

  // ── Error State ───────────────────────────────────────────────────
  Widget _errorState(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(_T.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(_T.lg),
              decoration: BoxDecoration(
                color: _T.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_rounded, size: 36, color: _T.error),
            ),
            const SizedBox(height: _T.lg),
            Text(msg, style: _T.inputText.copyWith(color: _T.error), textAlign: TextAlign.center),
            const SizedBox(height: _T.lg),
            _ghostButton(label: 'Retry', icon: Icons.refresh_rounded, color: _T.primaryBlue, onTap: _loadCustomers),
          ],
        ),
      ),
    );
  }

  // ── Route Tabs ────────────────────────────────────────────────────
  Widget _routeTabs() {
    const routes = ['Route A', 'Route B', 'Route C'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: _T.lg),
        itemCount: routes.length,
        itemBuilder: (context, i) {
          final selected = _selectedRoute == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedRoute = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: _T.sm),
              padding: const EdgeInsets.symmetric(horizontal: _T.lg, vertical: _T.sm),
              decoration: BoxDecoration(
                color: selected ? _T.primaryBlue : _T.cardBg,
                borderRadius: BorderRadius.circular(_T.rBadge),
                border: Border.all(
                  color: selected ? _T.primaryBlue : _T.border,
                ),
                boxShadow: selected ? _T.shadow : [],
              ),
              child: Text(
                routes[i],
                style: _T.buttonText.copyWith(
                  color: selected ? Colors.white : _T.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────
  Widget _sectionHeader(String title, Color color, int count) {
    return Row(
      children: [
        Text(title, style: _T.sectionTitle),
        const SizedBox(width: _T.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: _T.sm, vertical: _T.xs),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(_T.rBadge),
          ),
          child: Text(
            '$count',
            style: _T.smallText.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  // ── Customer Card ─────────────────────────────────────────────────
  Widget _customerCard(Map<String, dynamic> customer, bool hasLoc, {bool showDistance = false}) {
    final name    = customer['AccountName']?.toString() ?? '';
    final code    = customer['AccountCode']?.toString() ?? '';
    final place   = customer['Place']?.toString() ?? '';
    final city    = customer['City']?.toString() ?? '';
    final address = customer['Address']?.toString() ?? '';
    final phone   = (customer['Mob']?.toString().isNotEmpty == true)
        ? customer['Mob'].toString()
        : customer['Phone']?.toString() ?? '';
    final lat     = customer['Latitude']?.toString() ?? '';
    final lng     = customer['Longitude']?.toString() ?? '';
    final distance = customer['distance'] as double?;

    // Initials
    final parts = name.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: _T.sm),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(_T.rCard),
        boxShadow: _T.shadow,
      ),
      child: Column(
        children: [
          // ── Top row ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(_T.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_T.primaryBlue, _T.secondaryBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(_T.md),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontFamily: _T.font,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: _T.md),

                // Name + code + details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(name, style: _T.cardValue, maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                          if (showDistance && distance != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: _T.sm, vertical: _T.xs),
                              decoration: BoxDecoration(
                                color: _T.success.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(_T.rBadge),
                              ),
                              child: Text(
                                '${distance.toStringAsFixed(1)} km',
                                style: _T.smallText.copyWith(
                                  color: _T.success,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: _T.xs),
                      _codeBadge(code),
                      const SizedBox(height: _T.md),
                      if (place.isNotEmpty)   _infoChip(Icons.place_rounded, place),
                      if (city.isNotEmpty)    _infoChip(Icons.location_city_rounded, city),
                      if (address.isNotEmpty) _infoChip(Icons.home_rounded, address),
                      if (phone.isNotEmpty)   _infoChip(Icons.phone_rounded, phone),
                    ],
                  ),
                ),

                const SizedBox(width: _T.sm),

                // Location badge
                _locationBadge(hasLoc),
              ],
            ),
          ),

          // ── Divider ───────────────────────────────────────────────
          const Divider(height: 1, thickness: 1, color: _T.border),

          // ── Action bar ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(_T.md),
            child: Row(
              children: [
                Expanded(
                  child: _ghostButton(
                    label: 'View Details',
                    icon: Icons.person_rounded,
                    color: _T.primaryBlue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomerDetailsPage(customer: customer),
                      ),
                    ),
                  ),
                ),
                if (hasLoc) ...[
                  const SizedBox(width: _T.sm),
                  Expanded(
                    child: _ghostButton(
                      label: 'Open Maps',
                      icon: Icons.open_in_new_rounded,
                      color: _T.success,
                      onTap: () => _openMap(lat, lng),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Reusable widgets ──────────────────────────────────────────────

  Widget _codeBadge(String code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _T.sm, vertical: _T.xs),
      decoration: BoxDecoration(
        color: _T.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(_T.rBadge),
      ),
      child: Text(
        code.isEmpty ? '—' : code,
        style: _T.smallText.copyWith(color: _T.primaryBlue, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _locationBadge(bool hasLoc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _T.sm, vertical: _T.xs),
      decoration: BoxDecoration(
        color: hasLoc ? _T.success.withValues(alpha: 0.10) : _T.textSecondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(_T.rBadge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasLoc ? Icons.location_on_rounded : Icons.location_off_rounded,
            size: 12,
            color: hasLoc ? _T.success : _T.textSecondary,
          ),
          const SizedBox(width: _T.xs),
          Text(
            hasLoc ? 'GPS' : 'No GPS',
            style: _T.caption.copyWith(
              color: hasLoc ? _T.success : _T.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _T.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: _T.secondaryBlue),
          const SizedBox(width: _T.xs),
          Expanded(
            child: Text(value, style: _T.smallText, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _ghostButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(_T.rButton),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_T.rButton),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: _T.md),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: _T.xs),
              Text(label, style: _T.buttonText.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
            