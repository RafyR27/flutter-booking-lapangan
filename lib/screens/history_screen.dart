import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import 'ticket_pass_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedTab = 0; // 0 = Aktif / Mendatang, 1 = Selesai / Riwayat

  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _showCancellationDialog(BuildContext context, Booking booking) {
    final penalty = (booking.totalPrice * 0.20).round();
    final refund = booking.totalPrice - penalty;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Konfirmasi Pembatalan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin membatalkan booking di ${booking.fieldName}?',
              style: const TextStyle(fontSize: 13, color: AppColors.textSubtitle),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _buildDialogRow('Total Biaya Sewa', _formatRupiah(booking.totalPrice)),
                  const SizedBox(height: 6),
                  _buildDialogRow('Penalti Venue (20%)', '- ${_formatRupiah(penalty)}', isNegative: true),
                  const Divider(color: AppColors.dividerColor, height: 16),
                  _buildDialogRow(
                    'Pengembalian Dana (80%)',
                    _formatRupiah(refund),
                    isHighlight: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '*Sesuai S&K, refund 80% akan ditransfer ke rekening penyewa dalam 1x24 jam kerja.',
              style: TextStyle(fontSize: 11, color: AppColors.textLabel),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSubtitle)),
          ),
          ElevatedButton(
            onPressed: () {
              BookingService.instance.cancelBooking(booking.id);
              Navigator.of(dialogCtx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pemesanan berhasil dibatalkan. Pengajuan refund diproses.'),
                  backgroundColor: AppColors.statusCancelled,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusCancelled,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String label, String value, {bool isNegative = false, bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSubtitle)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
            color: isNegative
                ? AppColors.statusCancelled
                : isHighlight
                    ? AppColors.primaryGreen
                    : AppColors.textDark,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Riwayat Booking',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Column(
        children: [
          // Segmented Tab Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.tabBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      title: 'Aktif / Mendatang',
                      index: 0,
                    ),
                  ),
                  Expanded(
                    child: _buildTabButton(
                      title: 'Selesai / Riwayat',
                      index: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Reactive Bookings List
          Expanded(
            child: ValueListenableBuilder<List<Booking>>(
              valueListenable: BookingService.instance.bookingsNotifier,
              builder: (context, allBookings, _) {
                final activeList = allBookings
                    .where((b) =>
                        b.status == BookingStatus.pendingVerification ||
                        b.status == BookingStatus.confirmed)
                    .toList();
                final completedList = allBookings
                    .where((b) =>
                        b.status == BookingStatus.completed ||
                        b.status == BookingStatus.cancelled)
                    .toList();

                final currentList = _selectedTab == 0 ? activeList : completedList;

                if (currentList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedTab == 0
                              ? Icons.event_available_outlined
                              : Icons.history_rounded,
                          size: 48,
                          color: AppColors.tabInactiveText,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedTab == 0
                              ? 'Tidak ada pemesanan aktif'
                              : 'Belum ada riwayat selesai',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSubtitle,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: currentList.length,
                  itemBuilder: (context, index) {
                    final booking = currentList[index];
                    return _buildBookingCard(booking);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({required String title, required int index}) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.tabInactiveText,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final formattedDate = AppDateFormatter.formatShort(booking.bookingDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Code & Status Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.code,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: booking.status.backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    booking.status.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: booking.status.color,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: AppColors.dividerColor, height: 1),
            const SizedBox(height: 12),

            // Venue info
            Text(
              booking.fieldName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${booking.sportType} • ${booking.courtName}',
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSubtitle,
              ),
            ),

            const SizedBox(height: 12),

            // Date & Time
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSubtitle),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textDark),
                ),
                const SizedBox(width: 14),
                const Icon(Icons.schedule_outlined, size: 14, color: AppColors.textSubtitle),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    booking.timeSlots.join(', '),
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textDark),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(color: AppColors.dividerColor, height: 1),
            const SizedBox(height: 12),

            // Price & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.status == BookingStatus.cancelled
                          ? 'Refund (80%)'
                          : 'Total Biaya',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.status == BookingStatus.cancelled && booking.refundAmount != null
                          ? _formatRupiah(booking.refundAmount!)
                          : _formatRupiah(booking.totalPrice),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: booking.status == BookingStatus.cancelled
                            ? AppColors.statusCancelled
                            : AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (booking.status == BookingStatus.pendingVerification ||
                        booking.status == BookingStatus.confirmed) ...[
                      OutlinedButton(
                        onPressed: () => _showCancellationDialog(context, booking),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.statusCancelled,
                          side: const BorderSide(color: AppColors.statusCancelled),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Batalkan',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TicketPassScreen(booking: booking),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'E-Ticket',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
