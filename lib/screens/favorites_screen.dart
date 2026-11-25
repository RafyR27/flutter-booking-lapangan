import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../theme/app_colors.dart';
import '../widgets/field_card.dart';
import 'venue_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Lapangan Favorit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: FavoriteService.instance.favoriteIdsNotifier,
        builder: (context, favIds, _) {
          final favoriteFields = FavoriteService.instance.favoriteFields;

          if (favoriteFields.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.bookmark_border_rounded,
                      size: 56,
                      color: AppColors.tabInactiveText,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Belum Ada Lapangan Favorit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Tandai ikon bookmark pada kartu lapangan untuk menyimpannya di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSubtitle,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: favoriteFields.length,
            itemBuilder: (context, index) {
              final field = favoriteFields[index];
              return FieldCard(
                field: field,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VenueDetailScreen(field: field),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
