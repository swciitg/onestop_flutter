import 'dart:convert';
import 'dart:developer' as dev;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/profile_url.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';

import 'package:web_socket_channel/io.dart';

// --- Data Model and Constants ---

void log(String message) {
  dev.log(message, name: "LibToken");
}

const baseUrl = String.fromEnvironment("LIB_TOKEN_BASE_URL");
const wsUrl = String.fromEnvironment("LIB_TOKEN_SOCKET_URL");

// Data model for the slot information
class SlotInfo {
  final int? slotId;
  final bool? isEmpty;
  final String? time;
  final String? date;

  SlotInfo({this.slotId, this.isEmpty, this.time, this.date});

  factory SlotInfo.fromJson(Map<String, dynamic> json) {
    return SlotInfo(
      slotId: json['slotId'] as int?,
      isEmpty: json['isEmpty'] ?? false,
      time: json['time'] as String?,
      date: json['date'] as String?,
    );
  }

  bool get isAssigned => slotId != null && isEmpty != null && isEmpty == false;

  Map<String, dynamic> toJson() {
    return {'slotId': slotId, 'isEmpty': isEmpty, 'time': time, 'date': date};
  }
}

const roll = "230121021";
Future<SlotInfo> getSlots(String rollNo) async {
  try {
    Dio dio = Dio();
    final response = await dio.get("$baseUrl/slot/$rollNo");
    log("$baseUrl/slot/$rollNo");
    log(response.data.toString());

    if (response.statusCode == 200) {
      if (response.data != null && response.data["slotId"] != null) {
        return SlotInfo.fromJson(Map<String, dynamic>.from(response.data));
      } else {
        return SlotInfo();
      }
    } else {
      throw Exception(
        "status code - ${response.statusCode} body - ${response.data}",
      );
    }
  } on DioException catch (e) {
    log("Dio error fetching slots: $e");
    return SlotInfo();
  } catch (e) {
    // log()
    log("General error fetching slots: $e");
    rethrow;
  }
}

// --- Flutter Widget ---

class Library extends StatefulWidget {
  static const id = "/librarytoken";
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final OneStopUser user = OneStopUser.fromJson(LoginStore.userData);

  SlotInfo? _currentSlot;

  late IOWebSocketChannel channel;

  void handleSocket() async {
    channel = IOWebSocketChannel.connect(
      Uri.parse('$wsUrl?roll_no=${user.rollNo}'),
    );

    channel.stream.listen(
      (data) {
        log("slot received");
        log(data.toString());

        try {
          final slotData = Map<String, dynamic>.from(
            data is String ? Map<String, dynamic>.from(jsonDecode(data))['data'] : data,
          );
          final SlotInfo newSlot = SlotInfo.fromJson(slotData);

          log("Decoded Slot: ${newSlot.toJson()}");
          if (!mounted) return;
          setState(() {
            _currentSlot = newSlot;
          });
        } catch (e) {
          log("SLOT DECODING ERROR: $e");
        }
      },
      onError: (error) {
        log("SOCKET ERROR: $error");
        // Attempt to reconnect after error
        // Future.delayed(Duration(seconds: 5), () {
        //   if (mounted) handleSocket();
        // });
      },
      onDone: () {
        log("SOCKET CONNECTION CLOSED");
        // Attempt to reconnect when connection closes
        // Future.delayed(Duration(seconds: 5), () {
        //   if (mounted) handleSocket();
        // });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getSlot();
  }

  void _getSlot() async {
    log("connecting to web Socket");
    final initialSlotFuture = await getSlots(roll);
    setState(() {
      _currentSlot = initialSlotFuture;
    });
    handleSocket();
    log("connecting to web Socket");
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OneStopColors.backgroundColor,
        centerTitle: true,
        leadingWidth: 100,
        scrolledUnderElevation: 0,
        leading: OneStopBackButton(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        title: AppBarTitle(title: 'Library Token'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFF252525),
                  /* White */
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0x50E9E9EA) /* Colors-Green-600 */,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset(
                                  'assets/images/iitg_logo.png',
                                ),
                              ),
                            ),
                            WidgetSpan(child: SizedBox(width: 16)),
                            TextSpan(
                              text: 'Indian Institute of Technology, Guwahati',
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.43,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 8),
                    Divider(color: const Color(0x50E9E9EA)),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: getUserProfileUrlByRoll(user.rollNo),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      user.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.40,
                      ),
                    ),
                    Text(
                      user.rollNo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.43,
                      ),
                    ),
                    Text(
                      user.outlookEmail,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: BarcodeWidget(
                          drawText: false,
                          barcode: Barcode.code128(),
                          data: user.rollNo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              if (_currentSlot?.isAssigned == true) _currentSlotDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Container _currentSlotDetails() {
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFF252525),
        /* White */
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0x50E9E9EA) /* Colors-Green-600 */,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Slot No.',
            style: const TextStyle(
              color: Color(0xFFA2ACC0),
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentSlot!.slotId.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateFormat('MMM dd, hh:mm a').format(
                  DateTime.parse("${_currentSlot!.date} ${_currentSlot!.time}"),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
