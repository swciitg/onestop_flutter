import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/repository/notification_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/functions/utility/capitalize_string.dart';
import 'package:onestop_ui/index.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _isLoading = false;

  static const _categories = [
    NotificationCategories.cabSharing,
    NotificationCategories.lost,
    NotificationCategories.found,
    NotificationCategories.buy,
    NotificationCategories.sell,
  ];

  Future<void> _save() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await NotificationRepository()
          .updateNotificationPreferences(LoginStore.userData['notifPref']);
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.white,
      appBar: AppBar(
        backgroundColor: OColor.white,
        centerTitle: true,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: OColor.gray800, size: 24),
        ),
        title: Text(
          'Notification Settings',
          style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: OColor.gray200),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          ..._categories.map((cat) => _buildToggleRow(cat)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: OColor.green600,
                  foregroundColor: OColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Save',
                        style: OTextStyle.labelMedium.copyWith(color: OColor.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String category) {
    final prefs = LoginStore.userData['notifPref'];
    final isEnabled = prefs[category] == true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              capitalize(category),
              style: OTextStyle.bodyMedium.copyWith(
                color: OColor.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 44,
              height: 24,
              child: Switch.adaptive(
                value: isEnabled,
                activeTrackColor: OColor.green600,
                onChanged: (val) {
                  LoginStore.userData['notifPref'][category] = val;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
