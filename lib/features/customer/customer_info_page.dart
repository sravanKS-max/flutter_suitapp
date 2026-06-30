// import 'package:flutter/material.dart';

// class CustomerInfoPage extends StatelessWidget {
//   final Map<String,dynamic> customer;

//   const CustomerInfoPage({
//     super.key,
//     required this.customer,
//   });


//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor: const Color(0xfff7f7f7),

//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: const Text(
//           "Customer Info",
//           style: TextStyle(color: Colors.black),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),


//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),

//         child: Column(
//           children: [


//             // CUSTOMER CARD
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: box(),

//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   Text(
//                     "${customer['AccountName'] ?? ''} (${customer['AccountCode'] ?? ''})",
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),


//                   const SizedBox(height:10),


//                   row(
//                     Icons.phone,
//                     customer['Mob'] ?? customer['Phone'] ?? '',
//                   ),

//                   const SizedBox(height:8),


//                   row(
//                     Icons.location_on,
//                     customer['Address'] ?? '',
//                   ),


//                   const SizedBox(height:8),


//                   row(
//                     Icons.location_city,
//                     customer['City'] ?? '',
//                   ),

//                 ],
//               ),
//             ),



//             const SizedBox(height:15),



//             // MENU GRID
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: box(),

//               child: GridView.count(
//                 crossAxisCount: 4,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisSpacing:10,
//                 mainAxisSpacing:10,

//                 children: [

//                   menu(Icons.shopping_cart,"Primary\nOrder"),

//                   menu(Icons.local_shipping,"Secondary\nSales"),

//                   menu(Icons.person,"Counter\nSales"),

//                   menu(Icons.store,"Outlets"),

//                   menu(Icons.analytics,"Projection"),

//                   menu(Icons.delivery_dining,"Van Sales"),

//                   menu(Icons.inventory,"GRN"),

//                   menu(Icons.shopping_bag,"Stock\nUpload"),

//                 ],
//               ),
//             ),



//             const SizedBox(height:15),



//             // DATE
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: box(),

//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [

//                   Text(
//                     "Date",
//                     style: TextStyle(
//                       fontSize:18,
//                       fontWeight:FontWeight.bold,
//                     ),
//                   ),

//                   Text(
//                     "03-FEB-2025",
//                     style: TextStyle(
//                       fontWeight:FontWeight.bold,
//                     ),
//                   )

//                 ],
//               ),
//             ),



//             const SizedBox(height:15),



//             // SALES DETAILS
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: box(),

//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [

//                       Text(
//                         "Secondary Sales Details",
//                         style: TextStyle(
//                           fontSize:18,
//                           fontWeight:FontWeight.bold,
//                         ),
//                       ),

//                       Icon(Icons.visibility)

//                     ],
//                   ),


//                   const Divider(),


//                   detail("SKU", "0"),
//                   detail("Invoice", "0"),
//                   detail("QTY", "0"),
//                   detail("No Order", "0"),
//                   detail("Sales Return", "0"),

//                 ],
//               ),
//             )

//           ],
//         ),
//       ),
//     );
//   }




//   Widget menu(IconData icon,String title){

//     return Container(
//       decoration: box(),

//       child: Column(
//         mainAxisAlignment:MainAxisAlignment.center,

//         children:[

//           Icon(
//             icon,
//             size:35,
//             color:Colors.blue,
//           ),

//           const SizedBox(height:8),

//           Text(
//             title,
//             textAlign:TextAlign.center,
//             style:const TextStyle(
//               fontWeight:FontWeight.bold,
//               fontSize:12,
//             ),
//           )

//         ],
//       ),
//     );
//   }




//   Widget row(IconData icon,String text){

//     return Row(
//       children:[

//         Icon(icon,size:20),

//         const SizedBox(width:8),

//         Expanded(
//           child:Text(text),
//         )

//       ],
//     );
//   }



//   Widget detail(String a,String b){

//     return Padding(
//       padding:const EdgeInsets.symmetric(vertical:8),

//       child:Row(
//         mainAxisAlignment:MainAxisAlignment.spaceBetween,

//         children:[

//           Text(a),

//           Text(
//             b,
//             style:const TextStyle(
//               fontWeight:FontWeight.bold,
//             ),
//           )

//         ],
//       ),
//     );
//   }



//   BoxDecoration box(){

//     return BoxDecoration(
//       color:Colors.white,
//       borderRadius:BorderRadius.circular(14),
//       boxShadow:[
//         BoxShadow(
//           blurRadius:8,
//           color:Colors.black12,
//         )
//       ],
//     );
//   }

// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ════════════════════════════════════════════════════════════
// DESIGN SYSTEM
// ════════════════════════════════════════════════════════════

class AppColors {
  static const Color primary = Color(0xFF1433C3);
  static const Color secondary = Color(0xFF6F7FDB);

  static const Color background = Color(0xFFF5F7FB);
  static const Color cardBg = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color border = Color(0xFFE5E7EB);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
}

class AppFonts {
  static TextStyle pageTitle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle sectionTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static TextStyle cardValue = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );

  static TextStyle cardTitle = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );

  static TextStyle buttonText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.cardBg,
  );

  static TextStyle inputText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle smallText = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadius {
  static const double card = 16;
  static const double button = 12;
  static const double textField = 12;
  static const double dialog = 16;
  static const double bottomSheet = 20;
  static const double badge = 16;
}

class AppShadows {
  static BoxShadow card = BoxShadow(
    color: AppColors.textPrimary.withOpacity(0.05),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
}

class AppIcons {
  static const double cardIcon = 16;
  static const double listTile = 20;
  static const double appBar = 24;
  static const double fab = 24;
}

class AppLayout {
  static const double screenPadding = 16;
  static const double cardGap = 8;
  static const double sectionGap = 16;
  static const double pageGap = 24;
}

// ════════════════════════════════════════════════════════════
// DATA MODELS
// ════════════════════════════════════════════════════════════

class MenuItemData {
  final IconData icon;
  final String title;
  final Color color;

  const MenuItemData(this.icon, this.title, this.color);
}

class DetailItemData {
  final String label;
  final String value;
  final Color color;

  const DetailItemData(this.label, this.value, this.color);
}

// ════════════════════════════════════════════════════════════
// CUSTOMER INFO PAGE
// ════════════════════════════════════════════════════════════

class CustomerInfoPage extends StatelessWidget {
  final Map<String, dynamic> customer;

  const CustomerInfoPage({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Customer Info",
          style: AppFonts.pageTitle,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppLayout.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── CUSTOMER CARD ──
            _buildCustomerCard(),

            const SizedBox(height: AppLayout.sectionGap),

            // ── QUICK ACTIONS GRID ──
            _buildMenuGrid(),

            const SizedBox(height: AppLayout.sectionGap),

            // ── DATE CARD ──
            _buildDateCard(),

            const SizedBox(height: AppLayout.sectionGap),

            // ── SALES DETAILS CARD ──
            _buildSalesDetailsCard(),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // CUSTOMER CARD
  // ════════════════════════════════════════════════════════════

  Widget _buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [AppShadows.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Avatar + Name + Status Badge
          Row(
            children: [
              // Avatar Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: const Icon(
                  Icons.storefront,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Name & Code
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${customer['AccountName'] ?? 'Unknown'}",
                      style: AppFonts.sectionTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      "Code: ${customer['AccountCode'] ?? 'N/A'}",
                      style: AppFonts.smallText,
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.badge),
                ),
                child: Text(
                  "Active",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.lg),

          // Contact Info Rows
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: "Mobile",
            value: customer['Mob'] ?? customer['Phone'] ?? 'N/A',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: "Address",
            value: customer['Address'] ?? 'N/A',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            icon: Icons.location_city_outlined,
            label: "City",
            value: customer['City'] ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon Container
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: AppIcons.listTile,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        // Label + Value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppFonts.caption),
              const SizedBox(height: 2),
              Text(value, style: AppFonts.body),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // QUICK ACTIONS GRID
  // ════════════════════════════════════════════════════════════

  Widget _buildMenuGrid() {
    const menuItems = [
      MenuItemData(Icons.shopping_cart_outlined, "Primary\nOrder", AppColors.primary),
      MenuItemData(Icons.local_shipping_outlined, "Secondary\nSales", AppColors.secondary),
      MenuItemData(Icons.person_outline, "Counter\nSales", AppColors.warning),
      MenuItemData(Icons.store_outlined, "Outlets", AppColors.success),
      MenuItemData(Icons.analytics_outlined, "Projection", AppColors.error),
      MenuItemData(Icons.delivery_dining_outlined, "Van Sales", AppColors.primary),
      MenuItemData(Icons.inventory_2_outlined, "GRN", AppColors.secondary),
      MenuItemData(Icons.shopping_bag_outlined, "Stock\nUpload", AppColors.success),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quick Actions", style: AppFonts.sectionTitle),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.85,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return _buildMenuItem(menuItems[index]);
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(MenuItemData item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [AppShadows.card],
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    size: 22,
                    color: item.color,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Title
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: AppFonts.cardTitle.copyWith(color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // DATE CARD
  // ════════════════════════════════════════════════════════════

  Widget _buildDateCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [AppShadows.card],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Icon + Label
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text("Date", style: AppFonts.sectionTitle),
            ],
          ),

          // Right: Date Pill
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              "03-FEB-2025",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // SALES DETAILS CARD
  // ════════════════════════════════════════════════════════════

  Widget _buildSalesDetailsCard() {
    const details = [
      DetailItemData("SKU", "0", AppColors.primary),
      DetailItemData("Invoice", "0", AppColors.secondary),
      DetailItemData("QTY", "0", AppColors.success),
      DetailItemData("No Order", "0", AppColors.warning),
      DetailItemData("Sales Return", "0", AppColors.error),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [AppShadows.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Secondary Sales Details", style: AppFonts.sectionTitle),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.visibility_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.md),

          // Detail Rows
          ...details.map((d) => _buildDetailRow(d)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(DetailItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Dot + Label
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(item.label, style: AppFonts.body),
            ],
          ),
          // Right: Value
          Text(
            item.value,
            style: AppFonts.cardValue.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}