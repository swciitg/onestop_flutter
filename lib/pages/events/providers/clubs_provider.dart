import 'package:flutter/foundation.dart';
import 'package:onestop_dev/models/event_scheduler/club_model.dart';
import 'package:onestop_dev/repository/events_api_repository.dart';

/// State for the Clubs & Fests page.
class ClubsProvider extends ChangeNotifier {
  ClubsProvider({EventsAPIRepository? repository})
    : _repo = repository ?? EventsAPIRepository();

  final EventsAPIRepository _repo;

  String _selectedCategory = 'All';
  List<ClubModel> _clubs = []; // every club; filtered locally by board
  bool _isLoading = true;

  String get selectedCategory => _selectedCategory;
  List<ClubModel> get clubs => _clubs;

  /// Display name of a club's board, with the word "Board" removed
  /// (e.g. "Technical Board" -> "Technical"). Empty if the club has none.
  static String boardLabel(ClubModel club) {
    final name = (club.boardName ?? '').replaceAll(
      RegExp(r'\bboard\b', caseSensitive: false),
      '',
    );
    return name.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// "All" followed by the distinct boards of the available clubs.
  List<String> get categories {
    final boards = <String>{};
    for (final club in _clubs) {
      final label = boardLabel(club);
      if (label.isNotEmpty) boards.add(label);
    }
    return ['All', ...boards.toList()..sort()];
  }
  bool get isLoading => _isLoading;

  String _searchQuery = '';

  /// Clubs narrowed by the search query (name or board), case-insensitive.
  List<ClubModel> get visibleClubs {
    final q = _searchQuery.trim().toLowerCase();
    return _clubs.where((c) {
      if (_selectedCategory != 'All' && boardLabel(c) != _selectedCategory) {
        return false;
      }
      return q.isEmpty ||
          c.clubName.toLowerCase().contains(q) ||
          (c.boardName?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  void setSearchQuery(String query) {
    if (query == _searchQuery) return;
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchClubs() async {
    _isLoading = true;
    notifyListeners();

    _clubs = await _repo.getAllClubs();
    // Drop a selected board that no longer exists after a refresh.
    if (!categories.contains(_selectedCategory)) _selectedCategory = 'All';

    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String category) {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    notifyListeners();
  }

  Future<ClubModel?> getClubDetails(ClubModel club) async {
    if (club.id == null) return club;
    return _repo.getClubDetails(club.id!);
  }
}
