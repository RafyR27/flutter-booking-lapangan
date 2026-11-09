import 'dart:async';
import 'package:flutter/material.dart';
import '../models/field.dart';
import '../services/booking_service.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import 'checkout_screen.dart';

class SlotPickerScreen extends StatefulWidget {
  final Field field;
  final String selectedCourt;

  const SlotPickerScreen({
    super.key,
    required this.field,
    required this.selectedCourt,
  });

  @override
  State<SlotPickerScreen> createState() => _SlotPickerScreenState();
}

class _SlotPickerScreenState extends State<SlotPickerScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _availableDates;
  final Set<String> _selectedSlots = <String>{};
  Timer? _holdTimer;
  int _holdSecondsLeft = 600; // 10 minutes hold lock

  final List<String> _allSlots = const [
    '07:00 - 08:00',
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
    '17:00 - 18:00',
    '18:00 - 19:00',
    '19:00 - 20:00',
    '20:00 - 21:00',
    '21:00 - 22:00',
    '22:00 - 23:00',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _availableDates = List.generate(7, (index) => _selectedDate.add(Duration(days: index)));
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  void _startHoldTimerIfNeeded() {
    if (_selectedSlots.isNotEmpty && (_holdTimer == null || !_holdTimer!.isActive)) {
      _holdSecondsLeft = 600;
      _holdTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_holdSecondsLeft > 0) {
          setState(() {
            _holdSecondsLeft--;
          });
        } else {
          timer.cancel();
          setState(() {
            _selectedSlots.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Waktu penahanan slot 10 menit berakhir. Silakan pilih kembali.'),
              backgroundColor: AppColors.statusCancelled,
            ),
          );
        }
      });
    } else if (_selectedSlots.isEmpty) {
      _holdTimer?.cancel();
    }
  }

  int _calculateSlotPrice(String slot) {
    return widget.field.pricePerHour;
  }

  int get _totalPrice {
    int total = 0;
    for (final slot in _selectedSlots) {
      total += _calculateSlotPrice(slot);
    }
    return total;
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final bookedSlots = BookingService.instance.getBookedSlotsFor(
      widget.field.id,
      _selectedDate,
    );

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Jadwal Bermain',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            Text(
              '${widget.field.name} • ${widget.selectedCourt}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSubtitle,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hold Countdown Banner (Anti-Race Condition)
            if (_selectedSlots.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                color: const Color(0xFFFFFBEB),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 18,
                      color: AppColors.statusPending,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Slot ditahan sementara: ${_formatTimer(_holdSecondsLeft)} menit',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.statusPending,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Date Strip Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PILIH TANGGAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    AppDateFormatter.monthYear(_selectedDate),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Date List
            SizedBox(
              height: 76,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _availableDates.length,
                itemBuilder: (context, index) {
                  final date = _availableDates[index];
                  final isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month &&
                      date.year == _selectedDate.year;
                  final isToday = index == 0;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        _selectedSlots.clear();
                        _startHoldTimerIfNeeded();
                      });
                    },
                    child: Container(
                      width: 58,
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.cardBorder,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isToday ? 'Hari Ini' : AppDateFormatter.dayShort(date),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSubtitle,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date.day.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.dividerColor, height: 1),
            const SizedBox(height: 16),

            // Legend Status Indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildLegend(
                    color: AppColors.surfaceSoft,
                    border: AppColors.cardBorder,
                    label: 'Tersedia',
                  ),
                  const SizedBox(width: 16),
                  _buildLegend(
                    color: AppColors.primaryGreen,
                    border: AppColors.primaryGreen,
                    label: 'Dipilih',
                  ),
                  const SizedBox(width: 16),
                  _buildLegend(
                    color: const Color(0xFFE5E7EB),
                    border: Colors.transparent,
                    label: 'Terisi',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Slot Matrix Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SLOT WAKTU TERSEDIA',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.3,
                    ),
                    itemCount: _allSlots.length,
                    itemBuilder: (context, index) {
                      final slot = _allSlots[index];
                      final isBooked = bookedSlots.contains(slot);
                      final isSelected = _selectedSlots.contains(slot);
                      final price = _calculateSlotPrice(slot);

                      return InkWell(
                        onTap: isBooked
                            ? null
                            : () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedSlots.remove(slot);
                                  } else {
                                    _selectedSlots.add(slot);
                                  }
                                  _startHoldTimerIfNeeded();
                                });
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isBooked
                                ? const Color(0xFFF3F4F6)
                                : isSelected
                                    ? AppColors.primaryGreen
                                    : AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : isBooked
                                      ? Colors.transparent
                                      : AppColors.cardBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    slot,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isBooked
                                          ? const Color(0xFF9CA3AF)
                                          : isSelected
                                              ? Colors.white
                                              : AppColors.textDark,
                                    ),
                                  ),
                                  if (isBooked)
                                    const Icon(
                                      Icons.lock_outline_rounded,
                                      size: 14,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isBooked ? 'Sudah Dibooking' : _formatRupiah(price),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isBooked
                                      ? const Color(0xFF9CA3AF)
                                      : isSelected
                                          ? Colors.white.withValues(alpha: 0.9)
                                          : AppColors.textSubtitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
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
                    Text(
                      _selectedSlots.isEmpty
                          ? 'Belum ada slot dipilih'
                          : '${_selectedSlots.length} Jam Terpilih',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedSlots.isEmpty
                          ? 'Pilih minimal 1 slot'
                          : _formatRupiah(_totalPrice),
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
                onPressed: _selectedSlots.isEmpty
                    ? null
                    : () {
                        final sortedSlots = _selectedSlots.toList()..sort();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              field: widget.field,
                              selectedCourt: widget.selectedCourt,
                              selectedDate: _selectedDate,
                              selectedSlots: sortedSlots,
                              totalPrice: _totalPrice,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE5E7EB),
                  disabledForegroundColor: const Color(0xFF9CA3AF),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
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
                      'Lanjut Bayar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
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

  Widget _buildLegend({
    required Color color,
    required Color border,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSubtitle,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
