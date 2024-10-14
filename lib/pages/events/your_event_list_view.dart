import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/event_tile.dart';
import 'package:onestop_dev/pages/events/event_description.dart';
import 'package:onestop_dev/pages/events/event_form_screen.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_kit/onestop_kit.dart';

class YourEventListView extends StatelessWidget {
  final PagingController<int, EventModel> pagingController;

  const YourEventListView({Key? key, required this.pagingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    pagingController.addPageRequestListener((pageKey) async {
      await _fetchPage(pageKey);
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1b1b1d),
      body: Stack(
        children: [
          PagedListView<int, EventModel>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<EventModel>(
              itemBuilder: (context, event, index) => EventTile(
                onTap: () => _navigateToEventDetails(context, event),
                model: event,
              ),
              firstPageErrorIndicatorBuilder: (context) => ErrorReloadScreen(
                reloadCallback: () => pagingController.refresh(),
              ),
              noItemsFoundIndicatorBuilder: (context) => const Center(
                child: Text('No events found'),
              ),
              firstPageProgressIndicatorBuilder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
              newPageProgressIndicatorBuilder: (context) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              noMoreItemsIndicatorBuilder: (context) => const Center(
                child: Text("You've reached the end"),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventFormScreen()),
                );
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
          )
        ],
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await APIService().getEventPage('Your Events');
      final isLastPage = newItems.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        pagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  void _navigateToEventDetails(BuildContext context, EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
    );
  }
}
