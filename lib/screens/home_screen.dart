import 'package:flutter/material.dart';
import '../models/field.dart';
import '../theme/app_colors.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/field_card.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'venue_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final String _userName = 'Rafy Ramadhan';
  String _searchQuery = '';

  final List<Field> _fields = Field.sampleList;

  final List<String> _categories = const [
    'Semua',
    'Futsal',
    'Badminton',
    'Basket',
    'Voli',
  ];

  static const Map<String, IconData> _categoryIcons = {
    'Semua': Icons.grid_view_rounded,
    'Futsal': Icons.sports_soccer_outlined,
    'Badminton': Icons.sports_tennis_outlined,
    'Basket': Icons.sports_basketball_outlined,
    'Voli': Icons.sports_volleyball_outlined,
  };

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
    List<Field> list = _fields;
    if (_selectedCategory != 0) {
      list = list
          .where((f) => f.sportType == _categories[_selectedCategory])
          .toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((f) =>
              f.name.toLowerCase().contains(q) ||
              f.location.toLowerCase().contains(q) ||
              f.sportType.toLowerCase().contains(q) ||
              f.floorType.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openVenueDetail(Field field) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VenueDetailScreen(field: field),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleFields = _filteredFields();

    final List<Widget> pages = [
      _buildHomeContent(visibleFields),
      _buildBookingCatalogView(visibleFields),
      const HistoryScreen(),
      const ProfileScreen(),
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
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.bookmark_outline_rounded,
                        color: AppColors.textDark,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.notifications_none,
                        color: AppColors.textDark,
                        size: 20,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Belum ada notifikasi baru'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () => _onBottomNavTapped(3), // Jump to Profile
                    child: Container(
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
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search bar
          CustomSearchBar(
            hintText: 'Cari lapangan olahraga di Karawang...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 20),

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
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.local_activity_outlined,
                      color: Colors.white,
                      size: 28,
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
                  padding: const EdgeInsets.only(right: 10, bottom: 4),
                  child: CategoryChip(
                    label: _categories[index],
                    icon: _categoryIcons[_categories[index]],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lapangan Populer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '${fields.length} Venue',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSubtitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (fields.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: const Text(
                'Tidak ada lapangan yang sesuai dengan pencarian.',
                style: TextStyle(fontSize: 13, color: AppColors.textSubtitle),
              ),
            )
          else
            ...fields.map(
              (field) => FieldCard(
                field: field,
                onTap: () => _openVenueDetail(field),
              ),
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBookingCatalogView(List<Field> fields) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Katalog & Booking Venue',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pilih lapangan berstandar kompetisi di Karawang',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSubtitle,
            ),
          ),
          const SizedBox(height: 18),

          // Search bar
          CustomSearchBar(
            hintText: 'Cari nama venue atau jenis lantai...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Kategori chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: _categories[index],
                    icon: _categoryIcons[_categories[index]],
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
          const SizedBox(height: 20),

          // Fields list
          if (fields.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: const Text(
                'Tidak ditemukan lapangan olahraga yang cocok.',
                style: TextStyle(fontSize: 13, color: AppColors.textSubtitle),
              ),
            )
          else
            ...fields.map(
              (field) => FieldCard(
                field: field,
                onTap: () => _openVenueDetail(field),
              ),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
