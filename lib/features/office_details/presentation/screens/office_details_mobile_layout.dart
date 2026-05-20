import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_card_widget.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_label_widget.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_logo_box.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_star_row.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_chip_widget.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_stats_strip.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_info_row.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_property_card.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_circle_button.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_fab_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficeDetailsMobileLayout extends StatelessWidget {
  final OfficeDetailsEntity officeDetails;

  const OfficeDetailsMobileLayout({super.key, required this.officeDetails});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Palette ────────────────────────────────────────────────────────────
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

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── App Bar ────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: surface,
                elevation: 0,
                scrolledUnderElevation: 0.5,
                shadowColor: border,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    OfficeCircleButton(
                      icon: Icons.arrow_back_ios_rounded,
                      isDark: isDark,
                      border: border,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        officeDetails.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primary,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ─────────────────────────────────────────
                    OfficeCardWidget(
                      surface: surface,
                      border: border,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Logo / placeholder
                              OfficeLogoBox(
                                logoUrl: officeDetails.logo,
                                isDark: isDark,
                                border: border,
                                muted: muted,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      officeDetails.name,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: primary,
                                        height: 1.25,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${officeDetails.governorate} · ${officeDetails.district}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: secondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    OfficeStarRow(
                                      rating:
                                          double.tryParse(
                                            officeDetails.rating,
                                          ) ??
                                          0.0,
                                      count: officeDetails.totalRatings,
                                      muted: muted,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
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
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Stats Strip ────────────────────────────────────
                    OfficeStatsStrip(
                      items: [
                        (
                          value: officeDetails.totalProperties.toString(),
                          label: 'عقارات',
                        ),
                        (
                          value: officeDetails.totalViews.toString(),
                          label: 'مشاهدة',
                        ),
                        (value: officeDetails.rating, label: 'التقييم'),
                      ],
                      surface: surface,
                      border: border,
                      muted: muted,
                      primary: primary,
                    ),

                    // ── Description ────────────────────────────────────
                    if (officeDetails.description != null)
                      OfficeCardWidget(
                        surface: surface,
                        border: border,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OfficeLabelWidget(
                              text: 'نبذة عن المكتب',
                              muted: muted,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              officeDetails.description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: secondary,
                                height: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // ── Contact & Location ─────────────────────────────
                    OfficeCardWidget(
                      surface: surface,
                      border: border,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OfficeLabelWidget(
                            text: 'التواصل والموقع',
                            muted: muted,
                          ),
                          const SizedBox(height: 4),
                          OfficeInfoRow(
                            icon: Icons.location_on_outlined,
                            label: 'العنوان',
                            value: officeDetails.address,
                            border: border,
                            muted: muted,
                            isDark: isDark,
                          ),
                          OfficeInfoRow(
                            icon: Icons.phone_outlined,
                            label: 'الهاتف',
                            value: officeDetails.phone,
                            border: border,
                            muted: muted,
                            isDark: isDark,
                            onTap: () => _launch('tel:${officeDetails.phone}'),
                          ),
                          if (officeDetails.mobilePhone != null)
                            OfficeInfoRow(
                              icon: Icons.smartphone_outlined,
                              label: 'الجوال',
                              value: officeDetails.mobilePhone!,
                              border: border,
                              muted: muted,
                              isDark: isDark,
                              onTap: () =>
                                  _launch('tel:${officeDetails.mobilePhone}'),
                            ),
                          if (officeDetails.email != null)
                            OfficeInfoRow(
                              icon: Icons.mail_outline_rounded,
                              label: 'البريد الإلكتروني',
                              value: officeDetails.email!,
                              border: border,
                              muted: muted,
                              isDark: isDark,
                            ),
                          OfficeInfoRow(
                            icon: Icons.person_outline_rounded,
                            label: 'المالك',
                            value: officeDetails.ownerName,
                            border: border,
                            muted: muted,
                            isDark: isDark,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    // ── Recent Properties ──────────────────────────────
                    if (officeDetails.recentProperties.isNotEmpty)
                      OfficeCardWidget(
                        surface: surface,
                        border: border,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OfficeLabelWidget(
                                      text: 'أحدث العقارات',
                                      muted: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 210,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(left: 20),
                                itemCount:
                                    officeDetails.recentProperties.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (ctx, i) => OfficePropertyCard(
                                  property: officeDetails.recentProperties[i],
                                  border: border,
                                  muted: muted,
                                  isDark: isDark,
                                  baseImageUrl:
                                      'https://yourdomain.com/storage/',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // ── FABs ────────────────────────────────────────────────────────
          Positioned(
            bottom: 24,
            left: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OfficeFabButton(
                  heroTag: 'call',
                  icon: Icons.phone_rounded,
                  tooltip: 'اتصال',
                  isDark: isDark,
                  onTap: () => _launch('tel:${officeDetails.phone}'),
                ),
                const SizedBox(height: 10),
                if (officeDetails.whatsappNumber != null)
                  OfficeFabButton(
                    heroTag: 'whatsapp',
                    icon: Icons.chat_rounded,
                    tooltip: 'واتساب',
                    isDark: isDark,
                    accent: true,
                    onTap: () => _launch(
                      'https://wa.me/${officeDetails.whatsappNumber!.replaceAll('+', '')}',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
