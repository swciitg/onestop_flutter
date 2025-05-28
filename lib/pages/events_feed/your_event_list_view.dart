import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/models/event_scheduler/admin_model.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events_feed/event_description.dart';
import 'package:onestop_dev/pages/events_feed/event_form_screen.dart';
import 'package:onestop_dev/pages/events_feed/event_tile.dart';
import 'package:onestop_dev/stores/event_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class YourEventListView extends StatefulWidget {
  final PagingController<int, EventModel> pagingController;
  final VoidCallback refresh;

  const YourEventListView({super.key, required this.pagingController, required this.refresh});

  @override
  State<YourEventListView> createState() => _YourEventListViewState();
}

class _YourEventListViewState extends State<YourEventListView> {
  late String? yourClub;

  @override
  void initState() {
    super.initState();
    Admin? admin = context.read<EventsStore>().admin;
    final userClubs = admin?.getUserClubs(LoginStore.userData['outlookEmail']!);
    yourClub = userClubs?.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1b1b1d),
      body: Stack(
        children: [
          PagingListener(
            controller: widget.pagingController,
            builder: (context, state, fetchNextPage) {
              return PagedListView<int, EventModel>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<EventModel>(
                  itemBuilder: (context, event, index) {
                    final currentTime = DateTime.now().toLocal();
                    final eventEndDateTime = event.endDateTime.toUtc();

                    // Compare hours and minutes
                    final isEventUpcomingbyhr =
                        eventEndDateTime.hour > currentTime.hour ||
                        (eventEndDateTime.hour == currentTime.hour &&
                            eventEndDateTime.minute > currentTime.minute);
                    final isEventUpcomingByDate = eventEndDateTime.day >= currentTime.day;
                    if (isEventUpcomingbyhr && isEventUpcomingByDate) {
                      return EventTile(
                        onTap: () => _navigateToEventDetails(context, event),
                        model: event,
                        isAdmin: true,
                        refresh: widget.refresh,
                      );
                    }
                    return Container();
                  },
                  firstPageErrorIndicatorBuilder:
                      (context) => ErrorReloadScreen(
                        reloadCallback: () => widget.pagingController.refresh(),
                      ),
                  noItemsFoundIndicatorBuilder:
                      (context) => const Center(child: Text('No events_feed found')),
                  firstPageProgressIndicatorBuilder:
                      (context) => const Center(child: CircularProgressIndicator()),
                  newPageProgressIndicatorBuilder:
                      (context) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  noMoreItemsIndicatorBuilder:
                      (context) => const Center(child: Text("You've reached the end")),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventFormScreen()),
          );
          widget.refresh();
        },
        backgroundColor: const Color(0xFF81AAF9),
        icon: const Icon(Icons.add, color: Color(0xFF001B3E), size: 15),
        label: const Text(
          'Add Event',
          style: TextStyle(
            color: Color(0xFF001B3E),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _navigateToEventDetails(BuildContext context, EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EventDetailsScreen(
              event: event,
              isAdmin: true,
              refresh: () {
                widget.pagingController.refresh();
              },
            ),
      ),
    );
  }
}
