import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/home/home_widget.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:onestop_ui/index.dart';

class HomeGateLogTile extends StatefulWidget {
  const HomeGateLogTile({super.key});

  @override
  State<HomeGateLogTile> createState() => _HomeGateLogTileState();
}

class _HomeGateLogTileState extends State<HomeGateLogTile> {
  static const _gatelogServerUrl = String.fromEnvironment('GATELOG_SERVER_URL');
  static const _securityKey = String.fromEnvironment('SECURITY_KEY');
  static const _serverUrl = String.fromEnvironment('SERVER_URL');

  Future<Map<String, dynamic>?>? _entryFuture;

  @override
  void initState() {
    super.initState();
    if (!LoginStore.isGuest) {
      _entryFuture = _fetchLatestEntry();
    }
  }

  Future<Map<String, dynamic>?> _fetchLatestEntry() async {
    try {
      final api = OneStopApi(
        serverBaseUrl: _gatelogServerUrl,
        onestopBaseUrl: _serverUrl,
        onestopSecurityKey: _securityKey,
        onRefreshTokenExpired: () async {},
      );
      final res = await api.serverDio.get(
        '/history',
        queryParameters: {'page': '1', 'size': '1'},
      );
      final history = res.data['history'] as List;
      if (history.isEmpty) return null;
      final entry = history.first as Map<String, dynamic>;
      if (entry['isClosed'] == true) return null;
      return entry;
    } catch (_) {
      return null;
    }
  }

  void _navigateToGateLog(
    BuildContext context, {
    String? destination,
    bool autoCheckIn = false,
  }) async {
    if (!LoginStore.isGuest) {
      final bagInLibrary = context.read<CommonStore>().isBagInLibrary;
      if (bagInLibrary) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Retrieve the bag from the library in order to checkout",
            ),
          ),
        );
        return;
      }
    }

    final args = <String, dynamic>{};
    if (destination != null) args['destination'] = destination;
    if (autoCheckIn) args['autoCheckIn'] = true;
    await Navigator.pushNamed(
      context,
      GateLogPage.id,
      arguments: args.isNotEmpty ? args : null,
    );
    if (!mounted || LoginStore.isGuest) return;
    setState(() {
      _entryFuture = _fetchLatestEntry();
    });
  }

  /// Khokha: 10 PM, KV: 10:30 PM, Main Gate: always open
  String _gateClosingInfo() {
    final now = DateTime.now();
    final khokhaClose = DateTime(now.year, now.month, now.day, 22, 0);
    final kvClose = DateTime(now.year, now.month, now.day, 22, 30);

    final khokhaLeft = khokhaClose.difference(now).inMinutes;
    final kvLeft = kvClose.difference(now).inMinutes;

    if (khokhaLeft > 0) {
      return 'KHOKHA CLOSES IN $khokhaLeft MINS';
    } else if (kvLeft > 0) {
      return 'KV GATE CLOSES IN $kvLeft MINS';
    } else {
      return 'ENTER VIA MAIN GATE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final bagInLibrary =
            LoginStore.isGuest
                ? false
                : context.read<CommonStore>().isBagInLibrary;

        Widget tile;
        if (LoginStore.isGuest || _entryFuture == null) {
          tile = _buildDefaultTile(context);
        } else {
          tile = FutureBuilder<Map<String, dynamic>?>(
            future: _entryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return _buildDefaultTile(context);
              }
              if (snapshot.hasData && snapshot.data != null) {
                return _buildCheckedOutTile(context, snapshot.data!);
              }
              return _buildDefaultTile(context);
            },
          );
        }

        return Opacity(opacity: bagInLibrary ? 0.5 : 1.0, child: tile);
      },
    );
  }

  Widget _buildCheckedOutTile(
    BuildContext context,
    Map<String, dynamic> entry,
  ) {
    final gateInfo = _gateClosingInfo();
    return GestureDetector(
      onTap: () => _navigateToGateLog(context),
      child: HomeWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/gate_log.svg",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OText(
                    text: 'Gatelog',
                    style: OTextStyle.headingSmall.copyWith(
                      color: OColor.green600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: OColor.gray400,
                  size: 16,
                ),
              ],
            ),
            const Spacer(),
            OText(
              text: 'Check into\nCampus',
              style: OTextStyle.bodyMedium.copyWith(
                color: OColor.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            const Spacer(),
            OText(
              text: gateInfo,
              style: OTextStyle.bodyXSmall.copyWith(
                color: OColor.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _navigateToGateLog(context, autoCheckIn: true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: OColor.gray300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: OText(
                  text: 'Check-In',
                  style: OTextStyle.bodySmall.copyWith(
                    color: OColor.green600,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultTile(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToGateLog(context),
      child: HomeWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/gate_log.svg",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OText(
                    text: 'Gatelog',
                    style: OTextStyle.headingSmall.copyWith(
                      color: OColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: OColor.gray400,
                  size: 16,
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(height: 44),
            Column(
              children: [
                GestureDetector(
                  onTap: () => _navigateToGateLog(context, destination: 'City'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: OColor.gray300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: OText(
                      text: 'To City',
                      style: OTextStyle.bodySmall.copyWith(
                        color: OColor.green600,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap:
                      () => _navigateToGateLog(context, destination: 'Khokha'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: OColor.gray300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: OText(
                      text: 'To Khoka',
                      style: OTextStyle.bodySmall.copyWith(
                        color: OColor.green600,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
