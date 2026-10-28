import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/providers/events_provider.dart';
import 'package:onestop_dev/pages/events/widgets/event_popup.dart';
import 'package:onestop_dev/pages/events/widgets/event_search_bar.dart';
import 'package:onestop_dev/pages/events/widgets/events_list_card.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Lists every event grouped by day, with search, date, tag and organiser
/// filters. The next page is fetched as the user scrolls.
class AllEvents extends StatefulWidget {
  static const id = "/events/all";
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  // Reads (non-subscribing); [build] subscribes via `context.watch`.
  EventsProvider get _p => context.read<EventsProvider>();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.text = _p.allSearch;
      _p.loadAllEvents(force: true);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      _p.loadMoreAllEvents();
    }
  }

  /// A short filtered list may not be scrollable; keep fetching until it is.
  void _fillViewport() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      if (_scrollController.position.maxScrollExtent <= 0) {
        _p.loadMoreAllEvents();
      }
    });
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 400),
      () => _p.setAllEventsFilters(search: query),
    );
    setState(() {});
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _p.allDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) _p.setAllEventsFilters(date: picked);
  }

  Future<void> _pickFromList({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
    required VoidCallback onCleared,
  }) async {
    if (options.isEmpty) return;
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: OColor.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      clipBehavior: Clip.antiAlias,
      builder:
          (context) =>
              _FilterSheet(title: title, options: options, selected: selected),
    );
    if (choice == null) return;
    // Tapping the selected option again clears the filter.
    choice == selected ? onCleared() : onSelected(choice);
  }

  Future<void> _openEventPopup(EventModel event) {
    return showEventPopup(
      context,
      event: event,
      isInitiallyInterested: _p.isGoing(event),
      isInitiallyRegistered: event.userStatus?.isRegistered ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsProvider>();

    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        surfaceTintColor: OColor.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(TablerIcons.arrow_left, size: 24, color: OColor.green800),
        ),
        title: Text(
          "All Events",
          style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: OColor.gray200),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _p.loadAllEvents(force: true),
        color: OColor.green600,
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(EventsProvider provider) {
    final items = _buildItems(provider.allEvents);
    final showInitialLoader =
        provider.isAllEventsLoading && provider.allEvents.isEmpty;
    if (!showInitialLoader && provider.hasMoreAllEvents) _fillViewport();

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        OSpacing.m,
        OSpacing.m,
        OSpacing.m,
        OSpacing.xl,
      ),
      // header block + body rows + footer row
      itemCount: 1 + (items.isEmpty ? 1 : items.length) + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildFilters(provider);

        final bodyCount = items.isEmpty ? 1 : items.length;
        if (index == bodyCount + 1) {
          return provider.isAllEventsLoadingMore
              ? const Padding(
                padding: EdgeInsets.symmetric(vertical: OSpacing.m),
                child: Center(child: CircularProgressIndicator()),
              )
              : const SizedBox.shrink();
        }

        if (items.isEmpty) {
          return showInitialLoader
              ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
              : _buildEmptyState(provider);
        }

        final item = items[index - 1];
        if (item is String) {
          return Padding(
            padding: EdgeInsets.only(
              top: index == 1 ? 0 : OSpacing.l,
              bottom: OSpacing.s,
            ),
            child: OText(
              text: item,
              style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
            ),
          );
        }
        final event = item as EventModel;
        return Padding(
          padding: const EdgeInsets.only(bottom: OSpacing.xs),
          child: RepaintBoundary(
            child: EventsListCard(
              event: event,
              onTap: () => _openEventPopup(event),
            ),
          ),
        );
      },
    );
  }

  /// Flattens [events] into day headers (String) followed by their events,
  /// keeping the order the backend returned them in.
  List<Object> _buildItems(List<EventModel> events) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final items = <Object>[];
    DateTime? currentDay;
    for (final event in events) {
      final start = event.startDateTime;
      final day = DateTime(start.year, start.month, start.day);
      if (currentDay != day) {
        currentDay = day;
        items.add(_dayLabel(day, today));
      }
      items.add(event);
    }
    return items;
  }

  String _dayLabel(DateTime day, DateTime today) {
    final diff = day.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return '${day.day}${_daySuffix(day.day)} ${DateFormat('MMM').format(day)}';
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Widget _buildFilters(EventsProvider provider) {
    final date = provider.allDate;
    return Padding(
      padding: const EdgeInsets.only(bottom: OSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: EventSearchBar(
                  placeholder: 'Search Events',
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onClear: () => _p.setAllEventsFilters(search: ''),
                ),
              ),
              const SizedBox(width: OSpacing.xs),
              _FilterTile(
                icon: FluentIcons.calendar_clock_24_regular,
                label: date == null ? 'Date' : DateFormat('d MMM').format(date),
                onTap: _pickDate,
                onClear:
                    date == null
                        ? null
                        : () => _p.setAllEventsFilters(clearDate: true),
              ),
            ],
          ),
          const SizedBox(height: OSpacing.s),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: provider.allTag ?? 'Tag',
                  isSelected: provider.allTag != null,
                  onTap:
                      () => _pickFromList(
                        title: 'Select Tag',
                        options: EventsProvider.allEventTagOptions,
                        selected: provider.allTag,
                        onSelected: (v) => _p.setAllEventsFilters(tag: v),
                        onCleared: () => _p.setAllEventsFilters(clearTag: true),
                      ),
                  onClear: () => _p.setAllEventsFilters(clearTag: true),
                ),
                const SizedBox(width: OSpacing.xs),
                _FilterChip(
                  label: provider.allOrganiser ?? 'Organiser',
                  isSelected: provider.allOrganiser != null,
                  onTap:
                      () => _pickFromList(
                        title: 'Select Organiser',
                        options: provider.allEventOrganiserOptions,
                        selected: provider.allOrganiser,
                        onSelected: (v) => _p.setAllEventsFilters(organiser: v),
                        onCleared:
                            () => _p.setAllEventsFilters(clearOrganiser: true),
                      ),
                  onClear: () => _p.setAllEventsFilters(clearOrganiser: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(EventsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            FluentIcons.calendar_24_regular,
            size: 48,
            color: OColor.gray400,
          ),
          const SizedBox(height: OSpacing.s),
          OText(
            text:
                provider.hasAllEventsError
                    ? 'Unable to load events'
                    : provider.hasAllEventsFilters
                    ? 'No events match your filters'
                    : 'No events yet',
            style: OTextStyle.bodyMedium.copyWith(color: OColor.gray700),
          ),
        ],
      ),
    );
  }
}

/// White bordered tile (e.g. the "Date" button next to the search bar).
class _FilterTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _FilterTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.s),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: OColor.green600),
            const SizedBox(width: OSpacing.xs),
            OText(
              text: label,
              style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
            ),
            if (onClear != null) ...[
              const SizedBox(width: OSpacing.xs),
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  FluentIcons.dismiss_16_regular,
                  size: 16,
                  color: OColor.gray600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pill-style filter: filled green with an "x" when selected, outlined with a
/// chevron otherwise.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? OColor.white : OColor.gray600;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: OSpacing.l,
          vertical: OSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? OColor.green600 : null,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: isSelected ? null : Border.all(color: OColor.gray300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OText(
              text: label,
              style: OTextStyle.labelMedium.copyWith(color: color),
            ),
            const SizedBox(width: OSpacing.xxs),
            if (isSelected)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  FluentIcons.dismiss_16_regular,
                  size: 16,
                  color: color,
                ),
              )
            else
              Icon(FluentIcons.chevron_down_16_regular, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet listing [options] as bordered rows with a checkbox; pops with
/// the tapped option.
class _FilterSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selected;

  const _FilterSheet({
    required this.title,
    required this.options,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: OSpacing.m,
            vertical: OSpacing.l,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    FluentIcons.settings_24_regular,
                    size: 32,
                    color: OColor.green600,
                  ),
                  const SizedBox(width: OSpacing.m),
                  Expanded(
                    child: OText(
                      text: title,
                      style: OTextStyle.labelLarge.copyWith(
                        color: OColor.gray800,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(OSpacing.xs),
                      decoration: BoxDecoration(
                        color: OColor.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FluentIcons.dismiss_24_regular,
                        size: 24,
                        color: OColor.gray800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OSpacing.l),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder:
                      (_, _) => const SizedBox(height: OSpacing.xs),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return _FilterOptionRow(
                      label: option,
                      isSelected: option == selected,
                      onTap: () => Navigator.pop(context, option),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterOptionRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOptionRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(OSpacing.m),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            Expanded(
              child: OText(
                text: label,
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
              ),
            ),
            const SizedBox(width: OSpacing.m),
            Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OColor.gray500),
              ),
              child:
                  isSelected
                      ? DecoratedBox(
                        decoration: BoxDecoration(
                          color: OColor.green600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
