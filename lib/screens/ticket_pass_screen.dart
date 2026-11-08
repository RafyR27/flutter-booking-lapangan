import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/booking.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';

class TicketPassScreen extends StatelessWidget {
  final Booking booking;

  const TicketPassScreen({
    super.key,
    required this.booking,
  });

  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: booking.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode booking ${booking.code} disalin'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        AppDateFormatter.formatFull(booking.bookingDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.textDark,
            size: 22,
          ),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: const Text(
          'E-Ticket Pass',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Boarding Pass Ticket Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Upper Ticket Chamber
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status & Code
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: booking.status.backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                booking.status.label.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: booking.status.color,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _copyCode(context),
                              child: Row(
                                children: [
                                  Text(
                                    booking.code,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.copy_rounded,
                                    size: 14,
                                    color: AppColors.textSubtitle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Venue Title
                        Text(
                          booking.fieldName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${booking.sportType} • ${booking.courtName}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSubtitle,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(color: AppColors.dividerColor, height: 1),
                        const SizedBox(height: 18),

                        // Grid of Info
                        Row(
                          children: [
                            Expanded(
                              child: _buildTicketField(
                                'TANGGAL MAIN',
                                formattedDate,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTicketField(
                                'JAM SLOT',
                                booking.timeSlots.join(', '),
                              ),
                            ),
                            Expanded(
                              child: _buildTicketField(
                                'TOTAL DURASI',
                                '${booking.durationHours} Jam',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTicketField(
                                'PENYEWA',
                                booking.userName,
                              ),
                            ),
                            Expanded(
                              child: _buildTicketField(
                                'METODE',
                                booking.paymentMethod,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tear Notch Divider
                  _buildTicketNotch(),

                  // Lower Chamber (QR Code & Check-in)
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        // Vector QR Code representation
                        Container(
                          width: 140,
                          height: 140,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child: CustomPaint(
                            painter: _VectorQrCodePainter(seed: booking.code),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'PINDAI UNTUK CHECK-IN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textLabel,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tunjukkan kode QR ini kepada petugas venue saat tiba di lokasi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSubtitle,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Dibayar',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textSubtitle,
                                ),
                              ),
                              Text(
                                _formatRupiah(booking.totalPrice),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryGreen,
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
            ),

            const SizedBox(height: 24),

            // Back to Home Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Selesai & Kembali ke Beranda',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textLabel,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketNotch() {
    return Row(
      children: [
        const SizedBox(
          width: 14,
          height: 28,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFF0F3F7),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final count = (constraints.maxWidth / 10).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  count,
                  (_) => const SizedBox(
                    width: 5,
                    height: 1.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFFD2D8E0)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          width: 14,
          height: 28,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFF0F3F7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VectorQrCodePainter extends CustomPainter {
  final String seed;

  _VectorQrCodePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E252D)
      ..style = PaintingStyle.fill;

    const gridSize = 21;
    final cellSize = size.width / gridSize;

    // Corner Finder 1: Top-Left
    _drawFinderPattern(canvas, 0, 0, cellSize, paint);
    // Corner Finder 2: Top-Right
    _drawFinderPattern(canvas, (gridSize - 7) * cellSize, 0, cellSize, paint);
    // Corner Finder 3: Bottom-Left
    _drawFinderPattern(canvas, 0, (gridSize - 7) * cellSize, cellSize, paint);

    // Deterministic pseudo-random matrix cells based on booking code hash
    int hash = seed.hashCode.abs();
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        // Skip corner finder zones
        final isTopLeft = r < 7 && c < 7;
        final isTopRight = r < 7 && c >= gridSize - 7;
        final isBottomLeft = r >= gridSize - 7 && c < 7;
        if (isTopLeft || isTopRight || isBottomLeft) continue;

        // Use algorithmic hash distribution
        final val = (r * 31 + c * 17 + hash) % 3;
        if (val == 0) {
          canvas.drawRect(
            Rect.fromLTWH(c * cellSize, r * cellSize, cellSize - 0.5, cellSize - 0.5),
            paint,
          );
        }
      }
    }
  }

  void _drawFinderPattern(
    Canvas canvas,
    double x,
    double y,
    double cellSize,
    Paint paint,
  ) {
    // 7x7 outer square
    canvas.drawRect(Rect.fromLTWH(x, y, cellSize * 7, cellSize * 7), paint);

    // 5x5 inner white
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(x + cellSize, y + cellSize, cellSize * 5, cellSize * 5),
      whitePaint,
    );

    // 3x3 center square
    canvas.drawRect(
      Rect.fromLTWH(x + cellSize * 2, y + cellSize * 2, cellSize * 3, cellSize * 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
