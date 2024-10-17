import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/event_description.dart';
import 'package:onestop_dev/pages/events/event_tile.dart';
import 'package:onestop_dev/pages/events/your_event_list_view.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/event_store.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class EventsScreen1 extends StatefulWidget {
  @override
  State<EventsScreen1> createState() => _EventsScreen1State();
}

class _EventsScreen1State extends State<EventsScreen1> {
  final Map<String, PagingController<int, EventModel>> _pagingControllers = {
    'Your Events': PagingController(firstPageKey: 1, invisibleItemsThreshold: 1),
    'All Events': PagingController(firstPageKey: 1, invisibleItemsThreshold: 1),
    'Academic': PagingController(firstPageKey: 1, invisibleItemsThreshold: 1),
    'Sports': PagingController(firstPageKey: 1, invisibleItemsThreshold: 1),
    'Technical': PagingController(firstPageKey: 1, invisibleItemsThreshold: 1),
    'Cultural': PagingController(firstPageKey: 1, invisibleItemsThreshold: 1),
    'Welfare': PagingController(firstPageKey: 1, invisibleItemsThreshold: 1),
    'SWC': PagingController(firstPageKey: 1, invisibleItemsThreshold: 1),
    'Miscellaneous':
        PagingController(firstPageKey: 1, invisibleItemsThreshold: 1),
  };

  @override
  void initState() {
    super.initState();
    _pagingControllers.forEach((key, controller) {
      controller.addPageRequestListener((pageKey) async {
        await _fetchPage(controller, key, pageKey);
      });
    });
  }

  Future<void> _fetchPage(PagingController<int, EventModel> controller,
      String category, int pageKey) async {
    try {
      final newItems = await APIService().getEventPage(category);
      final isLastPage = newItems.length < EventsStore().pageSize;
      if (isLastPage) {
        controller.appendLastPage(newItems);
      } else {
        controller.appendPage(newItems, pageKey + 1);
      }
    } catch (error) {
      controller.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsStore = context.read<EventsStore>();

    return Observer(
      builder: (context) => DefaultTabController(
        length: 8,
        child: Column(
          children: [
            Container(
              color: const Color(0xFF1b1b1d),
              child: TabBar(
                onTap: eventsStore.setSelectedEventTab,
                indicator: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.transparent),
                  ),
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 7.0),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                isScrollable: true,
                tabs: [
                  _buildTab('Your Events', 0, eventsStore),
                  _buildTab('All Events', 1, eventsStore),
                  _buildTab('Academic', 2, eventsStore),
                  _buildTab('Sports', 3, eventsStore),
                  _buildTab('Technical', 4, eventsStore),
                  _buildTab('Cultural', 5, eventsStore),
                  _buildTab('Welfare', 6, eventsStore),
                  _buildTab('SWC', 7, eventsStore),
                  _buildTab('Miscellaneous', 8, eventsStore),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  YourEventListView(
                      pagingController: _pagingControllers['Your Events']!),
                  EventListView(
                      pagingController: _pagingControllers['All Events']!),
                  EventListView(
                      pagingController: _pagingControllers['Academic']!),
                  EventListView(
                      pagingController: _pagingControllers['Sports']!),
                  EventListView(
                      pagingController: _pagingControllers['Technical']!),
                  EventListView(
                      pagingController: _pagingControllers['Cultural']!),
                  EventListView(
                      pagingController: _pagingControllers['Welfare']!),
                  EventListView(pagingController: _pagingControllers['SWC']!),
                  EventListView(
                      pagingController: _pagingControllers['Miscellaneous']!),
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
          color: eventsStore.selectedEventTab == index
              ? Colors.blue
              : const Color(0xFF3E4758),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Montserrat',
            color: eventsStore.selectedEventTab == index
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
    _pagingControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}

class EventListView extends StatelessWidget {
  final PagingController<int, EventModel> pagingController;

  const EventListView({Key? key, required this.pagingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, EventModel>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<EventModel>(
        itemBuilder: (context, event, index) => EventTile(
          onTap: () => _navigateToEventDetails(context, event),
          model: event,
        ),
        firstPageErrorIndicatorBuilder: (context) => ErrorReloadScreen(
          reloadCallback: () => pagingController.refresh(),
        ),
        noItemsFoundIndicatorBuilder: (context) => const PaginationText(
          text: "No events found",
        ),
        firstPageProgressIndicatorBuilder: (context) => ListShimmer(
          count: 5,
          height: 120,
        ),
        newPageProgressIndicatorBuilder: (context) => const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        ),
        noMoreItemsIndicatorBuilder: (context) => const PaginationText(
          text: "You've reached the end",
        ),
      ),
    );
  }

  void _navigateToEventDetails(BuildContext context, EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event, isAdmin: false,)),
    );
  }
}
