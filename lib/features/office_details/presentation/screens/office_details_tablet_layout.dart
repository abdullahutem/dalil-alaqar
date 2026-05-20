import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_logo_box.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_star_row.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_chip_widget.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_circle_button.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/tablet/office_content_section.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/tablet/office_stat_cell.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/tablet/office_vertical_divider.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/tablet/office_side_label.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/tablet/office_side_info_row.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/tablet/office_action_button.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/tablet/office_property_card_tablet.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficeDetailsTabletLayout extends StatelessWidget {
  final OfficeDetailsEntity officeDetails;

  // Replace with your real storage base URL
  static const String _baseImageUrl = 'https://yourdomain.com/storage/';

  const OfficeDetailsTabletLayout({super.key, required this.officeDetails});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Palette ──────────────────────────────────────────────────────────────
    final surface = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final bg = isDark ? const Color(0xFF111111) : const Color(0xFFF2F2F7);
    final border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.40)
        : Colors.black.withValues(alpha: 0.38);
    final secondary = isDark
        ? Colors.white.withValues(alpha: 0.62)
        : Colors.black.withValues(alpha: 0.55);
    final primary = isDark ? Colors.white : Colors.black;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        // ── Top App Bar ───────────────────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: surface,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          shadowColor: border,
          automaticallyImplyLeading: false,
          titleSpacing: 24,
          title: Row(
            children: [
              OfficeCircleButton(
                icon: Icons.arrow_back_ios_rounded,
                isDark: isDark,
                border: border,
                onTap: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  officeDetails.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: primary,
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.5),
            child: Divider(height: 0.5, thickness: 0.5, color: border),
          ),
        ),

        // ── Body: two-column layout ───────────────────────────────────────────
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── LEFT SIDEBAR (sticky) ─────────────────────────────────────────
            SizedBox(
              width: 320,
              child: Container(
                decoration: BoxDecoration(
                  color: surface,
                  border: Border(left: BorderSide(color: border, width: 0.5)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo + name
                      Center(
                        child: OfficeLogoBox(
                          logoUrl: officeDetails.logo,
                          isDark: isDark,
                          border: border,
                          muted: muted,
                          size: 88,
                          radius: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          officeDetails.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primary,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          '${officeDetails.governorate} · ${officeDetails.district}',
                          style: TextStyle(fontSize: 13, color: secondary),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: OfficeStarRow(
                          rating: double.parse(officeDetails.rating) ?? 0.0,
                          count: officeDetails.totalRatings,
                          muted: muted,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Badges
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: [
                          if (officeDetails.isVerified)
                            OfficeChipWidget(
                              label: 'موثّق',
                              icon: Icons.verified_rounded,
                              accent: true,
                              border: border,
                            ),
                          if (officeDetails.subscriptionType != null)
                            OfficeChipWidget(
                              label: officeDetails.subscriptionType!,
                              border: border,
                            ),
                          if (officeDetails.commercialLicense != null)
                            OfficeChipWidget(
                              label: officeDetails.commercialLicense!,
                              icon: Icons.badge_outlined,
                              border: border,
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      Divider(height: 1, thickness: 0.5, color: border),
                      const SizedBox(height: 24),

                      // Stats
                      Row(
                        children: [
                          OfficeStatCell(
                            value: officeDetails.totalProperties.toString(),
                            label: 'عقارات',
                            primary: primary,
                            muted: muted,
                          ),
                          OfficeVerticalDivider(color: border),
                          OfficeStatCell(
                            value: officeDetails.totalViews.toString(),
                            label: 'مشاهدة',
                            primary: primary,
                            muted: muted,
                          ),
                          OfficeVerticalDivider(color: border),
                          OfficeStatCell(
                            value: officeDetails.rating,
                            label: 'التقييم',
                            primary: primary,
                            muted: muted,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      Divider(height: 1, thickness: 0.5, color: border),
                      const SizedBox(height: 20),

                      // Contact rows
                      OfficeSideLabel(text: 'التواصل والموقع', muted: muted),
                      const SizedBox(height: 12),
                      OfficeSideInfoRow(
                        icon: Icons.location_on_outlined,
                        value: officeDetails.address,
                        muted: muted,
                        isDark: isDark,
                        border: border,
                      ),
                      OfficeSideInfoRow(
                        icon: Icons.phone_outlined,
                        value: officeDetails.phone,
                        muted: muted,
                        isDark: isDark,
                        border: border,
                        onTap: () => _launch('tel:${officeDetails.phone}'),
                      ),
                      if (officeDetails.mobilePhone != null)
                        OfficeSideInfoRow(
                          icon: Icons.smartphone_outlined,
                          value: officeDetails.mobilePhone!,
                          muted: muted,
                          isDark: isDark,
                          border: border,
                          onTap: () =>
                              _launch('tel:${officeDetails.mobilePhone}'),
                        ),
                      if (officeDetails.email != null)
                        OfficeSideInfoRow(
                          icon: Icons.mail_outline_rounded,
                          value: officeDetails.email!,
                          muted: muted,
                          isDark: isDark,
                          border: border,
                        ),
                      OfficeSideInfoRow(
                        icon: Icons.person_outline_rounded,
                        value: officeDetails.ownerName,
                        muted: muted,
                        isDark: isDark,
                        border: border,
                        isLast: true,
                      ),

                      const SizedBox(height: 24),

                      // CTA buttons
                      OfficeActionButton(
                        label: 'اتصال',
                        icon: Icons.phone_rounded,
                        isDark: isDark,
                        border: border,
                        onTap: () => _launch('tel:${officeDetails.phone}'),
                      ),
                      const SizedBox(height: 10),
                      if (officeDetails.whatsappNumber != null)
                        OfficeActionButton(
                          label: 'واتساب',
                          icon: Icons.chat_rounded,
                          isDark: isDark,
                          border: border,
                          accent: true,
                          onTap: () => _launch(
                            'https://wa.me/${officeDetails.whatsappNumber!.replaceAll('+', '')}',
                          ),
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // ── RIGHT CONTENT (scrollable) ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    if (officeDetails.description != null) ...[
                      OfficeContentSection(
                        title: 'نبذة عن المكتب',
                        surface: surface,
                        border: border,
                        muted: muted,
                        child: Text(
                          officeDetails.description!,
                          style: TextStyle(
                            fontSize: 15,
                            color: secondary,
                            height: 1.75,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Properties grid
                    if (officeDetails.recentProperties.isNotEmpty) ...[
                      OfficeContentSection(
                        title: 'أحدث العقارات',
                        surface: surface,
                        border: border,
                        muted: muted,
                        trailing: Text(
                          'عرض الكل',
                          style: TextStyle(fontSize: 13, color: muted),
                        ),
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            // Responsive: 2 or 3 columns based on available width
                            final cols = constraints.maxWidth > 600 ? 3 : 2;
                            final gap = 12.0;
                            final cardW =
                                (constraints.maxWidth - gap * (cols - 1)) /
                                cols;

                            return Wrap(
                              spacing: gap,
                              runSpacing: gap,
                              children: officeDetails.recentProperties
                                  .map(
                                    (p) => SizedBox(
                                      width: cardW,
                                      child: OfficePropertyCardTablet(
                                        property: p,
                                        border: border,
                                        muted: muted,
                                        isDark: isDark,
                                        baseImageUrl: _baseImageUrl,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
