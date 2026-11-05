import 'package:flutter/material.dart';
import '../models/field.dart';
import '../theme/app_colors.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/field_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final String _userName = 'Rafy Ramadhan';

  final List<Field> _fields = const [
    Field(
      id: 'f1',
      name: 'Lapangan Futsal A',
      sportType: 'Futsal',
      location: 'Mall XP, Karawang',
      pricePerHour: 150000,
      rating: 4.8,
    ),
    Field(
      id: 'f2',
      name: 'Lapangan Badminton Indoor',
      sportType: 'Badminton',
      location: 'Jl. Sudirman, Karawang',
      pricePerHour: 100000,
      rating: 4.6,
    ),
    Field(
      id: 'f3',
      name: 'Lapangan Basket Kelapa Gading',
      sportType: 'Basket',
      location: 'Jl. Kelapa Gading, Karawang',
      pricePerHour: 120000,
      rating: 4.7,
    ),
    Field(
      id: 'f4',
      name: 'Lapangan Futsal B',
      sportType: 'Futsal',
      location: 'Taman Ria Indah, Karawang',
      pricePerHour: 140000,
      rating: 4.5,
    ),
    Field(
      id: 'f5',
      name: 'Lapangan Badminton Outdoor',
      sportType: 'Badminton',
      location: 'Pondok Indah, Karawang',
      pricePerHour: 90000,
      rating: 4.3,
    ),
  ];

  final List<String> _categories = const [
    'Semua',
    'Futsal',
    'Badminton',
    'Basket',
    'Voli',
  ];

  int _selectedCategory = 0;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Selamat pagi';
    } else if (hour < 15) {
      return 'Selamat siang';
    } else if (hour < 18) {
      return 'Selamat sore';
    }
    return 'Selamat malam';
  }

  List<Field> _filteredFields() {
    if (_selectedCategory == 0) {
      return _fields;
    }
    return _fields
        .where((f) => f.sportType == _categories[_selectedCategory])
        .toList();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleFields = _filteredFields();

    final List<Widget> pages = [
      _buildHomeContent(visibleFields),
      const Center(child: Text('Halaman Booking')),
      const Center(child: Text('Halaman Riwayat')),
      const Center(child: Text('Halaman Profile')),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textSubtitle,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(List<Field> fields) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_greeting()},',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSubtitle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: AppColors.textDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search bar
                      CustomSearchBar(
                        hintText: 'Cari lapangan olahraga...',
                        onChanged: (value) {},
                      ),
          const SizedBox(height: 24),

          // Banner
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryGreen,
                  Color(0xFF009C66),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Promo Akhir Pekan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Diskon hingga 20% untuk booking lapangan futsal & badminton.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.local_activity,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Kategori
          const Text(
            'Kategori Olahraga',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(right: 10, bottom: 4),
                  child: CategoryChip(
                    label: _categories[index],
                    isSelected: _selectedCategory == index,
                    onTap: () {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Daftar lapangan
          const Text(
            'Lapangan Populer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...fields.map(
            (field) => FieldCard(
              field: field,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Detail ${field.name}'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
