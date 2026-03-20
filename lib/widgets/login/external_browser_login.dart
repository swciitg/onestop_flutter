import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/database_strings.dart' as db;
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/pages/login/login.dart';
import 'package:onestop_dev/pages/profile/edit_profile.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// External Browser Login Widget
///
/// This widget replaces the WebView-based authentication with a more secure
/// external browser approach. It uses the system's default browser for OAuth
/// authentication and handles the callback via deep links.
///
/// Key Features:
/// - Uses system browser for better security
/// - Supports saved passwords and biometric authentication
/// - Handles deep link callbacks for token retrieval
/// - Better user experience with native browser features
///
/// Deep Link Format: onestopiitg://auth?access_token=...&refresh_token=...
class ExternalBrowserLogin extends StatefulWidget {
  const ExternalBrowserLogin({super.key});

  @override
  State<ExternalBrowserLogin> createState() => _ExternalBrowserLoginState();
}

class _ExternalBrowserLoginState extends State<ExternalBrowserLogin> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
    _launchLogin();
  }

  void _initDeepLinkListener() {
    _appLinks = AppLinks();

    // Listen to incoming links when the app is already running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        log('Received deep link: $uri');
        _handleDeepLink(uri);
      },
      onError: (Object err) {
        log('Deep link error: $err');
        showSnackBar("Error handling authentication: $err");
        setState(() => _isLoading = false);
      },
    );
  }

  Future<void> _handleDeepLink(Uri uri) async {
    log('Handling deep link: $uri');

    if (uri.scheme == 'onestopiitg' && uri.host == 'auth') {
      log("Query parameters: ${uri.queryParameters}");
      final accessToken = uri.queryParameters['accessToken'];
      final refreshToken = uri.queryParameters['refreshToken'];
      final error = uri.queryParameters['error'];

      if (error != null) {
        log('Authentication error: $error');
        await _moveBackToWelcomePage();
        return;
      }

      if (accessToken != null && refreshToken != null) {
        log('Tokens received successfully');
        await _handleLoginSuccess(accessToken, refreshToken);
      } else {
        log('Tokens not found in deep link');
        await _moveBackToWelcomePage();
      }
    }
  }

  Future<void> _handleLoginSuccess(
    String accessToken,
    String refreshToken,
  ) async {
    try {
      final start = DateTime.now();
      setState(() => _isLoading = true);

      SharedPreferences user = await SharedPreferences.getInstance();
      if (!mounted) return;

      LoginStore.isGuest = false;
      await user.setBool('isGuest', false);

      Map userTokens = {
        db.BackendHelper.accesstoken: accessToken,
        db.BackendHelper.refreshtoken: refreshToken,
      };

      await LoginStore().saveTokensToPrefs(user, userTokens);
      await LoginStore().saveToUserInfo(user);

      log("LOGIN Time: ${DateTime.now().difference(start)}");

      if (!mounted) return;

      navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) => EditProfile(
                profileModel: OneStopUser.fromJson(LoginStore.userData),
              ),
        ),
        (route) => false,
      );
    } catch (e) {
      log('Login failed: $e');
      showSnackBar("Login failed: $e");
      await _moveBackToWelcomePage();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _moveBackToWelcomePage() async {
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      LoginPage.id,
      (_) => false,
    );
    await Future.delayed(const Duration(seconds: 1));
    showSnackBar("Error occurred: INCORRECT USER TOKENS");
  }

  Future<void> _launchLogin() async {
    setState(() => _isLoading = true);

    // Construct the authentication URL with the deep link redirect URI
    final authUrl = '${Endpoints.baseUrl}/auth/microsoft';

    try {
      final uri = Uri.parse(authUrl);
      log('Launching authentication URL: $authUrl');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        log('Successfully launched external browser');
      } else {
        log('Could not launch browser for URL: $authUrl');
        showSnackBar("Could not launch browser");
        setState(() => _isLoading = false);
        await _moveBackToWelcomePage();
      }
    } catch (e) {
      log('Error launching browser: $e');
      showSnackBar("Error launching browser: $e");
      setState(() => _isLoading = false);
      await _moveBackToWelcomePage();
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF148440),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Color(0xFF148440),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF148440), const Color(0xFFDCEFE4)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // App Logo
                  Image.asset(
                    'assets/images/app_logo_dark.png',
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(height: 24),
                  // Heading
                  Text(
                    _isLoading ? 'Authenticating' : 'Authentication Failed',
                    textAlign: TextAlign.center,
                    style: OTextStyle.displayXSmall.copyWith(
                      color: const Color(0xFF232329),
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Dancing Marquee (Full Width)
            // const DancingServiceMarquee(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  if (_isLoading) ...[
                    Text(
                      'Please complete the login in your browser.',
                      textAlign: TextAlign.center,
                      style: OTextStyle.labelMedium.copyWith(
                        color: const Color(0xFF232329).withOpacity(0.8),
                        letterSpacing: -0.76,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const CircularProgressIndicator(color: Color(0xFF148440)),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _launchLogin,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF148440)),
                        ),
                        child: Center(
                          child: Text(
                            'Reinitialize',
                            style: MyFonts.w600.copyWith(
                              fontSize: 16,
                              color: const Color(0xFF148440),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Something went wrong. Please try again.',
                      textAlign: TextAlign.center,
                      style: OTextStyle.labelMedium.copyWith(
                        color: Colors.red.withOpacity(0.8),
                        letterSpacing: -0.76,
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _launchLogin,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF148440),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Retry Login',
                            style: MyFonts.w600.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 15),
                  // Footer
                  Image.asset('assets/images/swc.png', height: 32),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
