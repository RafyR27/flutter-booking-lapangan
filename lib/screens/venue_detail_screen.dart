import 'package:flutter/material.dart';
import '../models/field.dart';
import '../services/favorite_service.dart';
import '../theme/app_colors.dart';
import 'slot_picker_screen.dart';

class VenueDetailScreen extends StatefulWidget {
  final Field field;

  const VenueDetailScreen({
    super.key,
    required this.field,
  });

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late String _selectedCourt;

  @override
  void initState() {
    super.initState();
    _selectedCourt = widget.field.courts.isNotEmpty
        ? widget.field.courts.first
        : 'Lapangan Utama';
  }

  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.field;

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
        title: Text(
          field.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: FavoriteService.instance.favoriteIdsNotifier,
            builder: (context, favIds, _) {
              final isFav = favIds.contains(field.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.bookmark : Icons.bookmark_border_rounded,
                  color: isFav
                      ? AppColors.primaryGreen
                      : AppColors.textSubtitle,
                ),
                onPressed: () {
                  FavoriteService.instance.toggleFavorite(field.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFav
                          ? 'Dihapus dari daftar favorit'
                          : 'Disimpan ke daftar favorit'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Photo Header
            _buildVenueHero(field),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title, Category & Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreenLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                field.sportType.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryGreen,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              field.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Color(0xFFEAB308),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              field.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.textSubtitle,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          field.addressDetail,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSubtitle,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.dividerColor, height: 1),
                  const SizedBox(height: 20),

                  // Court Selection (if multiple courts exist)
                  const Text(
                    'PILIH LAPANGAN / COURT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: field.courts.map((court) {
                      final isSelected = _selectedCourt == court;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCourt = court;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.cardBorder,
                            ),
                          ),
                          child: Text(
                            court,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textDark,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Technical Specifications (Domain Reality)
                  const Text(
                    'SPESIFIKASI OPERASIONAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildSpecRow(
                          icon: Icons.layers_outlined,
                          label: 'Material Lantai',
                          value: field.floorType,
                        ),
                        const Divider(color: AppColors.dividerColor, height: 16),
                        _buildSpecRow(
                          icon: Icons.aspect_ratio_outlined,
                          label: 'Dimensi Lapangan',
                          value: field.dimension,
                        ),
                        const Divider(color: AppColors.dividerColor, height: 16),
                        _buildSpecRow(
                          icon: Icons.schedule_outlined,
                          label: 'Jam Operasional',
                          value: field.openHours,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Facilities List
                  const Text(
                    'FASILITAS VENUE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...field.facilities.map((facility) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 16,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                facility,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.dividerColor, height: 1),
                  const SizedBox(height: 20),

                  // Venue Rules & Cancellation Notice (Aligned with Proposal)
                  const Text(
                    'KETENTUAN RESERVASI & PEMBATALAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '1. Wajib mengenakan sepatu olahraga berpasangan dengan jenis lantai venue (non-marking).',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textDark,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '2. Pembatalan jadwal dapat dilakukan maksimal H-1 sebelum waktu bermain.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textDark,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '3. Pembatalan dikenakan penalti 20% bagi pengelola, dan 80% dana dikembalikan ke rekening penyewa.',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.statusPending,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 90), // Bottom padding for sticky bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
          border: const Border(
            top: BorderSide(color: AppColors.cardBorder),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tarif Sewa Reguler',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatRupiah(field.pricePerHour)} / jam',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryGreen,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SlotPickerScreen(
                        field: widget.field,
                        selectedCourt: _selectedCourt,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Pilih Jadwal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVenueHero(Field field) {
    return Container(
      height: 220,
      width: double.infinity,
      color: const Color(0xFF161F28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (field.imageUrl != null)
            Image.network(
              field.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => CustomPaint(
                painter: _VenueArenaPainter(),
              ),
            )
          else
            CustomPaint(
              painter: _VenueArenaPainter(),
            ),
          // Gradient scrim
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 16,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_outlined,
                        size: 14,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Mitra Resmi ${field.sportType}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSubtitle),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSubtitle,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _VenueArenaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Outer boundary
    final rect = Rect.fromLTWH(20, 20, size.width - 40, size.height - 40);
    canvas.drawRect(rect, paint);

    // Center line
    canvas.drawLine(
      Offset(size.width / 2, 20),
      Offset(size.width / 2, size.height - 20),
      paint,
    );

    // Center circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 35, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
