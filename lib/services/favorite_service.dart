import 'package:flutter/foundation.dart';
import '../models/field.dart';

class FavoriteService {
  FavoriteService._internal() {
    // Initial favorite field for a rich starting state
    favoriteIdsNotifier.value = {'f1'};
  }
  static final FavoriteService instance = FavoriteService._internal();

  final ValueNotifier<Set<String>> favoriteIdsNotifier =
      ValueNotifier<Set<String>>({});

  bool isFavorite(String fieldId) => favoriteIdsNotifier.value.contains(fieldId);

  void toggleFavorite(String fieldId) {
    final current = Set<String>.from(favoriteIdsNotifier.value);
    if (current.contains(fieldId)) {
      current.remove(fieldId);
    } else {
      current.add(fieldId);
    }
    favoriteIdsNotifier.value = current;
  }

  List<Field> get favoriteFields {
    final ids = favoriteIdsNotifier.value;
    return Field.sampleList.where((f) => ids.contains(f.id)).toList();
  }
}
