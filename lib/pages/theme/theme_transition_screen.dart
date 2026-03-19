import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/services/app_icon_service.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Inspirational quotes shown during theme transitions.
const List<Map<String, String>> _themeQuotes = [
  {'light': 'Rise and shine — a new day begins.', 'dark': "Stars can't shine without darkness."},
  {
    'light': 'Turn your face to the sun and let the shadows fall behind.',
    'dark': 'The moon teaches us that darkness is needed to shine.',
  },
  {'light': 'Every sunrise brings new possibilities.', 'dark': 'Embrace the calm of the night.'},
  {
    'light': 'Light up your world from within.',
    'dark': 'In the stillness of night, great ideas are born.',
  },
];

class ThemeTransitionScreen extends StatefulWidget {
  static const String id = '/theme-transition';

  /// Whether we're transitioning TO light mode.
  final bool toLight;

  const ThemeTransitionScreen({super.key, required this.toLight});

  @override
  State<ThemeTransitionScreen> createState() => _ThemeTransitionScreenState();
}

class _ThemeTransitionScreenState extends State<ThemeTransitionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final AnimationController _glowController;
  late final AnimationController _quoteController;
  late final Animation<double> _iconRotation;
  late final Animation<double> _iconScale;
  late final Animation<double> _glowRadius;
  late final Animation<double> _quoteOpacity;

  late final String _quote;

  @override
  void initState() {
    super.initState();

    // Pick a random quote pair
    final pair = _themeQuotes[Random().nextInt(_themeQuotes.length)];
    _quote = widget.toLight ? pair['light']! : pair['dark']!;

    // Main icon animation — rotate + scale
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _iconRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _iconController, curve: Curves.easeInOutCubic));
    _iconScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _iconController, curve: Curves.easeInOutCubic));

    // Glow pulse animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _glowRadius = Tween<double>(
      begin: 60.0,
      end: 120.0,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));

    // Quote fade-in
    _quoteController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _quoteOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _quoteController, curve: Curves.easeIn));

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Small delay to let the screen render
    await Future.delayed(const Duration(milliseconds: 200));

    // Start icon animation
    _iconController.forward();

    // Start glow pulse
    _glowController.repeat(reverse: true);

    // After icon starts, fade in quote
    await Future.delayed(const Duration(milliseconds: 600));
    _quoteController.forward();

    // Wait for the full animation to feel complete
    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      final themeStore = context.read<ThemeStore>();
      await themeStore.toggleTheme(notify: true);
      navigatorKey.currentState?.pop();

      if (Platform.isAndroid) {
        // Android: just restart the app (no icon change)
        // const channel = MethodChannel('com.swciitg.onestop2/restart');
        // await channel.invokeMethod('restartApp');
      } else {
        // iOS: switch app icon and restart
        final iconName = widget.toLight ? 'light' : 'dark';
        await AppIconService.setIcon(iconName);
        // await TerminateRestart.instance.restartApp(
        //   options: const TerminateRestartOptions(terminate: true),
        // );
      }
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    _glowController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Background = the theme we're transitioning TO
    final bgColor = widget.toLight ? Colors.white : Colors.black;

    final iconColor =
        widget.toLight
            ? const Color(0xFFF4A60B) // sun gold
            : const Color(0xFFCDCDD1); // moon silver

    final quoteColor =
        widget.toLight
            ? const Color(0xFF34343D) // dark text on white bg
            : const Color(0xFFCDCDD1); // light text on black bg

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle?.copyWith(
          statusBarColor: bgColor,
          systemNavigationBarColor: bgColor,
        ),
        leading: SizedBox.shrink(),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon with glow
            AnimatedBuilder(
              animation: Listenable.merge([_iconController, _glowController]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _iconScale.value,
                  child: Transform.rotate(
                    angle: _iconRotation.value * 2 * pi,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow effect
                        Container(
                          width: _glowRadius.value * 2,
                          height: _glowRadius.value * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: iconColor.withValues(alpha: 0.3),
                                blurRadius: _glowRadius.value,
                                spreadRadius: _glowRadius.value * 0.3,
                              ),
                            ],
                          ),
                        ),
                        // The icon itself
                        _buildThemeIcon(iconColor),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            // Quote text
            AnimatedBuilder(
              animation: _quoteController,
              builder: (context, child) {
                return Opacity(
                  opacity: _quoteOpacity.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _quote,
                      textAlign: TextAlign.center,
                      style: OTextStyle.bodyLarge.copyWith(
                        color: quoteColor,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeIcon(Color color) {
    // Crossfade between moon and sun using the animation progress
    return AnimatedBuilder(
      animation: _iconController,
      builder: (context, child) {
        // Before midpoint show old icon, after midpoint show new icon
        final showNewIcon = _iconRotation.value > 0.4;

        IconData iconData;
        if (widget.toLight) {
          // Transitioning to light: moon → sun
          iconData = showNewIcon ? Icons.wb_sunny_rounded : Icons.nightlight_round;
        } else {
          // Transitioning to dark: sun → moon
          iconData = showNewIcon ? Icons.nightlight_round : Icons.wb_sunny_rounded;
        }

        return Icon(iconData, size: 80, color: color);
      },
    );
  }
}
