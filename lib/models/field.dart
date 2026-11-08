class Field {
  final String id;
  final String name;
  final String sportType;
  final String location;
  final int pricePerHour;
  final String? imageUrl;
  final double rating;
  final String openHours;
  final String floorType;
  final String dimension;
  final String addressDetail;
  final List<String> facilities;
  final List<String> courts;
  final String description;

  const Field({
    required this.id,
    required this.name,
    required this.sportType,
    required this.location,
    required this.pricePerHour,
    this.imageUrl,
    this.rating = 0.0,
    this.openHours = '07:00 - 23:00',
    this.floorType = 'Vinyl Standar Nasional',
    this.dimension = '25 x 15 Meter',
    this.addressDetail = 'Karawang, Jawa Barat',
    this.facilities = const [
      'Ruang Ganti & Loker',
      'Kamar Mandi Shower',
      'Parkir Luas',
      'Kantin & Air Mineral',
      'Musholla',
    ],
    this.courts = const ['Lapangan 1 (Utama)', 'Lapangan 2 (Reguler)'],
    this.description =
        'Fasilitas olahraga standar kompetisi dengan pencahayaan LED anti-glare dan sirkulasi udara optimal.',
  });

  static const List<Field> sampleList = [
    Field(
      id: 'f1',
      name: 'Apex Arena Futsal Karawang',
      sportType: 'Futsal',
      location: 'Telukjambe Timur, Karawang',
      pricePerHour: 150000,
      rating: 4.8,
      openHours: '07:00 - 23:00',
      floorType: 'Taraflex Polyurethane Vinyl 7mm',
      dimension: '25 x 15 Meter (Standar FIFA)',
      addressDetail:
          'Jl. Galuh Mas Raya No. 8, Sukaharja, Telukjambe Timur, Karawang',
      facilities: [
        'Lantai Vinyl Taraflex 7mm',
        'Lampu LED 400 Lux Anti-Silau',
        'Ruang Ganti & Loker Kunci',
        'Shower Panas & Dingin',
        'Kantin & Minuman Dingin',
        'Parkir Mobil & Motor Beratap',
      ],
      courts: ['Court 1 (Vinyl Biru)', 'Court 2 (Vinyl Hijau)'],
      description:
          'Arena futsal premium berstandar kompetisi dengan peredam benturan optimal untuk menjaga keselamatan ligamen pemain.',
    ),
    Field(
      id: 'f2',
      name: 'Gedung Badminton BWF Galuh',
      sportType: 'Badminton',
      location: 'Pusat Kota, Karawang',
      pricePerHour: 90000,
      rating: 4.7,
      openHours: '08:00 - 23:00',
      floorType: 'Karpet Vinyl Standar BWF 5mm',
      dimension: '13.4 x 6.1 Meter (Standar BWF)',
      addressDetail:
          'Jl. Tuparev No. 142, Nagasari, Kec. Karawang Barat, Karawang',
      facilities: [
        'Karpet BWF 5mm Non-Slip',
        'Penerangan Samping Bebas Silau',
        'Tiang & Net Portabel Standar',
        'Ruang Ganti & Shower Bersih',
        'Tribun Penonton 100 Kursi',
      ],
      courts: ['Court A (Depan)', 'Court B (Tengah)', 'Court C (Belakang)'],
      description:
          'Hall bulutangkis indoor dengan sistem sirkulasi udara tertutup bebas angin samping, menjamin akurasi laju shuttlecock.',
    ),
    Field(
      id: 'f3',
      name: 'Grand Court Basket Parquet',
      sportType: 'Basket',
      location: 'Klari, Karawang',
      pricePerHour: 125000,
      rating: 4.6,
      openHours: '07:00 - 22:00',
      floorType: 'Parquet Kayu Solid Maple',
      dimension: '28 x 15 Meter (Standar FIBA)',
      addressDetail:
          'Kawasan Industri Surya Cipta, Klari, Karawang Timur, Karawang',
      facilities: [
        'Lantai Kayu Maple Peredam Pegas',
        'Ring Hidrolik Standar FIBA',
        'Papan Skor Digital 24 Detik',
        'Loker Pribadi & Kamar Bilas',
        'Kantin Kebugaran & Isotonik',
      ],
      courts: ['Court Utama (Full Court)', 'Court Half-Court 3x3'],
      description:
          'Lapangan basket indoor full-parquet berdaya cengkeram tinggi dengan ring pegas pro-action untuk latihan dan sparing kompetitif.',
    ),
    Field(
      id: 'f4',
      name: 'Singaperbangsa Mini Soccer',
      sportType: 'Futsal',
      location: 'Telukjambe Barat, Karawang',
      pricePerHour: 175000,
      rating: 4.9,
      openHours: '06:00 - 24:00',
      floorType: 'Rumput Sintetis Monofilament 50mm',
      dimension: '40 x 20 Meter',
      addressDetail:
          'Jl. HS. Ronggowaluyo, Puseurjaya, Telukjambe Timur, Karawang',
      facilities: [
        'Rumput Sintetis Monofilament Lembut',
        'Drainase Cepat Bebas Genangan',
        'Sorot Lampu Malam HD 500 Lux',
        'Kamar Mandi Bilas & Loker',
        'Area Kafe & Wi-Fi Gratis',
      ],
      courts: ['Mini Soccer Pitch 1', 'Mini Soccer Pitch 2'],
      description:
          'Venue mini soccer semi-outdoor dengan infill pasir silika dan butiran karet ramah lingkungan, empuk dan tidak melukai lutut.',
    ),
    Field(
      id: 'f5',
      name: 'Karawang Smash Voli Indoor',
      sportType: 'Voli',
      location: 'Cikampek, Karawang',
      pricePerHour: 80000,
      rating: 4.5,
      openHours: '08:00 - 22:00',
      floorType: 'Interlocking Modular Polypropylene',
      dimension: '18 x 9 Meter (Standar FIVB)',
      addressDetail: 'Jl. Ahmad Yani No. 55, Dawuan Tengah, Cikampek, Karawang',
      facilities: [
        'Lantai Interlock Anti-Slip',
        'Net Pengatur Ketinggian Resmi',
        'Garis Batas Kontras Standar FIVB',
        'Ruang Istirahat Tim & Dispenser',
      ],
      courts: ['Court Voli 1', 'Court Voli 2'],
      description:
          'Fasilitas bola voli indoor yang nyaman dengan pantulan bola presisi dan zona servis luas.',
    ),
  ];
}
