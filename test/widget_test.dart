import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_booking_lapangan/main.dart';

void main() {
  testWidgets('Auth screen displays and switches tabs correctly with hint texts',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookingLapanganApp());

    // Initially loads Register view
    expect(find.text('Daftar Akun Baru'), findsOneWidget);
    expect(find.text('NAMA LENGKAP'), findsOneWidget);
    expect(find.text('NOMOR WHATSAPP'), findsOneWidget);
    expect(find.text('ALAMAT EMAIL'), findsOneWidget);
    expect(find.text('Masukkan Nama Lengkap'), findsOneWidget);
    expect(find.text('Masukkan Nomor WhatsApp'), findsOneWidget);
    expect(find.text('Masukkan Email'), findsOneWidget);
    expect(find.text('Daftar Sekarang'), findsOneWidget);

    // Tap on "Masuk" tab
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    // Verify Login view is shown with hint texts
    expect(find.text('Masuk ke Akun'), findsOneWidget);
    expect(find.text('EMAIL / WHATSAPP'), findsOneWidget);
    expect(find.text('KATA SANDI'), findsOneWidget);
    expect(find.text('Masukkan Email'), findsOneWidget);
    expect(find.text('Masukkan Kata Sandi'), findsOneWidget);
    expect(find.text('Ingat Sesi Saya'), findsOneWidget);
    expect(find.text('Lupa Sandi?'), findsOneWidget);
    expect(find.text('Masuk ke Katalog Venue'), findsOneWidget);
  });

  testWidgets('End-to-end navigation from Login to Home, Venue Detail, and Slot Picker',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookingLapanganApp());

    // Switch to Masuk
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    // Tap "Masuk ke Katalog Venue" to enter HomeScreen
    await tester.tap(find.text('Masuk ke Katalog Venue'));
    await tester.pumpAndSettle();

    // Verify HomeScreen elements
    expect(find.text('Rafy Ramadhan'), findsOneWidget);
    expect(find.text('Kategori Olahraga'), findsOneWidget);
    expect(find.text('Lapangan Populer'), findsOneWidget);
    expect(find.text('Apex Arena Futsal Karawang'), findsWidgets);

    // Switch BottomNav to Tab 1: Booking Catalog
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Katalog & Booking Venue'), findsOneWidget);

    // Switch BottomNav to Tab 2: Riwayat Booking
    await tester.tap(find.byIcon(Icons.history_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Riwayat Booking'), findsOneWidget);
    expect(find.text('Aktif / Mendatang'), findsOneWidget);

    // Switch BottomNav to Tab 3: Profil
    await tester.tap(find.byIcon(Icons.person_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Profil Penyewa'), findsOneWidget);
    expect(find.text('REKENING PENGEMBALIAN DANA (REFUND)'), findsOneWidget);

    // Switch back to Beranda (Tab 0)
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    // Scroll down to make first FieldCard visible
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    // Tap on first FieldCard to open VenueDetailScreen
    await tester.tap(find.text('Apex Arena Futsal Karawang').first);
    await tester.pumpAndSettle();

    expect(find.text('SPESIFIKASI OPERASIONAL'), findsOneWidget);
    expect(find.text('FASILITAS VENUE'), findsOneWidget);
    expect(find.text('Pilih Jadwal'), findsOneWidget);

    // Tap "Pilih Jadwal" to navigate to SlotPickerScreen
    await tester.tap(find.text('Pilih Jadwal'));
    await tester.pumpAndSettle();

    expect(find.text('PILIH TANGGAL'), findsOneWidget);
    expect(find.text('SLOT WAKTU TERSEDIA'), findsOneWidget);
  });
}
