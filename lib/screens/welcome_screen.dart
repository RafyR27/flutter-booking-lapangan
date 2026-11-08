import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class WelcomeSlide {
  final String imageUrl;
  final String sportCategory;
  final String quote;
  final String author;

  const WelcomeSlide({
    required this.imageUrl,
    required this.sportCategory,
    required this.quote,
    required this.author,
  });
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;
  Timer? _carouselTimer;

  static const List<WelcomeSlide> _slides = [
    WelcomeSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&w=1080&q=80',
      sportCategory: 'FUTSAL & MINI SOCCER',
      quote:
          'Kemenangan hari ini lahir dari disiplin dan konsistensi latihan kemarin.',
      author: 'Etos Juara Lapangan',
    ),
    WelcomeSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?auto=format&fit=crop&w=1080&q=80',
      sportCategory: 'BULUTANGKIS INDOOR',
      quote:
          'Kecepatan reli dan fokus tanpa henti membedakan juara dari pemain biasa.',
      author: 'Presisi & Refleks',
    ),
    WelcomeSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&w=1080&q=80',
      sportCategory: 'BASKETBALL PRO',
      quote:
          'Kerja keras mengalahkan bakat ketika bakat tidak bekerja keras di lapangan.',
      author: 'Mentalitas Kompetisi',
    ),
    WelcomeSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?auto=format&fit=crop&w=1080&q=80',
      sportCategory: 'BOLA VOLI',
      quote:
          'Kekompakan satu tim adalah pondasi kokoh penakluk setiap tantangan servis.',
      author: 'Semangat Kolaborasi',
    ),
    WelcomeSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=1080&q=80',
      sportCategory: 'STAMINA & KEBUGARAN',
      quote:
          'Setiap tetes keringat adalah investasi terbaik untuk kesehatan dan performamu.',
      author: 'Komitmen Atlet',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _slides.length;
        });
      }
    });
  }

  void _navigateToAuth(int initialTab) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AuthScreen(
          initialTab: initialTab,
          onLoginSuccess: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeSlide = _slides[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF090D14),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Carousel with Smooth Crossfade
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: Image.network(
              activeSlide.imageUrl,
              key: ValueKey<String>(activeSlide.imageUrl),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFF141A24),
                child: const Center(
                  child: Icon(
                    Icons.sports_outlined,
                    size: 64,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),

          // Cinematic Gradients Overlay (Anti-Slop Restrained Matte Depth)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.35, 0.65, 1.0],
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.25),
                  Colors.black.withValues(alpha: 0.75),
                  const Color(0xFF0A0E17).withValues(alpha: 0.98),
                ],
              ),
            ),
          ),

          // Content Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Brand Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'APEX SPORT KARAWANG',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Platform Reservasi Fasilitas Olahraga',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withValues(alpha: 0.8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Jelajahi',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Quotes & Sports Category Chamber
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      key: ValueKey<int>(_currentIndex),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryGreen.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Text(
                            activeSlide.sportCategory,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryGreen,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Quote Text
                        Text(
                          '"${activeSlide.quote}"',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.35,
                            letterSpacing: -0.2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Author / Context
                        Text(
                          activeSlide.author,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Carousel Progress Indicators
                  Row(
                    children: List.generate(_slides.length, (index) {
                      final isActive = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 4,
                        width: isActive ? 26 : 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryGreen
                              : Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  // Action Chamber (Clear, balanced, intentional UX layout)
                  // 1. Primary Action Button: Daftar Akun Baru
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _navigateToAuth(1), // Tab 1 = Daftar
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Daftar Akun Baru',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 2. Secondary Text Action: Sudah punya akun? Masuk
                  Center(
                    child: GestureDetector(
                      onTap: () => _navigateToAuth(0), // Tab 0 = Masuk
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: RichText(
                          text: TextSpan(
                            text: 'Sudah punya akun? ',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            children: const [
                              TextSpan(
                                text: 'Masuk di sini',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryGreen,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
