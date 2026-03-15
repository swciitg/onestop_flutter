import 'dart:collection';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/pages/contact/contact_detail.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_search_bar.dart';
import 'package:onestop_dev/widgets/contact/starred_contact.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  static const String id = "/contacto";

  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: Theme.of(
          context,
        ).appBarTheme.systemOverlayStyle?.copyWith(statusBarColor: OColor.white),
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('Contacts', style: OTextStyle.labelLarge.copyWith(color: OColor.gray800)),
      ),
      body: Provider<ContactStore>(
        create: (context) {
          final store = ContactStore();
          store.loadStarredContacts();
          return store;
        },
        builder: (context, _) {
          return FutureBuilder<SplayTreeMap<String, ContactModel>>(
            future: DataService.getContacts(),
            builder: (context, snapshot) {
              return CustomScrollView(
                slivers: [
                  // Search bar
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
                      child: ContactSearchBar(),
                    ),
                  ),

                  // Starred header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: OSpacing.m),
                      child: Text(
                        'Starred',
                        style: OTextStyle.labelSmall.copyWith(color: OColor.gray500),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: OSpacing.xs)),

                  // Starred contacts
                  Observer(
                    builder: (context) {
                      final starred = context.read<ContactStore>().starredContacts;
                      if (starred.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(left: OSpacing.m, bottom: OSpacing.xs),
                            child: Text(
                              "You have no starred contacts",
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
                            ),
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => StarContactNameTile(contact: starred[index]),
                          childCount: starred.length,
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: OSpacing.xs)),

                  // Category cards
                  if (snapshot.hasData) ...[
                    Builder(
                      builder: (context) {
                        final categories = snapshot.data!.keys.toList();
                        final contactStore = context.read<ContactStore>();
                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: OSpacing.m,
                            vertical: OSpacing.xs,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              final i = index ~/ 2;
                              if (index.isOdd) return const SizedBox(height: OSpacing.xs);
                              String categoryName = categories[i];
                              ContactModel contactModel = snapshot.data![categoryName]!;
                              return _ContactCategoryCard(
                                categoryName: categoryName,
                                contactModel: contactModel,
                                contactStore: contactStore,
                              );
                            }, childCount: categories.length * 2 - 1),
                          ),
                        );
                      },
                    ),
                  ] else
                    SliverToBoxAdapter(child: ListShimmer(height: 60, count: 10)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// A single category card row: avatar group + name + chevron
class _ContactCategoryCard extends StatelessWidget {
  final String categoryName;
  final ContactModel contactModel;
  final ContactStore contactStore;

  const _ContactCategoryCard({
    required this.categoryName,
    required this.contactModel,
    required this.contactStore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showContactCategorySheet(context, contactModel: contactModel, contactStore: contactStore);
      },
      child: Container(
        padding: const EdgeInsets.all(OSpacing.m),
        decoration: BoxDecoration(
          color: OColor.white,
          border: Border.all(color: OColor.gray200),
          borderRadius: BorderRadius.circular(OCornerRadius.l),
        ),
        child: Row(
          children: [
            _AvatarGroup(count: contactModel.contacts.length),
            const SizedBox(width: OSpacing.m),
            Expanded(
              child: Text(
                categoryName,
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
              ),
            ),
            Icon(FluentIcons.chevron_right_24_regular, size: 24, color: OColor.gray400),
          ],
        ),
      ),
    );
  }
}

/// Overlapping small avatar circles with an optional "+N" count badge
class _AvatarGroup extends StatelessWidget {
  final int count;
  static const int _maxAvatars = 3;
  static const double _avatarSize = 24.0;
  static const double _overlap = 8.0;

  const _AvatarGroup({required this.count});

  static final List<Color> _colors = [
    const Color(0xFFE8F5E9),
    const Color(0xFFE3F2FD),
    const Color(0xFFFFF3E0),
  ];

  @override
  Widget build(BuildContext context) {
    int displayed = count.clamp(0, _maxAvatars);
    int remaining = count - displayed;
    double width = displayed > 0 ? _avatarSize + (displayed - 1) * (_avatarSize - _overlap) : 0;
    if (remaining > 0) width += (_avatarSize - _overlap) + _avatarSize;

    return SizedBox(
      height: _avatarSize,
      width: width,
      child: Stack(
        children: [
          for (int i = 0; i < displayed; i++)
            Positioned(
              left: i * (_avatarSize - _overlap),
              child: Container(
                width: _avatarSize,
                height: _avatarSize,
                decoration: BoxDecoration(
                  color: _colors[i % _colors.length],
                  shape: BoxShape.circle,
                  border: Border.all(color: OColor.white, width: 1.5),
                ),
                child: Icon(FluentIcons.person_12_regular, size: 14, color: OColor.gray500),
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: displayed * (_avatarSize - _overlap),
              child: Container(
                width: _avatarSize,
                height: _avatarSize,
                decoration: BoxDecoration(
                  color: OColor.blue100,
                  shape: BoxShape.circle,
                  border: Border.all(color: OColor.blue300, width: 1),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: OColor.blue300,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
