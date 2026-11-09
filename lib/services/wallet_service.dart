import 'package:flutter/foundation.dart';

class WalletTransaction {
  final String id;
  final String title;
  final String description;
  final int amount; // positive = credit (refund), negative = debit (payment)
  final DateTime date;
  final String referenceCode;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.referenceCode,
  });

  bool get isCredit => amount > 0;
}

class WalletService {
  WalletService._internal() {
    _initSampleData();
  }
  static final WalletService instance = WalletService._internal();

  final ValueNotifier<int> balanceNotifier = ValueNotifier<int>(0);
  final ValueNotifier<List<WalletTransaction>> transactionsNotifier =
      ValueNotifier<List<WalletTransaction>>([]);

  int get balance => balanceNotifier.value;
  List<WalletTransaction> get transactions => transactionsNotifier.value;

  void _initSampleData() {
    // Starting balance from previously cancelled booking so user can test deduction immediately
    final now = DateTime.now();
    balanceNotifier.value = 104000;
    transactionsNotifier.value = [
      WalletTransaction(
        id: 'tx-001',
        title: 'Pengembalian Dana Pembatalan',
        description: 'Refund 80% pembatalan sewa Grand Court Basket',
        amount: 104000,
        date: now.subtract(const Duration(days: 2)),
        referenceCode: 'APX-20261101-0194',
      ),
    ];
  }

  void creditRefund(int amount, String bookingCode) {
    balanceNotifier.value += amount;
    final current = List<WalletTransaction>.from(transactionsNotifier.value);
    current.insert(
      0,
      WalletTransaction(
        id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Pengembalian Dana Pembatalan',
        description: 'Refund 80% pembatalan tiket $bookingCode',
        amount: amount,
        date: DateTime.now(),
        referenceCode: bookingCode,
      ),
    );
    transactionsNotifier.value = current;
  }

  bool deductBalance(int amount, String bookingCode) {
    if (balanceNotifier.value < amount) return false;
    balanceNotifier.value -= amount;
    final current = List<WalletTransaction>.from(transactionsNotifier.value);
    current.insert(
      0,
      WalletTransaction(
        id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Pembayaran Sewa Lapangan',
        description: 'Pemotongan tagihan sewa $bookingCode',
        amount: -amount,
        date: DateTime.now(),
        referenceCode: bookingCode,
      ),
    );
    transactionsNotifier.value = current;
    return true;
  }
}
