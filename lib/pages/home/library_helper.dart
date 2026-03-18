import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lib_token/lib_token.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

Future<void> checkLibrarySlot({
  required BuildContext context,
  required bool Function() isMounted,
  required Function(bool showReminder, String? message) onStateUpdate,
  required bool isBannedDialogShowing,
  required Function(bool) setDialogShowing,
}) async {
  try {
    final user = OneStopUser.fromJson(LoginStore.userData);
    const baseUrl = String.fromEnvironment("LIB_TOKEN_BASE_URL");

    debugPrint('$baseUrl/check-status?rollNo=${user.rollNo}');

    final response = await Dio().get(
      '$baseUrl/check-status?rollNo=${user.rollNo}',
      options: Options(
        headers: {
          "Authorization": "Bearer ${await AuthUserHelpers.getAccessToken()}",
          "Content-Type": "application/json",
          'security-key': Endpoints.apiSecurityKey,
        },
      ),
    );

    debugPrint(
      "Library slot response: ${response.statusCode} - ${response.data}",
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (isMounted()) {
        final slotId = data['slotId'] ?? data['slotid'];
        final isBanned = data['isBanned'] ?? data['banend'] ?? false;
        final message = data['message'];

        final isBagPresent = slotId != null;
        context.read<CommonStore>().setBagInLibrary(isBagPresent);

        onStateUpdate(isBagPresent && !isBanned && message != null, message);

        if (isBanned) {
          if (!isBannedDialogShowing) {
            setDialogShowing(true);
            final parentNavigator = Navigator.of(context);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return PopScope(
                  canPop: false,
                  child: AlertDialog(
                    backgroundColor: OColor.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      side: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                    ),
                    title:  Text(
                      "Alert",
                      style: TextStyle(
                        color: OColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    actionsPadding: const EdgeInsets.all(16.0),
                    content: Text(
                      message ??
                          "You are banned from using onestop. Please collect your bag from the library.",
                      style:  TextStyle(
                        color: OColor.black,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: OColor.gray600, width: 1.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            setDialogShowing(false);
                            parentNavigator.pushNamed(
                              LibraryTokenScreen.id,
                            ).then((_) {
                              if (!isMounted()) return;
                              checkLibrarySlot(
                                context: context,
                                isMounted: isMounted,
                                onStateUpdate: onStateUpdate,
                                isBannedDialogShowing: false,
                                setDialogShowing: setDialogShowing,
                              );
                            });
                          },
                          child: Text(
                            "Library Token",
                            style: TextStyle(
                              color: OColor.green600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      }
    }
  } catch (e) {
    debugPrint("Error checking library slot: $e");
  }
}
