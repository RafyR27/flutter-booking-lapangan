class Field {
  final String id;
  final String name;
  final String sportType;
  final String location;
  final int pricePerHour;
  final String? imageUrl;
  final double rating;

  const Field({
    required this.id,
    required this.name,
    required this.sportType,
    required this.location,
    required this.pricePerHour,
    this.imageUrl,
    this.rating = 0.0,
  });
}
