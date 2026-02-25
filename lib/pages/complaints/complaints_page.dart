import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintsPage extends StatelessWidget {
  static const String id = "/all-complaints";

  const ComplaintsPage({super.key});

  // ─── helpers ─────────────────────────────────────────────────────────
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Cannot launch url';
    }
  }

  void _showIntranetDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: OColor.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.m)),
            title: Text(
              'Important',
              style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
            ),
            content: Text(
              'To access this link, you need to be connected to IITG LAN or have VPN configured on your device.',
              style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: Text(
                      'Configure VPN',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.green600),
                    ),
                    onPressed: () {
                      try {
                        _launchURL('https://www.iitg.ac.in/cc/vpn_cnfg');
                      } catch (e) {
                        showSnackBar(e.toString());
                      }
                      Navigator.of(ctx).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Proceed',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.green600),
                    ),
                    onPressed: () {
                      try {
                        _launchURL('https://intranet.iitg.ac.in/ipm/complaint/');
                      } catch (e) {
                        showSnackBar(e.toString());
                      }
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
    );
  }

  void _showComplaintDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: OColor.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.m)),
            title: Text(
              'Important',
              style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
            ),
            content: Text(
              'To proceed, your account must be registered in the Complaint System. '
              "If you haven't registered yet, register yourself first!",
              style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: Text(
                      'Register',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.green600),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showIntranetDialog(context);
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Proceed',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.green600),
                    ),
                    onPressed: () {
                      try {
                        _launchURL('https://www.iitg.ac.in/ipm/complaint/');
                      } catch (e) {
                        showSnackBar(e.toString());
                      }
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        surfaceTintColor: OColor.white,
        elevation: 0,
        iconTheme: IconThemeData(color: OColor.gray800),
        centerTitle: true,
        title: Text(
          'Complaints Portal',
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: OSpacing.l),

              // ── Section: Important Portals ──────────────────────
              Text(
                'Important Portals',
                style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
              ),
              const SizedBox(height: OSpacing.m),

              // Full-width: Complaints Portal (external link)
              _PortalTile(
                title: 'Complaints Portal',
                description:
                    'For complaints related to electricity, carpentry, plumbing, '
                    'sanitary and other civil works in hostels, common areas and department',
                isExternal: true,
                onTap: () => _showComplaintDialog(context),
              ),
              const SizedBox(height: OSpacing.m),

              // Two equal-height half-width tiles
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _PortalTile(
                        title: 'UPSP',
                        description: 'Generic problem for Gymkhana Council',
                        onTap: () => Navigator.pushNamed(context, '/upsp'),
                      ),
                    ),
                    const SizedBox(width: OSpacing.m),
                    Expanded(
                      child: _PortalTile(
                        title: 'Hostel',
                        description: 'Generic problem related to your Hostel',
                        onTap: () => Navigator.pushNamed(context, '/hostelService'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: OSpacing.xl),

              // ── Section: Other Links ────────────────────────────
              Text('Other Links', style: OTextStyle.headingMedium.copyWith(color: OColor.gray800)),
              const SizedBox(height: OSpacing.m),

              // LAN (external link)
              _PortalTile(
                title: 'LAN',
                description: 'Generic problem for Gymkhana Council',
                isExternal: true,
                onTap: () {
                  try {
                    _launchURL('https://www.iitg.ac.in/cb/');
                  } catch (e) {
                    showSnackBar(e.toString());
                  }
                },
              ),

              const SizedBox(height: OSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable portal tile matching Figma Tile #1
// ─────────────────────────────────────────────────────────────────────────────

class _PortalTile extends StatelessWidget {
  final String title;
  final String description;
  final bool isExternal;
  final VoidCallback onTap;

  const _PortalTile({
    required this.title,
    required this.description,
    this.isExternal = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(OSpacing.m),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: OSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
                  const SizedBox(height: OSpacing.xs),
                  Text(
                    description,
                    style: OTextStyle.labelSmall.copyWith(
                      color: OColor.gray600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                isExternal ? Icons.open_in_new_rounded : Icons.chevron_right,
                size: 24,
                color: OColor.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
