import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_booking_lapangan/main.dart';

void main() {
  testWidgets('Welcome screen displays carousel and navigates to Auth and Home',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookingLapanganApp());

    // Initially loads WelcomeScreen
    expect(find.text('APEX SPORT KARAWANG'), findsOneWidget);
    expect(find.text('Daftar Akun Baru'), findsOneWidget);
    expect(find.text('Jelajahi'), findsOneWidget);

    // Tap "Daftar Akun Baru" to open Register view
    await tester.tap(find.text('Daftar Akun Baru'));
    await tester.pumpAndSettle();

    expect(find.text('Lengkapi data identitas penyewa'), findsOneWidget);
    expect(find.text('NAMA LENGKAP'), findsOneWidget);
    expect(find.text('NOMOR WHATSAPP'), findsOneWidget);
    expect(find.text('ALAMAT EMAIL'), findsOneWidget);

    // Tap on "Masuk" tab
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    // Verify Login view is shown
    expect(find.text('Masuk ke Akun'), findsOneWidget);
    expect(find.text('EMAIL / WHATSAPP'), findsOneWidget);
    expect(find.text('KATA SANDI'), findsOneWidget);
    expect(find.text('Ingat Sesi Saya'), findsOneWidget);
    expect(find.text('Lupa Sandi?'), findsOneWidget);
  });

  testWidgets('End-to-end navigation from Welcome to Home, Venue Detail, and Slot Picker',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookingLapanganApp());

    // Tap "Jelajahi" to enter HomeScreen directly
    await tester.tap(find.text('Jelajahi'));
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
    expect(find.text('REKENING BANK (PENGEMBALIAN DANA)'), findsOneWidget);
    expect(find.text('AKUN E-WALLET (PENGEMBALIAN DANA)'), findsOneWidget);

    // Switch back to Beranda (Tab 0)
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    // Scroll down to make first FieldCard visible
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    // Tap on first FieldCard to open VenueDetailScreen preview
    await tester.tap(find.text('Apex Arena Futsal Karawang').first);
    await tester.pumpAndSettle();

    expect(find.text('SPESIFIKASI OPERASIONAL'), findsOneWidget);
    expect(find.text('FASILITAS VENUE'), findsOneWidget);
    expect(find.text('Pilih Jadwal'), findsOneWidget);

    // Tap "Pilih Jadwal" - in guest preview mode, prompts to login
    await tester.tap(find.text('Pilih Jadwal'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk untuk Booking'), findsOneWidget);
    expect(find.text('Masuk ke Akun Sekarang'), findsOneWidget);

    // Tap "Masuk ke Akun Sekarang" to log in
    await tester.tap(find.text('Masuk ke Akun Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke Akun'), findsOneWidget);

    // Perform login
    await tester.tap(find.text('Masuk ke Katalog Venue'));
    await tester.pumpAndSettle();

    // Now user is logged in and navigated to SlotPickerScreen!
    expect(find.text('PILIH TANGGAL'), findsOneWidget);
    expect(find.text('SLOT WAKTU TERSEDIA'), findsOneWidget);
  });
}
