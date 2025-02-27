import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mobile/_dashboard_mobile.dart';
import '../web/_dashboard_web.dart';

class DashboardUi extends StatelessWidget {
  final bool
      isAdministrator; // Making isAdministrator final to ensure immutability

  const DashboardUi({Key? key, required this.isAdministrator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    // No need to retrieve height, as it's not used in this code.

    return Scaffold(
      bottomNavigationBar: (dWidth > 600)
          ? null
          : BottomNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.home,
                    size: 20,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.profile_circled,
                    size: 20,
                  ),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.settings,
                    size: 20,
                  ),
                  label: 'Settings',
                ),
              ],
            ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: (dWidth > 600)
            ? WebDashboard(
                isAdministrator: isAdministrator,
              )
            : const MobileDashboard(),
      ),
    );
  }
}
