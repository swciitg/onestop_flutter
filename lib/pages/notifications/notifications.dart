import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/notifications/notification_model.dart';
import 'package:onestop_dev/pages/notifications/notification_settings.dart';
import 'package:onestop_dev/pages/services/cab_share.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';
import 'package:onestop_dev/repository/notification_repository.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';

class NotificationPage extends StatefulWidget {
  static String id = "/notifications";

  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedTab = 0; // 0 = Focused, 1 = General
  String _selectedFilter = 'All';

  // Data
  List<NotifsModel> _personalNotifs = [];
  List<NotifsModel> _generalNotifs = [];
  bool _isInitialLoading = true;
  bool _hasError = false;

  // Pagination state for General tab
  int _generalPage = 1;
  bool _generalHasNextPage = true;
  bool _isLoadingMore = false;

  final ScrollController _scrollController = ScrollController();

  static const _categoryFilters = ['All', 'Cab Sharing', 'Buy and Sell', 'Gatelog'];
  static const _categoryFilterKeys = {
    'All': null,
    'Cab Sharing': 'cabSharing',
    'Buy and Sell': 'buySell',
    'Gatelog': 'gatelog',
  };

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_selectedTab != 1) return;
    if (_isLoadingMore || !_generalHasNextPage) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreGeneral();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isInitialLoading = true;
      _hasError = false;
    });
    try {
      final data = await DataService.getNotifications();
      if (!mounted) return;
      setState(() {
        _personalNotifs = data['userPersonalNotifs'] ?? [];
        _generalNotifs = data['allTopicNotifs'] ?? [];
        _generalPage = 1;
        // If we got fewer than 10, there's no next page
        _generalHasNextPage = _generalNotifs.length >= 10;
        _isInitialLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _loadMoreGeneral() async {
    if (_isLoadingMore || !_generalHasNextPage) return;
    setState(() => _isLoadingMore = true);
    try {
      final nextPage = _generalPage + 1;
      final res = await NotificationRepository().getGeneralNotifications(nextPage);
      final newNotifs = (res.data['allTopicNotifs'] as List)
          .map((e) => NotifsModel.fromJson(e))
          .toList();
      final pagination = res.data['pagination'];
      if (!mounted) return;
      setState(() {
        _generalNotifs.addAll(newNotifs);
        _generalPage = nextPage;
        _generalHasNextPage = pagination?['hasNextPage'] == true;
        _isLoadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingMore = false);
    }
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cabsharing':
        return FluentIcons.vehicle_car_24_regular;
      case 'gatelog':
        return FluentIcons.door_arrow_right_20_regular;
      case 'buy':
      case 'sell':
        return FluentIcons.money_24_regular;
      case 'lost':
      case 'found':
        return FluentIcons.document_search_24_regular;
      case 'announcement':
      case 'swc':
        return FluentIcons.megaphone_24_regular;
      case 'irbs':
        return FluentIcons.calendar_edit_16_regular;
      default:
        return FluentIcons.alert_24_regular;
    }
  }

  String _categoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'cabsharing':
        return 'CAB SHARING';
      case 'gatelog':
        return 'GATELOG';
      case 'buy':
        return 'BUY AND SELL';
      case 'sell':
        return 'BUY AND SELL';
      case 'lost':
      case 'found':
        return 'LOST & FOUND';
      case 'announcement':
        return 'ANNOUNCEMENT';
      case 'irbs':
        return 'IRBS';
      case 'swc':
        return 'SWC';
      default:
        return category.toUpperCase();
    }
  }

  String _timeAgo(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} MINS AGO';
    if (diff.inHours < 24) return '${diff.inHours} HRS AGO';
    if (diff.inDays < 7) return '${diff.inDays} DAYS AGO';
    return '${(diff.inDays / 7).floor()} WEEKS AGO';
  }

  String? _actionForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'gatelog':
        return 'Check In';
      case 'cabsharing':
        return 'View';
      default:
        return null;
    }
  }

  void _navigateForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cabsharing':
        Navigator.of(context).pushNamed(CabShare.id);
        break;
      case 'gatelog':
        Navigator.of(context).pushNamed(GateLogPage.id);
        break;
    }
  }

  bool _matchesFilter(NotifsModel notif) {
    final filterKey = _categoryFilterKeys[_selectedFilter];
    if (filterKey == null) return true;
    switch (filterKey) {
      case 'cabSharing':
        return notif.category.toLowerCase() == 'cabsharing';
      case 'buySell':
        return notif.category.toLowerCase() == 'buy' || notif.category.toLowerCase() == 'sell';
      case 'gatelog':
        return notif.category.toLowerCase() == 'gatelog';
      default:
        return true;
    }
  }

  Map<String, List<NotifsModel>> _groupByTime(List<NotifsModel> notifs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));

    final unread = <NotifsModel>[];
    final todayList = <NotifsModel>[];
    final thisWeek = <NotifsModel>[];
    final older = <NotifsModel>[];

    for (final n in notifs) {
      if (n.read == false) {
        unread.add(n);
      } else if (n.time != null && n.time!.isAfter(today)) {
        todayList.add(n);
      } else if (n.time != null && n.time!.isAfter(weekAgo)) {
        thisWeek.add(n);
      } else {
        older.add(n);
      }
    }

    return {
      if (unread.isNotEmpty) 'Unread': unread,
      if (todayList.isNotEmpty) 'Today': todayList,
      if (thisWeek.isNotEmpty) 'This Week': thisWeek,
      if (older.isNotEmpty) 'Earlier': older,
    };
  }

  int _countForFilter(String filter, List<NotifsModel> notifs) {
    if (filter == 'All') return notifs.length;
    final filterKey = _categoryFilterKeys[filter];
    return notifs.where((n) {
      switch (filterKey) {
        case 'cabSharing':
          return n.category.toLowerCase() == 'cabsharing';
        case 'buySell':
          return n.category.toLowerCase() == 'buy' || n.category.toLowerCase() == 'sell';
        case 'gatelog':
          return n.category.toLowerCase() == 'gatelog';
        default:
          return true;
      }
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.white,
      appBar: AppBar(
        backgroundColor: OColor.white,
        centerTitle: true,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: OColor.gray800, size: 24),
        ),
        title: Text(
          'Notifications',
          style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
        ),
        actions: [
          if (!LoginStore.isGuest)
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NotificationSettings()),
                );
              },
              icon: Icon(FluentIcons.settings_24_regular, color: OColor.gray600, size: 22),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: OColor.gray200),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isInitialLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ListShimmer(count: 5, height: 80),
      );
    }
    if (_hasError) {
      return ErrorReloadScreen(reloadCallback: _loadInitialData);
    }

    final activeList = _selectedTab == 0 ? _personalNotifs : _generalNotifs;

    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTabToggle(),
        const SizedBox(height: 12),
        _buildFilterChips(activeList),
        const SizedBox(height: 8),
        Expanded(child: _buildNotificationList(activeList)),
      ],
    );
  }

  Widget _buildTabToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: OColor.gray100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(child: _buildTabButton('Focused', 0)),
            Expanded(child: _buildTabButton('General', 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedTab = index;
        _selectedFilter = 'All';
      }),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? OColor.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: OColor.gray200) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: OTextStyle.labelSmall.copyWith(
              color: isSelected ? OColor.gray800 : OColor.gray500,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(List<NotifsModel> notifs) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categoryFilters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _categoryFilters[index];
          final isSelected = _selectedFilter == filter;
          final count = _countForFilter(filter, notifs);
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? OColor.green600 : OColor.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? OColor.green600 : OColor.gray300,
                ),
              ),
              child: Text(
                count > 0 ? '$filter $count' : filter,
                style: OTextStyle.labelSmall.copyWith(
                  color: isSelected ? OColor.white : OColor.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationList(List<NotifsModel> notifs) {
    final filtered = notifs.where(_matchesFilter).toList();
    if (filtered.isEmpty) return _buildEmptyState();

    final grouped = _groupByTime(filtered);
    final sections = grouped.entries.toList();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // +1 for the loading indicator at the bottom
      itemCount: sections.length + (_selectedTab == 1 && _generalHasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= sections.length) {
          // Loading indicator at the bottom
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: OColor.green600,
                ),
              ),
            ),
          );
        }

        final section = sections[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  section.key,
                  style: OTextStyle.headingSmall.copyWith(
                    color: OColor.gray800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (section.key == 'Unread') ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: OColor.green600,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            ...section.value.map((notif) => _buildNotificationTile(notif)),
          ],
        );
      },
    );
  }

  Widget _buildNotificationTile(NotifsModel notif) {
    final action = _actionForCategory(notif.category);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: OColor.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconForCategory(notif.category),
                color: OColor.gray600,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_categoryLabel(notif.category)} \u2022 ${_timeAgo(notif.time)}',
                    style: OTextStyle.bodyXSmall.copyWith(
                      color: OColor.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body ?? notif.title ?? '',
                    style: OTextStyle.bodySmall.copyWith(
                      color: OColor.gray800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _navigateForCategory(notif.category),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: OColor.gray300),
                  ),
                  child: Text(
                    action,
                    style: OTextStyle.labelSmall.copyWith(
                      color: OColor.green600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FluentIcons.alert_off_24_regular, color: OColor.gray400, size: 48),
          const SizedBox(height: 12),
          Text(
            'No notifications found',
            style: OTextStyle.bodyMedium.copyWith(color: OColor.gray500),
          ),
        ],
      ),
    );
  }
}
