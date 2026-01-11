import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/profile_url.dart';
import 'package:onestop_dev/globals/my_colors.dart';

import 'package:onestop_dev/pages/lib_token/token_genrate.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';

import 'package:web_socket_channel/io.dart';

// --- Data Model and Constants ---

void log(String message) {
  dev.log(message, name: "LibToken");
}

const baseUrl = String.fromEnvironment("LIB_TOKEN_BASE_URL");
const wsUrl = String.fromEnvironment("LIB_TOKEN_SOCKET_URL");

class SlotInfo {
  final int? slotId;
  final bool? isEmpty;
  final int? time;
  final String? date;
  final String? timeString;

  SlotInfo({this.slotId, this.isEmpty, this.time, this.date, this.timeString});

  factory SlotInfo.fromJson(Map<String, dynamic> json) {
    return SlotInfo(
      slotId: json['slotId'] as int?,
      isEmpty: json['isEmpty'] as bool? ?? false,
      time: json['time'] as int?,
      date: json['date'] as String?,
      timeString: json['timeString'] as String?,
    );
  }
  bool get isAssigned => slotId != null && isEmpty != null && isEmpty == false;

  Map<String, dynamic> toJson() {
    return {
      'slotId': slotId,
      'isEmpty': isEmpty,
      'time': time,
      'date': date,
      'timeString': timeString,
    };
  }

  DateTime? get dateTime {
    if (time != null) {
      return DateTime.fromMillisecondsSinceEpoch(time!);
    }

    if (date != null && timeString != null) {
      return DateTime.tryParse("$date $timeString");
    }

    return null;
  }
}

final Dio _dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

Future<SlotInfo> getSlots(String rollNo) async {
  try {
    // Dio _dio = Dio();
    final response = await _dio.get("$baseUrl/slot/$rollNo");
    // log("$baseUrl/slot/$rollNo");
    // log(response.data.toString());

    if (response.statusCode == 200) {
      if (response.data != null && response.data["slotId"] != null) {
        return SlotInfo.fromJson(Map<String, dynamic>.from(response.data));
      } else {
        return SlotInfo();
      }
    } else {
      throw Exception("status code - ${response.statusCode} body - ${response.data}");
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

  late String token;
  SlotInfo? _currentSlot;
  late IOWebSocketChannel channel;
  bool showQr = false;
  bool isTokenExpired = false;
  Timer? _timer;

  void startTokenCycle() {
    _timer?.cancel();
    try {
      channel.sink.close();
    } catch (e) {
      // Channel might not be initialized or already closed
    }

    setState(() {
      token = generateToken(8);
      showQr = true;
      isTokenExpired = false;
    });

    handleSocket();

    _timer = Timer(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          showQr = false;
          isTokenExpired = true;
        });
        channel.sink.close();
      }
    });
  }

  void handleSocket() async {
    log("connecting to web Socket");
    channel = IOWebSocketChannel.connect(Uri.parse('$wsUrl?roll_no=${user.rollNo}&token=$token'));

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
      onError: (error) async {
        log("SOCKET ERROR: $error");
        // Attempt to reconnect after error
        await channel.sink.close();
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) initLibToken();
        });
      },
      onDone: () async {
        log("SOCKET CONNECTION CLOSED");
        // Attempt to reconnect when connection closes
        await channel.sink.close();
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) initLibToken();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTokenCycle();
    initLibToken();
  }

  void initLibToken() async {
    final initialSlotFuture = await getSlots(user.rollNo);
    setState(() {
      _currentSlot = initialSlotFuture;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                                child: Image.asset('assets/images/iitg_logo.png'),
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
                      height: 180,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(imageUrl: getUserProfileUrlByRoll(user.rollNo)),
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
                      token,
                      //user.rollNo,
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
                        child:
                            showQr
                                ? BarcodeWidget(
                                  drawText: false,
                                  barcode: Barcode.code128(),
                                  data: token, //user.rollNo,D
                                )
                                : isTokenExpired
                                ? IconButton(
                                  onPressed: startTokenCycle,
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: OneStopColors.primaryColor,
                                    size: 40,
                                  ),
                                )
                                : const CircularProgressIndicator(),
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
          side: BorderSide(width: 1, color: const Color(0x50E9E9EA) /* Colors-Green-600 */),
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
                _currentSlot?.dateTime != null
                    ? DateFormat('MMM dd, hh:mm a').format(_currentSlot!.dateTime!)
                    : '--',
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
