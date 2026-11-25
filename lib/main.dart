import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const BookingLapanganApp());
}

class BookingLapanganApp extends StatelessWidget {
  const BookingLapanganApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Lapangan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
        ),
        fontFamily: 'Segoe UI', // Standard crisp clean sans font
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/auth': (context) => AuthScreen(
              onLoginSuccess: () =>
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
            ),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
