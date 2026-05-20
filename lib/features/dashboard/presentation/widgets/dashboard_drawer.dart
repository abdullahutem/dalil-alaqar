import 'package:dalil_alaqar/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.blue),
                ),
                const SizedBox(height: 12),
                const Text(
                  'مكتب العقارات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'office@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  title: 'لوحة التحكم',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'الموظفين',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.employeesScreen);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.add_circle,
                  title: 'إضافة عقار جديد',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to add property
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.people,
                  title: 'الموظفين',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to employees
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.bar_chart,
                  title: 'التقارير',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to reports
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.card_membership,
                  title: 'الاشتراك',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to subscription
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'الإعدادات',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to settings
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help,
                  title: 'المساعدة',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to help
                  },
                ),
              ],
            ),
          ),

          // Logout Button
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              // Handle logout
              _showLogoutDialog(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: textColor ?? Colors.grey[800]),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
