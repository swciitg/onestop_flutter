import 'dart:collection';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/pages/contact/contact_detail.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_search_bar.dart';
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
      backgroundColor: OColor.white,
      appBar: AppBar(
        backgroundColor: OColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('Contacts', style: OTextStyle.labelLarge.copyWith(color: OColor.gray800)),
      ),
      body: Provider<ContactStore>(
        create: (context) => ContactStore(),
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.xs),
                child: ContactSearchBar(),
              ),

              // Starred contacts section
              Padding(
                padding: const EdgeInsets.only(left: OSpacing.m, top: OSpacing.xs),
                child: Text(
                  'Starred',
                  style: OTextStyle.labelSmall.copyWith(color: OColor.gray500),
                ),
              ),
              const SizedBox(height: OSpacing.xs),
              FutureBuilder(
                future: context.read<ContactStore>().getAllStarredContacts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ContactDetailsModel> stars = snapshot.data as List<ContactDetailsModel>;
                    context.read<ContactStore>().setStarredContacts(stars);
                    return SizedBox(
                      height: 80,
                      child: Observer(
                        builder: (context) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                            child: Row(children: context.read<ContactStore>().starContactScroll),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox(height: 80);
                },
              ),
              const SizedBox(height: OSpacing.xs),

              // Category cards list
              Expanded(
                child: FutureBuilder<SplayTreeMap<String, ContactModel>>(
                  future: DataService.getContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      SplayTreeMap<String, ContactModel> people = snapshot.data!;
                      List<String> categories = people.keys.toList();
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: OSpacing.m,
                          vertical: OSpacing.xs,
                        ),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(height: OSpacing.xs),
                        itemBuilder: (context, index) {
                          String categoryName = categories[index];
                          ContactModel contactModel = people[categoryName]!;
                          var contactStore = context.read<ContactStore>();
                          return _ContactCategoryCard(
                            categoryName: categoryName,
                            contactModel: contactModel,
                            contactStore: contactStore,
                          );
                        },
                      );
                    }
                    return ListShimmer(height: 60, count: 10);
                  },
                ),
              ),
            ],
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
