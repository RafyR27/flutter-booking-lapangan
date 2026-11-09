enum RefundAccountType {
  bankTransfer,
  eWallet,
}

class RefundProvider {
  final String id;
  final String name;
  final RefundAccountType type;
  final String inputPlaceholder;
  final String inputLabel;

  const RefundProvider({
    required this.id,
    required this.name,
    required this.type,
    required this.inputPlaceholder,
    required this.inputLabel,
  });

  static const List<RefundProvider> bankList = [
    RefundProvider(
      id: 'bca',
      name: 'Bank BCA',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 521098214410',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'mandiri',
      name: 'Bank Mandiri',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 1730098214410',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'bri',
      name: 'Bank BRI',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 012301001234505',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'bni',
      name: 'Bank BNI',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 0234567890',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'bsi',
      name: 'Bank Syariah Indonesia (BSI)',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 7123456789',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'cimb',
      name: 'CIMB Niaga',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 701234567800',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'permata',
      name: 'Bank Permata',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 9876543210',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'danamon',
      name: 'Bank Danamon',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 003512345678',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'btn',
      name: 'Bank BTN',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 0001501501234567',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'panin',
      name: 'Bank Panin',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 1234567890',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'ocbc',
      name: 'Bank OCBC NISP',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 543810123456',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'mega',
      name: 'Bank Mega',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 0107400123456',
      inputLabel: 'NOMOR REKENING BANK',
    ),
    RefundProvider(
      id: 'jago',
      name: 'Bank Jago',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 102345678912',
      inputLabel: 'NOMOR KANTONG / REKENING JAGO',
    ),
    RefundProvider(
      id: 'seabank',
      name: 'SeaBank Indonesia',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 901234567890',
      inputLabel: 'NOMOR REKENING SEABANK',
    ),
    RefundProvider(
      id: 'jenius',
      name: 'Jenius (BTPN)',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 90012345678',
      inputLabel: 'NOMOR REKENING JENIUS',
    ),
    RefundProvider(
      id: 'neo',
      name: 'Bank Neo Commerce (BNC)',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 901234567890',
      inputLabel: 'NOMOR REKENING NEO',
    ),
    RefundProvider(
      id: 'allo',
      name: 'Allo Bank',
      type: RefundAccountType.bankTransfer,
      inputPlaceholder: 'Contoh: 081234567890',
      inputLabel: 'NOMOR REKENING ALLO BANK',
    ),
  ];

  static const List<RefundProvider> eWalletList = [
    RefundProvider(
      id: 'gopay',
      name: 'GoPay',
      type: RefundAccountType.eWallet,
      inputPlaceholder: 'Contoh: 081289123456',
      inputLabel: 'NOMOR HP AKUN GOPAY',
    ),
    RefundProvider(
      id: 'ovo',
      name: 'OVO',
      type: RefundAccountType.eWallet,
      inputPlaceholder: 'Contoh: 081289123456',
      inputLabel: 'NOMOR HP AKUN OVO',
    ),
    RefundProvider(
      id: 'dana',
      name: 'DANA',
      type: RefundAccountType.eWallet,
      inputPlaceholder: 'Contoh: 081289123456',
      inputLabel: 'NOMOR HP AKUN DANA',
    ),
    RefundProvider(
      id: 'shopeepay',
      name: 'ShopeePay',
      type: RefundAccountType.eWallet,
      inputPlaceholder: 'Contoh: 081289123456',
      inputLabel: 'NOMOR HP AKUN SHOPEEPAY',
    ),
    RefundProvider(
      id: 'linkaja',
      name: 'LinkAja',
      type: RefundAccountType.eWallet,
      inputPlaceholder: 'Contoh: 081289123456',
      inputLabel: 'NOMOR HP AKUN LINKAJA',
    ),
    RefundProvider(
      id: 'astrapay',
      name: 'AstraPay',
      type: RefundAccountType.eWallet,
      inputPlaceholder: 'Contoh: 081289123456',
      inputLabel: 'NOMOR HP AKUN ASTRAPAY',
    ),
    RefundProvider(
      id: 'isaku',
      name: 'i.saku',
      type: RefundAccountType.eWallet,
      inputPlaceholder: 'Contoh: 081289123456',
      inputLabel: 'NOMOR HP AKUN I.SAKU',
    ),
  ];
}
