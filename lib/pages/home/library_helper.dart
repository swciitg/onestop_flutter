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

    // debugPrint('$baseUrl/check-status?rollNo=${user.rollNo}');

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

    // debugPrint(
    //   "Library slot response: ${response.statusCode} - ${response.data}",
    // );

    if (response.statusCode == 200) {
      final data = response.data;
      if (isMounted()) {
        final slotId = data['slotId'] ?? data['slotid'];
        final isBanned = data['isBanned'] ?? data['banend'] ?? false;
        final message = data['message'] as String?;
        final currentRouteName = ModalRoute.of(context)?.settings.name;
        final isOnLibraryTokenScreen =
            currentRouteName == LibraryTokenScreen.id;

        final isBagPresent = slotId != null && message != null;
        context.read<CommonStore>().setBagInLibrary(isBagPresent);

        onStateUpdate(isBagPresent, message);

        if (isBanned && !isOnLibraryTokenScreen) {
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
                    backgroundColor: OColor.gray100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      side: BorderSide(color: OColor.gray200, width: 1.0),
                    ),
                    titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    title: OText(
                      text: "Alert",
                      style: OTextStyle.headingMedium.copyWith(
                        color: OColor.gray800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: OText(
                      text:
                          message ??
                          "You are banned from using onestop. Please collect your bag from the library.",
                      textAlign: TextAlign.left,
                      style: OTextStyle.bodyMedium.copyWith(
                        color: OColor.black,
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          setDialogShowing(false);
                          parentNavigator.pushNamed(LibraryTokenScreen.id).then(
                            (_) {
                              if (!isMounted()) return;
                              checkLibrarySlot(
                                context: context,
                                isMounted: isMounted,
                                onStateUpdate: onStateUpdate,
                                isBannedDialogShowing: false,
                                setDialogShowing: setDialogShowing,
                              );
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          decoration: BoxDecoration(
                            color: OColor.green600,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          alignment: Alignment.center,
                          child: OText(
                            text: "Library Token",
                            style: OTextStyle.bodyMedium.copyWith(
                              color: OColor.white,
                              fontWeight: FontWeight.bold,
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
