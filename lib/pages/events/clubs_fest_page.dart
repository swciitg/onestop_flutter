import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:onestop_dev/models/event_scheduler/club_model.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_dev/pages/events/widgets/event_search_bar.dart';
import 'package:onestop_dev/pages/events/widgets/poc_modal.dart';
import 'package:onestop_dev/pages/events/providers/clubs_provider.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Page for the Clubs & Fests section, connected to backend APIs.
class ClubsFestPage extends StatelessWidget {
  const ClubsFestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClubsProvider()..fetchClubs(),
      child: const _ClubsFestView(),
    );
  }
}

class _ClubsFestView extends StatefulWidget {
  const _ClubsFestView();

  @override
  State<_ClubsFestView> createState() => _ClubsFestViewState();
}

class _ClubsFestViewState extends State<_ClubsFestView> {
  // Reads (non-subscribing); [build] subscribes via `context.watch`.
  ClubsProvider get _p => context.read<ClubsProvider>();

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showClubDetailsModal(ClubModel club) async {
    final provider = _p;
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
              future: provider.getClubDetails(club),
              builder: (context, snapshot) {
                final detailedClub = snapshot.data ?? club;
                return Container(
                  decoration: BoxDecoration(
                    color: OColor.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
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
                            child:
                                detailedClub.clubLogo != null &&
                                        detailedClub.clubLogo!.isNotEmpty
                                    ? ClipOval(
                                      child: Image.network(
                                        detailedClub.clubLogo!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, _, _) => Icon(
                                              FluentIcons
                                                  .people_community_24_regular,
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
                                  style: OTextStyle.labelLarge.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: OColor.gray800,
                                  ),
                                ),
                                if (detailedClub.boardName != null)
                                  OText(
                                    text: detailedClub.boardName!,
                                    style: OTextStyle.bodySmall.copyWith(
                                      color: OColor.gray600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: OSpacing.l),
                      if (detailedClub.clubDescription != null &&
                          detailedClub.clubDescription!.isNotEmpty) ...[
                        OText(
                          text: 'Description',
                          style: OTextStyle.labelSmall.copyWith(
                            color: OColor.gray600,
                          ),
                        ),
                        const SizedBox(height: OSpacing.xxs),
                        OText(
                          text: detailedClub.clubDescription!,
                          style: OTextStyle.bodyMedium.copyWith(
                            color: OColor.gray800,
                          ),
                        ),
                        const SizedBox(height: OSpacing.l),
                      ],
                      if (detailedClub.clubRoomLocation != null &&
                          detailedClub.clubRoomLocation!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              TablerIcons.map_pin,
                              size: 18,
                              color: OColor.gray600,
                            ),
                            const SizedBox(width: OSpacing.xs),
                            Expanded(
                              child: OText(
                                text: detailedClub.clubRoomLocation!,
                                style: OTextStyle.labelSmall.copyWith(
                                  color: OColor.gray600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: OSpacing.l),
                      ],
                      if (detailedClub.team.isNotEmpty) ...[
                        OText(
                          text: 'Team',
                          style: OTextStyle.labelMedium.copyWith(
                            color: OColor.gray600,
                          ),
                        ),
                        const SizedBox(height: OSpacing.s),
                        ...detailedClub.team.map((member) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: OColor.blue100,
                              child: Icon(
                                FluentIcons.person_24_regular,
                                color: OColor.blue500,
                              ),
                            ),
                            title: OText(
                              text: member.name ?? 'Member',
                              style: OTextStyle.labelMedium,
                            ),
                            subtitle: OText(
                              text: member.position ?? 'Position',
                              style: OTextStyle.bodySmall,
                            ),
                            trailing:
                                member.number != null
                                    ? IconButton(
                                      icon: Icon(
                                        FluentIcons.call_24_regular,
                                        color: OColor.green600,
                                      ),
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
    final provider = context.watch<ClubsProvider>();
    final clubs = provider.visibleClubs;
    final categories = provider.categories;
    return Scaffold(
      backgroundColor: OColor.gray100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: OSpacing.m,
              ).copyWith(top: OSpacing.m),
              child: Row(
                children: [
                  Expanded(
                    child: OText(
                      text: 'Clubs/Fests',
                      style: OTextStyle.headingLarge.copyWith(
                        color: OColor.gray800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: OColor.gray300),
                    ),
                    child: Icon(
                      FluentIcons.person_24_regular,
                      size: 24,
                      color: OColor.gray800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: OSpacing.m),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
              child: EventSearchBar(
                placeholder: 'Search Clubs/Fests',
                controller: _searchController,
                onChanged: _p.setSearchQuery,
                onClear: () => _p.setSearchQuery(''),
              ),
            ),
            const SizedBox(height: OSpacing.s),

            // Board Categories Bar
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: OSpacing.xs),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == provider.selectedCategory;
                  return GestureDetector(
                    onTap: () => _p.selectCategory(cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: OSpacing.l,
                        vertical: OSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? OColor.green600 : null,
                        borderRadius: BorderRadius.circular(OCornerRadius.m),
                        border:
                            isSelected
                                ? null
                                : Border.all(color: OColor.gray300),
                      ),
                      child: Center(
                        child: OText(
                          text: cat,
                          style: OTextStyle.labelMedium.copyWith(
                            color: isSelected ? OColor.white : OColor.gray600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: OSpacing.m),

            // Clubs list
            Expanded(
              child:
                  provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : clubs.isEmpty
                      ? Center(
                        child: OText(
                          text: 'No clubs found',
                          style: OTextStyle.bodyMedium.copyWith(
                            color: OColor.gray600,
                          ),
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: provider.fetchClubs,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            OSpacing.m,
                            0,
                            OSpacing.m,
                            120,
                          ),
                          itemCount: clubs.length,
                          separatorBuilder:
                              (_, _) => const SizedBox(height: OSpacing.xs),
                          itemBuilder: (context, index) {
                            final club = clubs[index];
                            return _ClubListTile(
                              club: club,
                              onTap: () => _showClubDetailsModal(club),
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

/// Row card for a club / fest: avatar, name, board and chevron.
class _ClubListTile extends StatelessWidget {
  final ClubModel club;
  final VoidCallback onTap;

  const _ClubListTile({required this.club, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final board = club.boardName ?? '';
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(OSpacing.s),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            EventNetworkImage.avatar(imageUrl: club.clubLogo),
            const SizedBox(width: OSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OText(
                    text: club.clubName,
                    style: OTextStyle.bodyMedium.copyWith(
                      color: OColor.gray800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (board.isNotEmpty) ...[
                    const SizedBox(height: OSpacing.xxs),
                    OText(
                      text: board,
                      style: OTextStyle.bodySmall.copyWith(
                        color: OColor.gray600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              FluentIcons.chevron_right_24_regular,
              size: 24,
              color: OColor.gray800,
            ),
          ],
        ),
      ),
    );
  }
}
