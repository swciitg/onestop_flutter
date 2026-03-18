import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/my_spaces.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_ui/index.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key, required this.setLoading});

  final Function setLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [OColor.green600, const Color(0xFFDCEFE4)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // App Logo
                  Image.asset(
                    'assets/images/logo_stop.png',
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(height: 24),
                  // Heading
                  Text(
                    'Welcome to the\nall new Onestop',
                    textAlign: TextAlign.center,
                    style: OTextStyle.displayXSmall.copyWith(
                      color: OColor.gray800,
                      fontSize: 45,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Animating Service Icons Marquee (Full Width)
            // const DancingServiceMarquee(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Subtext
                  Text(
                    'All the features you use every day, now thoughtfully redesigned.',
                    textAlign: TextAlign.center,
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.gray800.withOpacity(0.8),
                      letterSpacing: -0.76,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Outlook Login Button
                  GestureDetector(
                    onTap: () => setLoading(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: OColor.green600,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login with Outlook',
                            style: MyFonts.w600.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            FluentIcons.arrow_right_24_regular,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Guest Login Button
                  GestureDetector(
                    onTap: () async {
                      final nav = Navigator.of(context);
                      await LoginStore().signInAsGuest();
                      nav.pushNamedAndRemoveUntil(
                        '/',
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Continue as Guest',
                          style: MyFonts.w600.copyWith(
                            fontSize: 14,
                            color: OColor.gray800,
                          ),
                        ),
                      ),
                    ),
                  ),
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

class DancingServiceMarquee extends StatefulWidget {
  const DancingServiceMarquee({super.key});

  @override
  State<DancingServiceMarquee> createState() => _DancingServiceMarqueeState();
}

class _DancingServiceMarqueeState extends State<DancingServiceMarquee>
    with SingleTickerProviderStateMixin {
  late AnimationController _scrollController;
  final List<String> iconPaths = [
    "assets/images/gate_log.svg",
    "assets/images/irbs.svg",
    "assets/images/cab_sharing.svg",
    "assets/images/complaints.svg",
    "assets/images/lnf.svg",
    "assets/images/bns.svg",
    "assets/images/gc.svg",
    "assets/images/medical.svg",
    "assets/images/timetable.svg",
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 40.0;
    const spacing = 40.0;
    final totalWidth = (iconSize + spacing) * iconPaths.length;

    return SizedBox(
      height: iconSize + 20,
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          final offset = _scrollController.value * totalWidth;
          return Stack(
            children: [
              Positioned(
                left: -offset,
                child: Row(
                  children: [
                    ...iconPaths.map(
                      (path) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: spacing / 2,
                        ),
                        child: _DancingIcon(iconPath: path),
                      ),
                    ),
                    ...iconPaths.map(
                      (path) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: spacing / 2,
                        ),
                        child: _DancingIcon(iconPath: path),
                      ),
                    ),
                    ...iconPaths.map(
                      (path) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: spacing / 2,
                        ),
                        child: _DancingIcon(iconPath: path),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DancingIcon extends StatefulWidget {
  final String iconPath;

  const _DancingIcon({required this.iconPath});

  @override
  State<_DancingIcon> createState() => _DancingIconState();
}

class _DancingIconState extends State<_DancingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _danceController;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
      ), // Slow down the dance slightly
    );

    _rotation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _danceController, curve: Curves.easeInOut),
    );

    _scale = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _danceController, curve: Curves.easeInOut),
    );

    // Stagger start times
    Future.delayed(Duration(milliseconds: widget.hashCode % 1000), () {
      if (mounted) _danceController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _danceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _danceController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Transform.rotate(
            angle: _rotation.value,
            child: SvgPicture.asset(widget.iconPath, height: 30),
          ),
        );
      },
    );
  }
}
