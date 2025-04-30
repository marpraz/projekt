class SavedFairyTale {
  final String title;
  final String story;
  final List<String> tags;

  SavedFairyTale({
    required this.title,
    required this.story,
    required this.tags,
  });
}

class FairyTaleStorage {
  static final FairyTaleStorage _instance = FairyTaleStorage._internal();
  factory FairyTaleStorage() => _instance;
  FairyTaleStorage._internal();

  final List<SavedFairyTale> _savedTales = [];

  List<SavedFairyTale> get savedTales => _savedTales;

  void saveFairyTale(SavedFairyTale tale) {
    _savedTales.add(tale);
  }
}
