import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'service_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<bool> _hasNotification = [false, false, false, false, false];
  DateTime? currentBackPressTime;

  void _showCustomSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (!didPop) {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            _showCustomSnackBar(
              context,
              'Press back again to exit',
              isError: true,
            );
          } else {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: _buildPageContent(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/mdi_account-service.png'),
                color: Colors.grey,
              ),
              label: 'Service',
              // Add notification dot
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/mdi_account-service.png')),
                  if (_hasNotification[0])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/ion_home.png'),
                color: Colors.grey,
              ),
              label: 'Home',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/ion_home.png')),
                  if (_hasNotification[1])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/Profile.png'),
                color: Colors.grey,
              ),
              label: 'Profile',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/Profile.png')),
                  if (_hasNotification[2])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF02AA03),
          // Customize the selected item color
          onTap: (index) {
            if (index != _selectedIndex) {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return const ServicePage();
      case 1:
        return const HomePage();
      case 2:
        return const ProfilePage();
      default:
        return const Center(child: Text("Error: Invalid page index"));
    }
  }
}
