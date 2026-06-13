import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/core/utils/price_formatter.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/bottom_bar.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/circle_btn.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/quick_info_strip.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/property_loading_view.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/property_error_view.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/property_card.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/property_section_label.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/property_badge_pill.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/property_info_row.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/property_image_gallery.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/office_contact_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/property_details_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/property_details_state.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsMobileLayout extends StatelessWidget {
  const PropertyDetailsMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
      builder: (context, state) {
        if (state is PropertyDetailsLoading) {
          return const PropertyLoadingView();
        }
        if (state is PropertyDetailsError) {
          print(state.message);
          return PropertyErrorView(message: state.message);
        }
        if (state is PropertyDetailsSuccess) {
          return _PropertyView(property: state.property);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main property view
// ─────────────────────────────────────────────────────────────────────────────

class _PropertyView extends StatefulWidget {
  final PropertyDetailsEntity property;
  const _PropertyView({required this.property});

  @override
  State<_PropertyView> createState() => _PropertyViewState();
}

class _PropertyViewState extends State<_PropertyView> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  bool _showOfficeContacts = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
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

    final images = p.images.isNotEmpty
        ? p.images
        : (p.primaryImage != null ? [p.primaryImage!] : <PropertyImage>[]);

    final isForSale = p.offerType.name.contains('بيع');
    final offerBg = isForSale
        ? const Color(0xFFEAF3DE)
        : const Color(0xFFE6F1FB);
    final offerFg = isForSale
        ? const Color(0xFF3B6D11)
        : const Color(0xFF185FA5);
    final offerBorder = isForSale
        ? const Color(0xFFC0DD97)
        : const Color(0xFFB5D4F4);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Image Gallery App Bar ─────────────────────────────────────
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: surface,
                elevation: 0,
                scrolledUnderElevation: 0.5,
                shadowColor: border,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    CircleBtn(
                      icon: Icons.arrow_forward_ios,
                      isDark: isDark,
                      border: border,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: PropertyImageGallery(
                    images: images,
                    pageController: _pageController,
                    currentIndex: _currentImageIndex,
                    onPageChanged: (i) =>
                        setState(() => _currentImageIndex = i),
                    isDark: isDark,
                    muted: muted,
                    border: border,
                    baseUrl: EndPoints.kBaseImageUrl,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title & Price Card ──────────────────────────────────
                    OfficeInfoCard(
                      surface: surface,
                      border: border,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Offer badge + type badge
                          Row(
                            children: [
                              PropertyBadgePill(
                                label: p.offerType.name,
                                bg: offerBg,
                                fg: offerFg,
                                borderColor: offerBorder,
                              ),
                              const SizedBox(width: 6),
                              PropertyBadgePill(
                                label: p.propertyType.name,
                                bg: isDark
                                    ? Colors.white.withValues(alpha: 0.07)
                                    : Colors.black.withValues(alpha: 0.04),
                                fg: secondary,
                                borderColor: border,
                              ),
                              const Spacer(),
                              // Views
                              Icon(
                                Icons.remove_red_eye_outlined,
                                size: 13,
                                color: muted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                p.viewsCount.toString(),
                                style: TextStyle(fontSize: 12, color: muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            p.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: primary,
                              height: 1.3,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: muted,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${p.governorate.nameAr} · ${p.district.nameAr} · ${p.neighborhood.nameAr}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: secondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${_formatPrice(p.price)} ${_getCurrencySymbol(p)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D9E75),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (p.priceNegotiable)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.07)
                                        : Colors.black.withValues(alpha: 0.04),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: border,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    'قابل للتفاوض',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: secondary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Quick Info Strip ────────────────────────────────────
                    QuickInfoStrip(
                      items: [
                        (
                          icon: Icons.tag_rounded,
                          label: 'الرقم المرجعي',
                          value: p.referenceNumber,
                        ),
                        (
                          icon: Icons.home_work_outlined,
                          label: 'النوع',
                          value: p.propertyType.name,
                        ),
                        (
                          icon: Icons.sell_outlined,
                          label: 'الحالة',
                          value: p.status == 'available' ? 'متاح' : p.status,
                        ),
                      ],
                      surface: surface,
                      border: border,
                      muted: muted,
                      primary: primary,
                      secondary: secondary,
                      isDark: isDark,
                    ),

                    // ── Description ─────────────────────────────────────────
                    if (p.description.isNotEmpty)
                      OfficeInfoCard(
                        surface: surface,
                        border: border,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PropertySectionLabel(
                              text: 'وصف العقار',
                              muted: muted,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              p.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: secondary,
                                height: 1.75,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // ── Location Detail ─────────────────────────────────────
                    OfficeInfoCard(
                      surface: surface,
                      border: border,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: PropertySectionLabel(
                                  text: 'الموقع',
                                  muted: muted,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _openMap(p.latitude, p.longitude),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.07)
                                        : Colors.black.withValues(alpha: 0.04),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: border,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.map_outlined,
                                    size: 18,
                                    color: muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          PropertyInfoRow(
                            icon: Icons.location_on_outlined,
                            label: 'العنوان',
                            value: p.address,
                            border: border,
                            muted: muted,
                            isDark: isDark,
                          ),
                          PropertyInfoRow(
                            icon: Icons.map_outlined,
                            label: 'المحافظة',
                            value: p.governorate.nameAr,
                            border: border,
                            muted: muted,
                            isDark: isDark,
                          ),
                          PropertyInfoRow(
                            icon: Icons.place_outlined,
                            label: 'المديرية',
                            value: p.district.nameAr,
                            border: border,
                            muted: muted,
                            isDark: isDark,
                          ),
                          PropertyInfoRow(
                            icon: Icons.near_me_outlined,
                            label: 'الحي',
                            value: p.neighborhood.nameAr,
                            border: border,
                            muted: muted,
                            isDark: isDark,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    // ── Office Card ─────────────────────────────────────────
                    OfficeInfoCard(
                      surface: surface,
                      border: border,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PropertySectionLabel(
                            text: 'المكتب العقاري',
                            muted: muted,
                          ),
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: () => setState(() {
                              _showOfficeContacts = !_showOfficeContacts;
                            }),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.06)
                                        : Colors.black.withValues(alpha: 0.04),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: border,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.business_rounded,
                                    size: 22,
                                    color: muted,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.office.name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: primary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        p.office.email,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: secondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: _showOfficeContacts ? 0.25 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 13,
                                    color: muted,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Contact buttons (expandable)
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: _showOfficeContacts
                                ? Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      Divider(
                                        height: 1,
                                        thickness: 0.5,
                                        color: border,
                                      ),
                                      const SizedBox(height: 16),

                                      // Phone button
                                      OfficeContactButton(
                                        icon: Icons.phone_rounded,
                                        label: 'اتصال',
                                        value: p.office.phone,
                                        isDark: isDark,
                                        border: border,
                                        muted: muted,
                                        primary: primary,
                                        onTap: () =>
                                            _launchUrl('tel:${p.office.phone}'),
                                      ),
                                      const SizedBox(height: 10),

                                      // WhatsApp button
                                      OfficeContactButton(
                                        icon: Icons.chat_rounded,
                                        label: 'واتساب',
                                        value: p.office.whatsappNumber,
                                        isDark: isDark,
                                        border: border,
                                        muted: muted,
                                        primary: primary,
                                        accent: true,
                                        onTap: () => _launchUrl(
                                          'https://wa.me/${p.office.whatsappNumber.replaceAll('+', '')}',
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),

                    // Bottom padding for FABs
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // ── Bottom Action Bar ───────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(
              property: p,
              isDark: isDark,
              surface: surface,
              border: border,
              muted: muted,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openMap(String latitude, String longitude) async {
    final lat = double.tryParse(latitude);
    final lng = double.tryParse(longitude);
    if (lat == null || lng == null || (lat == 0 && lng == 0)) return;

    final googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    final geoUri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');

    final opened = await launchUrl(
      googleMapsUri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatPrice(String price) {
    return PriceFormatter.formatWithSeparators(price, locale: 'ar');
  }

  String _getCurrencySymbol(PropertyDetailsEntity property) {
    return property.currency?.symbol ?? 'ريال';
  }
}
