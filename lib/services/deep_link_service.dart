import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';
import 'package:onestop_dev/pages/timetable/timetable_page.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._();
  static DeepLinkService get instance => _instance;
  DeepLinkService._();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _subscription;

  /// Pending link received before the app was ready to navigate.
  static Uri? _pendingUri;
  static bool get hasPending => _pendingUri != null;

  Future<void> initialize() async {
    _appLinks = AppLinks();

    // Check if app was launched from a universal link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null && _isHandledLink(initialUri)) {
        _pendingUri = initialUri;
        log('Initial deep link: $initialUri', name: 'DeepLinkService');
      }
    } catch (e) {
      log('Error getting initial link: $e', name: 'DeepLinkService');
    }

    // Listen for links while app is running
    _subscription = _appLinks.uriLinkStream.listen((Uri uri) {
      log('Received link: $uri', name: 'DeepLinkService');
      if (_isHandledLink(uri)) {
        _handleLink(uri);
      }
    });
  }

  /// Call this after the user is logged in and the navigator is ready.
  void handlePendingLink() {
    if (_pendingUri == null) return;
    final uri = _pendingUri!;
    _pendingUri = null;
    log('Handling pending link: $uri', name: 'DeepLinkService');
    _handleLink(uri);
  }

  bool _isHandledLink(Uri uri) {
    // Universal links: https://swc.iitg.ac.in/onestop/app/...
    if (uri.scheme == 'https' &&
        uri.host == 'swc.iitg.ac.in' &&
        uri.path.startsWith('/onestop/app')) {
      return true;
    }
    // Custom scheme from widgets: onestopiitg://gatelog, onestopiitg://home2
    if (uri.scheme == 'onestopiitg' && uri.host != 'auth') {
      return true;
    }
    return false;
  }

  void _handleLink(Uri uri) {
    if (uri.scheme == 'onestopiitg') {
      _handleCustomSchemeLink(uri);
    } else {
      _handleUniversalLink(uri);
    }
  }

  /// Handle onestopiitg://host?params links (from widgets)
  void _handleCustomSchemeLink(Uri uri) {
    final host = uri.host;
    final params = uri.queryParameters;

    log('Custom scheme: host=$host, params=$params', name: 'DeepLinkService');

    switch (host) {
      case 'gatelog':
        _navigateToGateLog(params);
        break;
      case 'home2':
        final tab = int.tryParse(params['tab'] ?? '');
        final nav = navigatorKey.currentState;
        if (nav == null) break;
        // Pop back to the existing HomePage instead of pushing a new one
        // (pushing creates duplicate GlobalKeys and crashes).
        nav.popUntil((route) => route.settings.name == HomePage.id || route.isFirst);
        if (tab != null) {
          HomePage.pendingTab.value = tab;
        }
        break;
      case 'timetable':
        navigatorKey.currentState?.pushNamed(TimetablePage.id);
        break;
      default:
        log('Unknown custom scheme host: $host', name: 'DeepLinkService');
        break;
    }
  }

  /// Handle https://swc.iitg.ac.in/onestop/app/... links
  void _handleUniversalLink(Uri uri) {
    final path = uri.path.replaceFirst('/onestop/app', '').replaceAll(RegExp(r'^/+'), '');
    final params = uri.queryParameters;

    log('Universal link: path=$path, params=$params', name: 'DeepLinkService');

    switch (path) {
      case 'gatelog':
        _navigateToGateLog(params);
        break;
      default:
        log('Unknown deep link path: $path', name: 'DeepLinkService');
        break;
    }
  }

  void _navigateToGateLog(Map<String, String> params) {
    final args = <String, dynamic>{};
    if (params.containsKey('destination')) {
      args['destination'] = params['destination'];
    }
    if (params['autoCheckIn'] == 'true') {
      args['autoCheckIn'] = true;
    }
    navigatorKey.currentState?.pushNamed(
      GateLogPage.id,
      arguments: args.isNotEmpty ? args : null,
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}
