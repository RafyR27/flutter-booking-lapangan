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
}
