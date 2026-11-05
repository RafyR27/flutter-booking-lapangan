import 'package:flutter/material.dart';
import '../models/field.dart';
import '../theme/app_colors.dart';

class FieldCard extends StatelessWidget {
  final Field field;
  final VoidCallback onTap;

  const FieldCard({
    super.key,
    required this.field,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: field.imageUrl != null
                    ? Image.network(
                        field.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          field.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'RP ${field.pricePerHour.toStringAsFixed(0)}/jam',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textSubtitle,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          field.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSubtitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.sports,
                        size: 14,
                        color: AppColors.textSubtitle,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        field.sportType,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: onTap,
                      child: const Text(
                        'Lihat Detail',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.tabBackground,
      alignment: Alignment.center,
      child: const Icon(
        Icons.sports_outlined,
        size: 44,
        color: AppColors.textSubtitle,
      ),
    );
  }
}
