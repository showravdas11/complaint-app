import 'package:complaint_app/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 280, // Set custom width
        height: double.infinity, // Set height to fill the screen
        decoration: const BoxDecoration(color: Color(0xFF2A4320)),
        child: Column(
          children: [
            _buildProfileHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashBoardScreen()));
                      }),
                  _buildMenuItem(
                      icon: Icons.message, title: 'Messaenger', onTap: () {}),
                  _buildMenuItem(
                      icon: Icons.warning, title: 'Issue', onTap: () {}),
                  _buildDivider(),
                  _buildMenuItem(
                      icon: Icons.settings,
                      title: 'issue Configuration',
                      onTap: () {}),
                  _buildMenuItem(
                      icon: Icons.people,
                      title: 'Members management',
                      onTap: () {}),
                  _buildDivider(),
                  _buildMenuItem(
                      icon: Icons.person, title: 'Manage Users', onTap: () {}),
                  _buildMenuItem(
                      icon: Icons.help, title: 'Appearance', onTap: () {}),
                ],
              ),
            ),
            // _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Image.asset(
          "assets/images/logo2.png",
          width: 150,
          height: 100,
        )
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.5),
      thickness: 0.6,
      indent: 16,
      endIndent: 16,
    );
  }

  // Widget _buildFooter(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.all(16.0),
  //     child: ElevatedButton.icon(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.redAccent,
  //         foregroundColor: Colors.white,
  //         padding: EdgeInsets.symmetric(vertical: 14),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(30),
  //         ),
  //       ),
  //       icon: Icon(Icons.exit_to_app),
  //       label: Text(
  //         'Logout',
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  // }
}
