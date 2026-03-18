import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';

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
      if (initialUri != null && _isOnestopLink(initialUri)) {
        _pendingUri = initialUri;
        log('Initial universal link: $initialUri', name: 'DeepLinkService');
      }
    } catch (e) {
      log('Error getting initial link: $e', name: 'DeepLinkService');
    }

    // Listen for links while app is running
    _subscription = _appLinks.uriLinkStream.listen((Uri uri) {
      log('Received link: $uri', name: 'DeepLinkService');
      if (_isOnestopLink(uri)) {
        _handleOnestopLink(uri);
      }
    });
  }

  /// Call this after the user is logged in and the navigator is ready.
  void handlePendingLink() {
    if (_pendingUri == null) return;
    final uri = _pendingUri!;
    _pendingUri = null;
    log('Handling pending link: $uri', name: 'DeepLinkService');
    _handleOnestopLink(uri);
  }

  bool _isOnestopLink(Uri uri) {
    return uri.scheme == 'https' &&
        uri.host == 'swc.iitg.ac.in' &&
        uri.path.startsWith('/onestop');
  }

  void _handleOnestopLink(Uri uri) {
    // Strip the /onestop prefix to get the feature path
    // e.g. /onestop/gatelog?destination=City → gatelog
    final path = uri.path.replaceFirst('/onestop', '').replaceAll(RegExp(r'^/+'), '');
    final params = uri.queryParameters;

    log('Routing: path=$path, params=$params', name: 'DeepLinkService');

    switch (path) {
      case 'gatelog':
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
        break;
      default:
        log('Unknown deep link path: $path', name: 'DeepLinkService');
        break;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
