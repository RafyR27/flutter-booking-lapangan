class AppDateFormatter {
  static const List<String> _daysShort = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Ming'
  ];

  static const List<String> _daysFull = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  static String dayShort(DateTime dt) => _daysShort[dt.weekday - 1];

  static String dayFull(DateTime dt) => _daysFull[dt.weekday - 1];

  static String monthName(DateTime dt) => _months[dt.month - 1];

  static String monthYear(DateTime dt) => '${_months[dt.month - 1]} ${dt.year}';

  static String formatFull(DateTime dt) =>
      '${dayFull(dt)}, ${dt.day.toString().padLeft(2, '0')} ${monthName(dt)} ${dt.year}';

  static String formatShort(DateTime dt) =>
      '${dayShort(dt)}, ${dt.day.toString().padLeft(2, '0')} ${_months[dt.month - 1].substring(0, 3)} ${dt.year}';

  static String formatCodeDate(DateTime dt) =>
      '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';
}
