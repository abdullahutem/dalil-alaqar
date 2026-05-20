import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/mobile/bar_btn.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomBar extends StatelessWidget {
  final PropertyDetailsEntity property;
  final bool isDark;
  final Color surface, border, muted;

  const BottomBar({
    required this.property,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.muted,
  });

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final teal = isDark ? const Color(0xFF5DCAA5) : const Color(0xFF0F6E56);
    final tealBg = isDark ? const Color(0xFF1A3326) : const Color(0xFFEAF3DE);
    final tealBorder = isDark
        ? const Color(0xFF2A5040)
        : const Color(0xFF9FE1CB);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border, width: 0.5)),
      ),
      padding: EdgeInsets.only(
        top: 12,
        right: 20,
        left: 20,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          // Call button
          Expanded(
            child: BarBtn(
              label: 'اتصال',
              icon: Icons.phone_rounded,
              isDark: isDark,
              border: border,
              fg: isDark ? Colors.white : Colors.black,
              bg: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : Colors.black.withValues(alpha: 0.04),
              onTap: () => _launch('tel:${property.office.phone}'),
            ),
          ),
          const SizedBox(width: 10),
          // WhatsApp button
          Expanded(
            flex: 2,
            child: BarBtn(
              label: 'تواصل عبر واتساب',
              icon: Icons.chat_rounded,
              isDark: isDark,
              border: tealBorder,
              fg: teal,
              bg: tealBg,
              onTap: () => _launch(
                'https://wa.me/${property.office.whatsappNumber.replaceAll('+', '')}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
