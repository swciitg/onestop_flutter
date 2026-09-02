import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/event_scheduler/club_model.dart';
import 'package:onestop_dev/pages/events/widgets/poc_modal.dart';
import 'package:onestop_dev/repository/events_api_repository.dart';
import 'package:onestop_ui/index.dart';

/// Page for the Clubs & Fests section, connected to backend APIs.
class ClubsFestPage extends StatefulWidget {
  const ClubsFestPage({super.key});

  @override
  State<ClubsFestPage> createState() => _ClubsFestPageState();
}

class _ClubsFestPageState extends State<ClubsFestPage> {
  final EventsAPIRepository _apiRepo = EventsAPIRepository();

  final List<String> _categories = [
    'All',
    'Technical',
    'Cultural',
    'Sports',
    'Welfare',
    'SWC',
    'Academic',
  ];

  String _selectedCategory = 'All';
  List<ClubModel> _clubs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClubs();
  }

  Future<void> _fetchClubs() async {
    setState(() {
      _isLoading = true;
    });

    final categoryParam = _selectedCategory == 'All' ? null : _selectedCategory;
    final clubs = await _apiRepo.getAllClubs(category: categoryParam);

    if (mounted) {
      setState(() {
        _clubs = clubs;
        _isLoading = false;
      });
    }
  }

  void _showClubDetailsModal(ClubModel club) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return FutureBuilder<ClubModel?>(
              future: club.id != null ? _apiRepo.getClubDetails(club.id!) : Future.value(club),
              builder: (context, snapshot) {
                final detailedClub = snapshot.data ?? club;
                return Container(
                  decoration: BoxDecoration(
                    color: OColor.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.all(OSpacing.m),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: OColor.gray300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: OSpacing.m),
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: OColor.blue100,
                              shape: BoxShape.circle,
                            ),
                            child: detailedClub.clubLogo != null && detailedClub.clubLogo!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      detailedClub.clubLogo!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Icon(
                                        FluentIcons.people_community_24_regular,
                                        color: OColor.blue600,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    FluentIcons.people_community_24_regular,
                                    color: OColor.blue600,
                                  ),
                          ),
                          const SizedBox(width: OSpacing.m),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OText(
                                  text: detailedClub.clubName,
                                  style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
                                ),
                                if (detailedClub.boardName != null)
                                  OText(
                                    text: detailedClub.boardName!,
                                    style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: OSpacing.l),
                      if (detailedClub.clubDescription != null && detailedClub.clubDescription!.isNotEmpty) ...[
                        OText(
                          text: 'About',
                          style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
                        ),
                        const SizedBox(height: OSpacing.xxs),
                        OText(
                          text: detailedClub.clubDescription!,
                          style: OTextStyle.bodyMedium.copyWith(color: OColor.gray800),
                        ),
                        const SizedBox(height: OSpacing.l),
                      ],
                      if (detailedClub.clubRoomLocation != null && detailedClub.clubRoomLocation!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(FluentIcons.location_16_regular, size: 16, color: OColor.gray600),
                            const SizedBox(width: OSpacing.xs),
                            Expanded(
                              child: OText(
                                text: detailedClub.clubRoomLocation!,
                                style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: OSpacing.l),
                      ],
                      if (detailedClub.team.isNotEmpty) ...[
                        OText(
                          text: 'Team & POCs',
                          style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
                        ),
                        const SizedBox(height: OSpacing.s),
                        ...detailedClub.team.map((member) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: OColor.blue100,
                              child: Icon(FluentIcons.person_24_regular, color: OColor.blue500),
                            ),
                            title: OText(text: member.name ?? 'Member', style: OTextStyle.labelMedium),
                            subtitle: OText(text: member.position ?? 'Position', style: OTextStyle.bodySmall),
                            trailing: member.number != null
                                ? IconButton(
                                    icon: Icon(FluentIcons.call_24_regular, color: OColor.green600),
                                    onPressed: () {
                                      showPOCModal(
                                        context,
                                        name: member.name ?? '',
                                        subtitle: member.position ?? '',
                                        number: member.number,
                                        email: member.email,
                                      );
                                    },
                                  )
                                : null,
                          );
                        }),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.m).copyWith(top: OSpacing.m),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: OColor.green100,
                      borderRadius: BorderRadius.circular(OCornerRadius.m),
                    ),
                    child: Icon(
                      FluentIcons.people_community_24_regular,
                      color: OColor.green600,
                    ),
                  ),
                  const SizedBox(width: OSpacing.m),
                  OText(
                    text: 'Clubs & Fests',
                    style: OTextStyle.headingLarge.copyWith(color: OColor.gray800),
                  ),
                ],
              ),
            ),
            const SizedBox(height: OSpacing.m),

            // Board Categories Bar
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: OSpacing.xs),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                      _fetchClubs();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? OColor.green600 : OColor.white,
                        borderRadius: BorderRadius.circular(OCornerRadius.l),
                        border: Border.all(
                          color: isSelected ? OColor.green600 : OColor.gray300,
                        ),
                      ),
                      child: Center(
                        child: OText(
                          text: cat,
                          style: OTextStyle.labelSmall.copyWith(
                            color: isSelected ? OColor.white : OColor.gray700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: OSpacing.m),

            // Clubs list / grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _clubs.isEmpty
                      ? Center(
                          child: OText(
                            text: 'No clubs found for $_selectedCategory',
                            style: OTextStyle.bodyMedium.copyWith(color: OColor.gray600),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchClubs,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(OSpacing.m),
                            itemCount: _clubs.length,
                            separatorBuilder: (_, _) => const SizedBox(height: OSpacing.s),
                            itemBuilder: (context, index) {
                              final club = _clubs[index];
                              return GestureDetector(
                                onTap: () => _showClubDetailsModal(club),
                                child: Container(
                                  padding: const EdgeInsets.all(OSpacing.m),
                                  decoration: BoxDecoration(
                                    color: OColor.white,
                                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                                    border: Border.all(color: OColor.gray200),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: OColor.green100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: club.clubLogo != null && club.clubLogo!.isNotEmpty
                                            ? ClipOval(
                                                child: Image.network(
                                                  club.clubLogo!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, _, _) => Icon(
                                                    FluentIcons.people_community_24_regular,
                                                    color: OColor.green600,
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                FluentIcons.people_community_24_regular,
                                                color: OColor.green600,
                                              ),
                                      ),
                                      const SizedBox(width: OSpacing.m),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            OText(
                                              text: club.clubName,
                                              style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                                            ),
                                            if (club.boardName != null && club.boardName!.isNotEmpty)
                                              OText(
                                                text: club.boardName!,
                                                style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        FluentIcons.chevron_right_24_regular,
                                        size: 20,
                                        color: OColor.gray400,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
