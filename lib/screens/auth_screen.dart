import 'package:flutter/material.dart';
import 'login_view.dart';
import 'register_view.dart';

class AuthScreen extends StatefulWidget {
  final int initialTab; // 0 for Masuk, 1 for Daftar

  const AuthScreen({
    super.key,
    this.initialTab = 1, // Default to Daftar or Masuk
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  void _onTabChanged(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _selectedTab == 0
              ? LoginView(
                  key: const ValueKey('login_view'),
                  onTabChanged: _onTabChanged,
                )
              : RegisterView(
                  key: const ValueKey('register_view'),
                  onTabChanged: _onTabChanged,
                ),
        ),
      ),
    );
  }
}
