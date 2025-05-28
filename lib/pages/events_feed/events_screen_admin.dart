import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events_feed/events_screen.dart';
import 'package:onestop_dev/pages/events_feed/your_event_list_view.dart';
import 'package:onestop_dev/repository/events_api_repository.dart';
import 'package:onestop_dev/stores/event_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';

class EventsScreen1 extends StatefulWidget {
  const EventsScreen1({super.key});

  @override
  State<EventsScreen1> createState() => _EventsScreen1State();
}

class _EventsScreen1State extends State<EventsScreen1> with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, PagingController<int, EventModel>> _pagingControllers = {
    'Your Events': PagingController(
      fetchPage: (pageKey) async {
        var admin = EventsStore().admin;
        admin ??= await EventsAPIRepository().getAdmins();
        if (admin == null) return [];
        EventsStore().setAdmin(admin);
        final userClubs = admin.getUserClubs(LoginStore.userData['outlookEmail']!);
        final yourClub = userClubs.first.name;
        return EventsAPIRepository().getEventPage(yourClub);
      },
      getNextPageKey: (state) {
        final list = state.pages?.last ?? [];
        if (list.length < EventsStore().pageSize) {
          return null;
        }
        return state.keys?.last ?? 0 + 1;
      },
    ),
    'All': PagingController(
      fetchPage: (pageKey) => EventsAPIRepository().getEventPage('All'),
      getNextPageKey: (state) {
        final list = state.pages?.last ?? [];
        if (list.length < EventsStore().pageSize) {
          return null;
        }
        return state.keys?.last ?? 0 + 1;
      },
    ),
    'Academic': PagingController(
      fetchPage: (pageKey) => EventsAPIRepository().getEventPage('Academic'),
      getNextPageKey: (state) {
        final list = state.pages?.last ?? [];
        if (list.length < EventsStore().pageSize) {
          return null;
        }
        return state.keys?.last ?? 0 + 1;
      },
    ),
    'Sports': PagingController(
      fetchPage: (pageKey) => EventsAPIRepository().getEventPage('Sports'),
      getNextPageKey: (state) {
        final list = state.pages?.last ?? [];
        if (list.length < EventsStore().pageSize) {
          return null;
        }
        return state.keys?.last ?? 0 + 1;
      },
    ),
    'Technical': PagingController(
      fetchPage: (pageKey) => EventsAPIRepository().getEventPage('Technical'),
      getNextPageKey: (state) {
        final list = state.pages?.last ?? [];
        if (list.length < EventsStore().pageSize) {
          return null;
        }
        return state.keys?.last ?? 0 + 1;
      },
    ),
    'Cultural': PagingController(
      fetchPage: (pageKey) => EventsAPIRepository().getEventPage('Cultural'),
      getNextPageKey: (state) {
        final list = state.pages?.last ?? [];
        if (list.length < EventsStore().pageSize) {
          return null;
        }
        return state.keys?.last ?? 0 + 1;
      },
    ),
    'Welfare': PagingController(
      fetchPage: (pageKey) => EventsAPIRepository().getEventPage('Welfare'),
      getNextPageKey: (state) {
        final list = state.pages?.last ?? [];
        if (list.length < EventsStore().pageSize) {
          return null;
        }
        return state.keys?.last ?? 0 + 1;
      },
    ),
    'SWC': PagingController(
      fetchPage: (pageKey) => EventsAPIRepository().getEventPage('SWC'),
      getNextPageKey: (state) {
        final list = state.pages?.last ?? [];
        if (list.length < EventsStore().pageSize) {
          return null;
        }
        return state.keys?.last ?? 0 + 1;
      },
    ),
    'Miscellaneous': PagingController(
      fetchPage: (pageKey) => EventsAPIRepository().getEventPage('Miscellaneous'),
      getNextPageKey: (state) {
        final list = state.pages?.last ?? [];
        if (list.length < EventsStore().pageSize) {
          return null;
        }
        return state.keys?.last ?? 0 + 1;
      },
    ),
  };

  @override
  void initState() {
    super.initState();
    final eventsStore = context.read<EventsStore>();

    _tabController = TabController(length: _pagingControllers.keys.length, vsync: this);

    // Listener to update tab selection on tap or swipe
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        eventsStore.setSelectedEventTab(_tabController.index);
      }
    });

    _tabController.animation?.addListener(() {
      final newIndex = _tabController.animation?.value.round();
      if (newIndex != null && newIndex != eventsStore.selectedEventTab) {
        eventsStore.setSelectedEventTab(newIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsStore = context.read<EventsStore>();
    final tabs = [
      'Your Events',
      'All',
      'Academic',
      'Sports',
      'Technical',
      'Cultural',
      'Welfare',
      'SWC',
      'Miscellaneous',
    ];

    return Observer(
      builder:
          (context) => DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF1b1b1d),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      eventsStore.setSelectedEventTab(index);
                    },
                    indicator: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.transparent)),
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 7.0),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    isScrollable: true,
                    tabs: List.generate(tabs.length, (index) {
                      return _buildTab(tabs[index], index, eventsStore);
                    }),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      YourEventListView(
                        pagingController: _pagingControllers['Your Events']!,
                        refresh: () {
                          _pagingControllers['Your Events']!.refresh();
                        },
                      ),
                      EventListView(pagingController: _pagingControllers['All']!),
                      EventListView(pagingController: _pagingControllers['Academic']!),
                      EventListView(pagingController: _pagingControllers['Sports']!),
                      EventListView(pagingController: _pagingControllers['Technical']!),
                      EventListView(pagingController: _pagingControllers['Cultural']!),
                      EventListView(pagingController: _pagingControllers['Welfare']!),
                      EventListView(pagingController: _pagingControllers['SWC']!),
                      EventListView(pagingController: _pagingControllers['Miscellaneous']!),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Tab _buildTab(String label, int index, EventsStore eventsStore) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: eventsStore.selectedEventTab == index ? lBlue2 : kGrey9,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Montserrat',
            color:
                eventsStore.selectedEventTab == index
                    ? const Color(0xFF001B3E)
                    : const Color(0xFFDAE3F9),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var controller in _pagingControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
