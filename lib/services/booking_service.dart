import 'package:flutter/foundation.dart';
import '../models/booking.dart';
import 'wallet_service.dart';

class BookingService {
  BookingService._internal() {
    _initInitialData();
  }
  static final BookingService instance = BookingService._internal();

  final ValueNotifier<List<Booking>> bookingsNotifier =
      ValueNotifier<List<Booking>>([]);

  void _initInitialData() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final pastDate = now.subtract(const Duration(days: 4));

    bookingsNotifier.value = [
      Booking(
        id: 'bk-001',
        code: 'APX-20261106-0812',
        fieldId: 'f1',
        fieldName: 'Apex Arena Futsal Karawang',
        sportType: 'Futsal',
        courtName: 'Court 1 (Vinyl Biru)',
        bookingDate: tomorrow,
        timeSlots: ['19:00 - 20:00', '20:00 - 21:00'],
        userName: 'Rafy Ramadhan',
        userWhatsApp: '081289123456',
        userEmail: 'rafy.ramadhan@example.com',
        totalPrice: 130000,
        paymentMethod: 'Transfer Bank BCA',
        status: BookingStatus.pendingVerification,
        createdAt: now.subtract(const Duration(hours: 1)),
        paymentProofName: 'bukti_transfer_bca_130k.jpg',
      ),
      Booking(
        id: 'bk-002',
        code: 'APX-20261108-0421',
        fieldId: 'f2',
        fieldName: 'Gedung Badminton BWF Galuh',
        sportType: 'Badminton',
        courtName: 'Court A (Depan)',
        bookingDate: now.add(const Duration(days: 3)),
        timeSlots: ['09:00 - 10:00'],
        userName: 'Rafy Ramadhan',
        userWhatsApp: '081289123456',
        userEmail: 'rafy.ramadhan@example.com',
        totalPrice: 50000,
        paymentMethod: 'QRIS Statis',
        status: BookingStatus.confirmed,
        createdAt: now.subtract(const Duration(days: 1)),
        paymentProofName: 'qris_transaksi_sukses.png',
      ),
      Booking(
        id: 'bk-003',
        code: 'APX-20261101-0194',
        fieldId: 'f3',
        fieldName: 'Grand Court Basket Parquet',
        sportType: 'Basket',
        courtName: 'Court Utama (Full Court)',
        bookingDate: pastDate,
        timeSlots: ['15:00 - 16:00', '16:00 - 17:00'],
        userName: 'Rafy Ramadhan',
        userWhatsApp: '081289123456',
        userEmail: 'rafy.ramadhan@example.com',
        totalPrice: 120000,
        paymentMethod: 'Transfer Bank Mandiri',
        status: BookingStatus.completed,
        createdAt: pastDate.subtract(const Duration(days: 1)),
        paymentProofName: 'struk_atm_mandiri.jpg',
      ),
    ];
  }

  List<Booking> get allBookings => bookingsNotifier.value;

  List<Booking> get activeBookings => bookingsNotifier.value
      .where((b) =>
          b.status == BookingStatus.pendingVerification ||
          b.status == BookingStatus.confirmed)
      .toList();

  List<Booking> get completedBookings => bookingsNotifier.value
      .where((b) =>
          b.status == BookingStatus.completed ||
          b.status == BookingStatus.cancelled)
      .toList();

  void addBooking(Booking booking) {
    final current = List<Booking>.from(bookingsNotifier.value);
    current.insert(0, booking);
    bookingsNotifier.value = current;
  }

  bool cancelBooking(String bookingId) {
    final current = List<Booking>.from(bookingsNotifier.value);
    final index = current.indexWhere((b) => b.id == bookingId);
    if (index == -1) return false;

    final target = current[index];
    final penalty = (target.totalPrice * 0.20).round();
    final refund = target.totalPrice - penalty;

    current[index] = Booking(
      id: target.id,
      code: target.code,
      fieldId: target.fieldId,
      fieldName: target.fieldName,
      sportType: target.sportType,
      courtName: target.courtName,
      bookingDate: target.bookingDate,
      timeSlots: target.timeSlots,
      userName: target.userName,
      userWhatsApp: target.userWhatsApp,
      userEmail: target.userEmail,
      totalPrice: target.totalPrice,
      paymentMethod: target.paymentMethod,
      status: BookingStatus.cancelled,
      createdAt: target.createdAt,
      paymentProofName: target.paymentProofName,
      penaltyAmount: penalty,
      refundAmount: refund,
    );

    // Credit the 80% refund into the user's accumulative wallet
    WalletService.instance.creditRefund(refund, target.code);

    bookingsNotifier.value = current;
    return true;
  }

  /// Get slots that are booked for a field on a specific date
  Set<String> getBookedSlotsFor(String fieldId, DateTime date) {
    final booked = <String>{};
    // Include initial sample busy slots for realistic feel
    booked.addAll(['16:00 - 17:00', '20:00 - 21:00']);

    for (final b in bookingsNotifier.value) {
      if (b.fieldId == fieldId &&
          b.bookingDate.year == date.year &&
          b.bookingDate.month == date.month &&
          b.bookingDate.day == date.day &&
          b.status != BookingStatus.cancelled) {
        booked.addAll(b.timeSlots);
      }
    }
    return booked;
  }
}
