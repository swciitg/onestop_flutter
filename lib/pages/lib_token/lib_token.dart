import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/profile_url.dart';
import 'package:onestop_dev/globals/my_colors.dart';

import 'dart:ui';
import 'package:onestop_dev/pages/lib_token/token_genrate.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web_socket_channel/io.dart';

// --- Data Model and Constants ---

void log(String message) {
  dev.log(message, name: "LibToken");
}

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
    int timerCount = 25;
    _timer?.cancel();

    setState(() {
      token = generateToken();
      showQr = true;
      isTokenExpired = false;
    });

    try {
      if (channel.closeCode != null) {
        handleSocket();
      } else {
        sendToken();
      }
    } catch (e) {
      handleSocket();
    }

    _timer = Timer(Duration(seconds: timerCount), () {
      if (mounted) {
        setState(() {
          isTokenExpired = true;
        });
      }
    });
  }

  void sendToken() {
    channel.sink.add(
      jsonEncode({
        "type": "store_token",
        "data": {"token": token, "roll_no": user.rollNo},
      }),
    );
    log("Token: $token");
  }

  void handleSocket() async {
    final url = Uri.parse('$wsUrl?roll_no=${user.rollNo}');
    log("Connecting to web socket: $url");
    log(url.toString());
    channel = IOWebSocketChannel.connect(url);

    log("CONNECTOIN ESTABLISHED");

    sendToken();

    channel.stream.listen(
      (data) {
        log(data.toString());

        try {
          final payload = jsonDecode(data.toString());
          if (payload['type'] == "slot_info") {
            final slotData = Map<String, dynamic>.from(payload['data']);
            final SlotInfo newSlot = SlotInfo.fromJson(slotData);

            log("Decoded Slot: ${newSlot.toJson()}");
            if (mounted) {
              setState(() {
                _currentSlot = newSlot;
              });
            }
          }
        } catch (e) {
          log("SLOT DECODING ERROR: $e");
        }
      },
      onError: (error) async {
        log("SOCKET ERROR: $error");
        // Attempt to reconnect after error
        await channel.sink.close();
        Future.delayed(Duration(seconds: 2), () {
          // if (mounted) initLibToken();
        });
      },
      onDone: () async {
        log("SOCKET CONNECTION CLOSED");
        // Attempt to reconnect when connection closes
        await channel.sink.close();
        Future.delayed(Duration(seconds: 2), () {
          // if (mounted) initLibToken();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTokenCycle();
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
                        child: CachedNetworkImage(
                          imageUrl: getUserProfileUrlByRoll(user.rollNo),
                          imageBuilder:
                              (context, imageProvider) => Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                          placeholder:
                              (context, url) => Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: Icon(Icons.person, color: Colors.grey[600], size: 60),
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
                    // Text(
                    //   token,
                    //   //user.rollNo,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     color: kWhite,
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.w600,
                    //     height: 1.43,
                    //   ),
                    // ),
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
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            QrImageView(
                              data: token,
                              version: QrVersions.auto,
                              // size: 150,
                              gapless: true,
                              embeddedImageStyle: const QrEmbeddedImageStyle(color: Colors.white),
                              eyeStyle: const QrEyeStyle(
                                color: Colors.black,
                                eyeShape: QrEyeShape.square,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                color: Colors.black,
                                dataModuleShape: QrDataModuleShape.square,
                              ),
                            ),
                            if (isTokenExpired)
                              ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(color: Colors.transparent),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: startTokenCycle,
                                        icon: const Icon(
                                          Icons.refresh,
                                          color: OneStopColors.kYellow,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
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
