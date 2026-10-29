import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/providers/events_admin_provider.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import '../widgets/progress_bar.dart' as pb;
import '../widgets/date_picker_sheet.dart';
import '../widgets/domain_picker_sheet.dart';
import '../widgets/time_picker_sheet.dart';

/// Multi-step page for creating or editing an event.
///
/// When [event] is null, the page is in "Create" mode.
/// When [event] is provided, the page is in "Edit" mode.
///
/// Steps: 1. Banner, 2. Details, 3. Extra info.
class CreateEditEventPage extends StatefulWidget {
  static const id = "/events/create-edit";

  final EventModel? event;

  const CreateEditEventPage({super.key, this.event});

  @override
  State<CreateEditEventPage> createState() => _CreateEditEventPageState();
}

class _CreateEditEventPageState extends State<CreateEditEventPage> {
  static const int _maxBannerBytes = 2621440; // 2.5 MB
  static const _stepNames = ['BANNER', 'DETAILS', 'EXTRA INFO'];
  static const _domainOptions = [
    'Technical',
    'Cultural',
    'Sports',
    'Literary',
    'Social',
    'Academic',
  ];
  static const _eventTypes = [
    'Workshop',
    'Competition',
    'Talk',
    'Fest',
    'Meetup',
    'Other',
  ];

  final _picker = ImagePicker();
  final _dateFormat = DateFormat('dd MMM yyyy');

  int _step = 0;
  bool _isSubmitting = false;

  // Step 1
  File? _bannerFile;
  String? _bannerUrl;

  // Step 2
  final _nameController = TextEditingController();
  final _venueController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay? _startTime;
  DateTime? _date;
  List<String> _domains = [];
  final List<String> _otherTags = []; // tags that are neither domain nor type
  String? _type;
  final List<EventPOC> _pocs = [];

  // Step 3
  int _durationHours = 1; // 0 means custom
  TimeOfDay? _customEndTime;
  final _whoShouldJoinController = TextEditingController();
  final List<EventGuest> _guests = [];
  bool _hasLink = false;
  final _linkLabelController = TextEditingController();
  final _linkController = TextEditingController();

  bool get _isEditing => widget.event != null;

  bool get _hasBanner => _bannerFile != null || _bannerUrl != null;

  bool get _detailsValid =>
      _nameController.text.trim().isNotEmpty &&
      _venueController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty &&
      _startTime != null &&
      _date != null &&
      _domains.isNotEmpty &&
      _type != null &&
      _pocs.isNotEmpty;

  bool get _canProceed => switch (_step) {
    0 => _hasBanner,
    1 => _detailsValid,
    _ => true,
  };

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    if (e != null) {
      _bannerUrl = e.eventBanner;
      _nameController.text = e.name;
      _venueController.text = e.location ?? '';
      _descriptionController.text = e.description ?? '';
      _startTime = TimeOfDay.fromDateTime(e.startTime);
      _date = e.date;
      // Backend stores domains and the event type in one flat tag list.
      for (final tag in e.tags) {
        if (_eventTypes.contains(tag)) {
          _type ??= tag;
        } else if (_domainOptions.contains(tag)) {
          _domains.add(tag);
        } else {
          _otherTags.add(tag);
        }
      }
      _pocs.addAll(e.poc);
      _whoShouldJoinController.text = e.whoShouldAttend ?? '';
      _guests.addAll(e.guest);
      if (e.additionalLinks.isNotEmpty) {
        _hasLink = true;
        _linkController.text = e.additionalLinks.first;
      }
      final minutes = e.endTime.difference(e.startTime).inMinutes;
      if (minutes == 60 || minutes == 120 || minutes == 180) {
        _durationHours = minutes ~/ 60;
      } else {
        _durationHours = 0;
        _customEndTime = TimeOfDay.fromDateTime(e.endTime);
      }
    }
    for (final c in [
      _nameController,
      _venueController,
      _descriptionController,
    ]) {
      c.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _venueController.dispose();
    _descriptionController.dispose();
    _whoShouldJoinController.dispose();
    _linkLabelController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _toast(String msg) =>
      Fluttertoast.showToast(msg: msg, backgroundColor: OColor.gray800);

  Future<void> _pickBanner() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final file = File(picked.path);
    if (await file.length() > _maxBannerBytes) {
      _toast("Can't select an image larger than 2.5 MB");
      return;
    }
    setState(() {
      _bannerFile = file;
      _bannerUrl = null;
    });
  }

  Future<void> _pickStartTime() async {
    final t = await showTimePickerSheet(
      context,
      title: 'Start Time',
      initialTime: _startTime,
    );
    if (t != null) setState(() => _startTime = t);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePickerSheet(
      context,
      title: 'Event Date',
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickCustomEnd() async {
    final t = await showTimePickerSheet(
      context,
      title: 'End Time',
      initialTime: _customEndTime ?? _startTime,
    );
    if (t != null) setState(() => _customEndTime = t);
  }

  /// Bottom sheet collecting a name, a role and optional extra fields.
  Future<List<String>?> _showPersonSheet({
    required String title,
    required String positionHint,
    bool askContact = false,
  }) {
    final name = TextEditingController();
    final position = TextEditingController();
    final number = TextEditingController();
    final email = TextEditingController();
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: OColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.fromLTRB(
              OSpacing.m,
              OSpacing.m,
              OSpacing.m,
              MediaQuery.of(ctx).viewInsets.bottom + OSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OText(
                  text: title,
                  style: OTextStyle.headingSmall.copyWith(
                    color: OColor.gray800,
                  ),
                ),
                const SizedBox(height: OSpacing.m),
                _TextBox(
                  label: 'Name',
                  hint: 'e.g. Elon Musk',
                  controller: name,
                ),
                const SizedBox(height: OSpacing.m),
                _TextBox(
                  label: 'Position',
                  hint: positionHint,
                  controller: position,
                ),
                if (askContact) ...[
                  const SizedBox(height: OSpacing.m),
                  _TextBox(
                    label: 'Phone Number',
                    hint: 'e.g. 9876543210',
                    controller: number,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: OSpacing.m),
                  _TextBox(
                    label: 'Email',
                    hint: 'e.g. name@iitg.ac.in',
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
                const SizedBox(height: OSpacing.l),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Add',
                    onPressed: () {
                      if (name.text.trim().isEmpty ||
                          position.text.trim().isEmpty) {
                        _toast('Name and position are required');
                        return;
                      }
                      Navigator.pop(ctx, [
                        name.text.trim(),
                        position.text.trim(),
                        number.text.trim(),
                        email.text.trim(),
                      ]);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _addPoc() async {
    final r = await _showPersonSheet(
      title: 'Add POC',
      positionHint: 'e.g. Coordinator',
      askContact: true,
    );
    if (r == null) return;
    setState(
      () => _pocs.add(
        EventPOC(
          name: r[0],
          position: r[1],
          number: r[2].isEmpty ? null : r[2],
          email: r[3].isEmpty ? null : r[3],
        ),
      ),
    );
  }

  Future<void> _addGuest() async {
    final r = await _showPersonSheet(
      title: 'Add Guest',
      positionHint: 'e.g. CEO of SpaceX',
    );
    if (r == null) return;
    setState(() => _guests.add(EventGuest(name: r[0], position: r[1])));
  }

  void _next() {
    if (!_canProceed) return;
    setState(() => _step++);
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.of(context).pop();
    }
  }

  DateTime _combine(DateTime day, TimeOfDay t) =>
      DateTime(day.year, day.month, day.day, t.hour, t.minute);

  Map<String, dynamic> _buildPayload() {
    final day = _date ?? DateTime.now();
    final start = _combine(day, _startTime ?? TimeOfDay.fromDateTime(day));
    var end = start.add(
      Duration(hours: _durationHours == 0 ? 1 : _durationHours),
    );
    if (_durationHours == 0 && _customEndTime != null) {
      end = _combine(day, _customEndTime!);
      if (!end.isAfter(start)) end = end.add(const Duration(days: 1));
    }
    final link = _linkController.text.trim();

    return {
      'name': _nameController.text.trim(),
      'date': DateTime.utc(day.year, day.month, day.day).toIso8601String(),
      'startTime': start.toUtc().toIso8601String(),
      'endTime': end.toUtc().toIso8601String(),
      'location': _venueController.text.trim(),
      'tags': [..._domains, if (_type != null) _type!, ..._otherTags],
      'description': _descriptionController.text.trim(),
      'whoShouldAttend': _whoShouldJoinController.text.trim(),
      'poc': [
        for (final p in _pocs)
          {
            'name': p.name,
            'phone': p.number,
            if (p.email != null) 'email': p.email,
            if (p.position != null) 'designation': p.position,
          },
      ],
      'guests': [
        for (final g in _guests) {'name': g.name, 'designation': g.position},
      ],
      'additionalLinks': [if (_hasLink && link.isNotEmpty) link],
    };
  }

  Future<void> _submit({required bool asDraft}) async {
    if (_isSubmitting) return;
    if (asDraft && _nameController.text.trim().isEmpty) {
      _toast('Enter an event name to save a draft');
      return;
    }
    if (!asDraft) {
      if (!_detailsValid || !_hasBanner) {
        _toast('Please fill all the details first');
        return;
      }
      if (_hasLink && _linkController.text.trim().isEmpty) {
        _toast('Please enter the link');
        return;
      }
    }

    setState(() => _isSubmitting = true);
    final ok = await context.read<EventsAdminProvider>().submitEvent(
      data: _buildPayload(),
      asDraft: asDraft,
      eventId: widget.event?.id,
      bannerFile: _bannerFile,
      existingBannerUrl: _bannerUrl,
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (ok) {
      _toast(asDraft ? 'Draft saved' : 'Event posted');
      Navigator.of(context).pop();
    } else {
      _toast('Something went wrong. Please try again');
    }
  }

  void _saveDraft() => _submit(asDraft: true);

  void _post() => _submit(asDraft: false);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: OColor.gray100,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(OSpacing.m),
                child: switch (_step) {
                  0 => _buildBannerStep(),
                  1 => _buildDetailsStep(),
                  _ => _buildExtraStep(),
                },
              ),
            ),
            _buildStickyBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: OColor.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _back,
                    icon: Icon(
                      FluentIcons.arrow_left_24_regular,
                      color: OColor.green600,
                    ),
                  ),
                  Expanded(
                    child: OText(
                      text: _isEditing ? 'Edit Event' : 'Add Event',
                      textAlign: TextAlign.center,
                      style: OTextStyle.labelLarge.copyWith(
                        color: OColor.gray800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            pb.StepProgressIndicator(
              numberOfSteps: _stepNames.length,
              currentStep: _step + 1,
              stepNames: _stepNames,
            ),
            SizedBox(height: 10),
            Divider(height: 1, color: OColor.gray200),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyBar() {
    final isLast = _step == _stepNames.length - 1;
    final secondaryLabel = _step == 0 ? 'Cancel' : 'Save Draft';
    final secondaryIcon =
        _step == 0
            ? FluentIcons.dismiss_24_regular
            : FluentIcons.document_24_regular;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        OSpacing.m,
        OSpacing.m,
        OSpacing.m,
        OSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: secondaryLabel,
              leadingIcon: secondaryIcon,
              onPressed:
                  _step == 0 ? () => Navigator.of(context).pop() : _saveDraft,
            ),
          ),
          const SizedBox(width: OSpacing.xs),
          Expanded(
            child: GestureDetector(
              onTap: isLast ? _post : (_canProceed ? _next : null),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color:
                      _canProceed ? OColor.green600 : const Color(0xFFC9E3D4),
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLast) ...[
                      const Icon(
                        FluentIcons.checkmark_24_regular,
                        color: Colors.white,
                      ),
                      const SizedBox(width: OSpacing.xxs),
                    ],
                    OText(
                      text: isLast ? 'Post' : 'Next',
                      style: OTextStyle.labelMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    if (!isLast) ...[
                      const SizedBox(width: OSpacing.xxs),
                      const Icon(
                        FluentIcons.arrow_right_24_regular,
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- Step 1

  Widget _buildBannerStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Upload photo of the event banner',
          subtitle: 'Dimensions for the banner are 1280px by 720px.',
          bodyColor: true,
        ),
        const SizedBox(height: OSpacing.l),
        if (_hasBanner) ...[
          Container(
            padding: const EdgeInsets.all(OSpacing.xs),
            decoration: BoxDecoration(
              color: OColor.blue100,
              borderRadius: BorderRadius.circular(OCornerRadius.s),
            ),
            child: Row(
              children: [
                Icon(TablerIcons.info_small, size: 32, color: OColor.gray800),
                const SizedBox(width: OSpacing.xs),
                Expanded(
                  child: OText(
                    text:
                        'USE TWO FINGERS TO ADJUST THE IMAGE SIZE AND POSITION',
                    style: OTextStyle.labelXSmall.copyWith(
                      color: OColor.gray800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: OSpacing.m),
          _BannerPreview(file: _bannerFile, url: _bannerUrl),
          const SizedBox(height: OSpacing.xl),
        ],
        SecondaryButton(
          label: _hasBanner ? 'Replace Image' : 'Add Photo',
          leadingIcon:
              _hasBanner
                  ? FluentIcons.arrow_swap_16_regular
                  : FluentIcons.add_16_regular,
          padding: const EdgeInsets.symmetric(
            horizontal: OSpacing.l,
            vertical: OSpacing.xs,
          ),
          labelStyle: OTextStyle.labelSmall.copyWith(color: OColor.green600),
          width: double.infinity,
          onPressed: _pickBanner,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------- Step 2

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Enter Details',
          subtitle:
              'Every field is mandatory, make sure to double check you entries.',
        ),
        const SizedBox(height: OSpacing.xl),
        _TextBox(
          label: 'Event Name',
          hint: 'Club Orientaion, Flutter Workshop, etc',
          controller: _nameController,
        ),
        const SizedBox(height: OSpacing.l),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PickerTile(
                label: 'Start Time',
                value: _startTime?.format(context) ?? 'Select',
                onTap: _pickStartTime,
              ),
            ),
            const SizedBox(width: OSpacing.m),
            Expanded(
              child: _PickerTile(
                label: 'Event Date',
                value: _date == null ? 'Select' : _dateFormat.format(_date!),
                onTap: _pickDate,
              ),
            ),
          ],
        ),
        const SizedBox(height: OSpacing.l),
        _TextBox(
          label: 'Event Venue',
          hint: 'e.g. Main Auditorium, Lecture Hall, Online',
          controller: _venueController,
        ),
        const SizedBox(height: OSpacing.l),
        _PickerTile(
          label: 'Select Domain',
          value: _domains.isEmpty ? 'Domain' : _domains.join(', '),
          onTap:
              () => showDomainPickerSheet(
                context,
                title: 'Select Domain',
                options: _domainOptions,
                selected: _domains,
                onChanged: (v) => setState(() => _domains = v),
              ),
        ),
        const SizedBox(height: OSpacing.l),
        _PickerTile(
          label: 'Select Event Type',
          value: _type ?? 'Type',
          onTap:
              () => showDomainPickerSheet(
                context,
                title: 'Select Event Type',
                icon: FluentIcons.tag_32_regular,
                multiSelect: false,
                options: _eventTypes,
                selected: [if (_type != null) _type!],
                onChanged: (v) => setState(() => _type = v.first),
              ),
        ),
        const SizedBox(height: OSpacing.l),
        _TextBox(
          label: 'Event Description',
          hint: 'Core 1, Library entrance, etc',
          controller: _descriptionController,
          minLines: 4,
          maxLines: 4,
        ),
        const SizedBox(height: OSpacing.l),
        const _SectionTitle(
          title: 'POC',
          subtitle:
              'These POC can be contacted by people for any queries or doubts about the event.',
          titleStyleMedium: true,
        ),
        const SizedBox(height: OSpacing.xs),
        for (final p in _pocs)
          Padding(
            padding: const EdgeInsets.only(bottom: OSpacing.m),
            child: _PersonTile(
              name: p.name ?? '',
              subtitle: p.position ?? '',
              onRemove: () => setState(() => _pocs.remove(p)),
            ),
          ),
        SecondaryButton(
          label: 'Add POC',
          leadingIcon: FluentIcons.add_16_regular,
          padding: const EdgeInsets.symmetric(
            horizontal: OSpacing.l,
            vertical: OSpacing.xs,
          ),
          labelStyle: OTextStyle.labelSmall.copyWith(color: OColor.green600),
          width: double.infinity,
          onPressed: _addPoc,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------- Step 3

  Widget _buildExtraStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Optional Details',
          subtitle:
              'Include more details to make your event post more informative and appealing.',
        ),
        const SizedBox(height: OSpacing.xl),
        OText(
          text: 'Event Duration',
          style: OTextStyle.labelMedium.copyWith(color: OColor.black),
        ),
        const SizedBox(height: OSpacing.xs),
        Row(
          children: [
            for (final h in [1, 2, 3])
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: OSpacing.xs),
                  child: _DurationChip(
                    label: '$h ${h == 1 ? 'Hr' : 'Hrs'}',
                    selected: _durationHours == h,
                    onTap: () => setState(() => _durationHours = h),
                  ),
                ),
              ),
            Expanded(
              child: _DurationChip(
                label:
                    _durationHours == 0 && _customEndTime != null
                        ? _customEndTime!.format(context)
                        : 'Custom',
                selected: _durationHours == 0,
                onTap: () async {
                  setState(() => _durationHours = 0);
                  await _pickCustomEnd();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: OSpacing.l),
        _TextBox(
          label: 'Who should Join',
          hint:
              'e.g. Ideal for students interested in robotics. learn the basics and get hands-on experience.',
          controller: _whoShouldJoinController,
          minLines: 4,
          maxLines: 4,
        ),
        const SizedBox(height: OSpacing.l),
        const _SectionTitle(
          title: 'Special Guests',
          subtitle:
              'Add info about the special guests, speakers, judges invited in your event.',
          titleStyleMedium: true,
        ),
        const SizedBox(height: OSpacing.xs),
        for (final g in _guests)
          Padding(
            padding: const EdgeInsets.only(bottom: OSpacing.m),
            child: _PersonTile(
              name: g.name ?? '',
              subtitle: g.position ?? '',
              onRemove: () => setState(() => _guests.remove(g)),
            ),
          ),
        SecondaryButton(
          label: 'Add Guest',
          leadingIcon: FluentIcons.add_16_regular,
          padding: const EdgeInsets.symmetric(
            horizontal: OSpacing.l,
            vertical: OSpacing.xs,
          ),
          labelStyle: OTextStyle.labelSmall.copyWith(color: OColor.green600),
          width: double.infinity,
          onPressed: _addGuest,
        ),
        const SizedBox(height: OSpacing.xl),
        Container(
          padding: const EdgeInsets.all(OSpacing.s),
          decoration: BoxDecoration(
            color: OColor.white,
            borderRadius: BorderRadius.circular(OCornerRadius.l),
            border: Border.all(color: OColor.gray200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OText(
                      text: 'Additional Link',
                      style: OTextStyle.labelMedium.copyWith(
                        color: OColor.gray800,
                      ),
                    ),
                    const SizedBox(height: OSpacing.xxs),
                    OText(
                      text:
                          'This link with be the main CTA button in the Event Page.',
                      style: OTextStyle.bodySmall.copyWith(
                        color: OColor.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: OSpacing.s),
              Switch(
                value: _hasLink,
                activeThumbColor: Colors.white,
                activeTrackColor: OColor.green600,
                onChanged: (v) => setState(() => _hasLink = v),
              ),
            ],
          ),
        ),
        if (_hasLink) ...[
          const SizedBox(height: OSpacing.l),
          _TextBox(
            label: 'Label on Button',
            hint: 'e.g. Registration Link, Website, Unstop',
            controller: _linkLabelController,
          ),
          const SizedBox(height: OSpacing.l),
          _TextBox(
            label: 'Link',
            hint: 'https://youtube.com',
            controller: _linkController,
            keyboardType: TextInputType.url,
          ),
        ],
        const SizedBox(height: OSpacing.l),
      ],
    );
  }
}

// ------------------------------------------------------------------ widgets

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool bodyColor;
  final bool titleStyleMedium;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    this.bodyColor = false,
    this.titleStyleMedium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: title,
          style: (titleStyleMedium
                  ? OTextStyle.labelMedium
                  : OTextStyle.headingSmall)
              .copyWith(color: bodyColor ? OColor.gray800 : OColor.black),
        ),
        SizedBox(height: bodyColor ? OSpacing.xxs : OSpacing.xs),
        OText(
          text: subtitle,
          style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
        ),
      ],
    );
  }
}

class _TextBox extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;

  const _TextBox({
    required this.label,
    required this.hint,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: label,
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
        ),
        const SizedBox(height: OSpacing.xs),
        TextField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType:
              keyboardType ??
              (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
          style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: OColor.white,
            hintText: hint,
            hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
            contentPadding: const EdgeInsets.all(OSpacing.s),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(OCornerRadius.m),
              borderSide: BorderSide(color: OColor.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(OCornerRadius.m),
              borderSide: BorderSide(color: OColor.green600, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _PickerTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: label,
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
        ),
        const SizedBox(height: OSpacing.xs),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(OSpacing.m),
            decoration: BoxDecoration(
              color: OColor.white,
              borderRadius: BorderRadius.circular(OCornerRadius.l),
              border: Border.all(color: OColor.gray200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OText(
                    text: value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.green600,
                    ),
                  ),
                ),
                Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: OColor.green600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DurationChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DurationChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? OColor.green600 : Colors.transparent,
          borderRadius: BorderRadius.circular(OCornerRadius.l),
          border: selected ? null : Border.all(color: OColor.gray300),
        ),
        child: OText(
          text: label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: OTextStyle.labelSmall.copyWith(
            color: selected ? Colors.white : OColor.gray600,
          ),
        ),
      ),
    );
  }
}

class _PersonTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onRemove;

  const _PersonTile({
    required this.name,
    required this.subtitle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OSpacing.s),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.l),
        border: Border.all(color: OColor.gray200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: OColor.green100,
            child: OText(
              text: name.isEmpty ? '?' : name[0].toUpperCase(),
              style: OTextStyle.labelMedium.copyWith(color: OColor.green600),
            ),
          ),
          const SizedBox(width: OSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OText(
                  text: name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                ),
                OText(
                  text: subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray600),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(FluentIcons.dismiss_24_regular, color: OColor.gray800),
          ),
        ],
      ),
    );
  }
}

/// 16:9 banner preview that can be panned and pinch-zoomed, with a
/// rule-of-thirds grid on top.
class _BannerPreview extends StatelessWidget {
  final File? file;
  final String? url;

  const _BannerPreview({this.file, this.url});

  @override
  Widget build(BuildContext context) {
    final image =
        file != null
            ? Image.file(file!, fit: BoxFit.cover)
            : Image.network(url!, fit: BoxFit.cover);

    return AspectRatio(
      aspectRatio: 358 / 201,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(OCornerRadius.s),
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(minScale: 1, maxScale: 4, child: image),
            IgnorePointer(child: CustomPaint(painter: _GridPainter())),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..strokeWidth = 1;
    for (var i = 1; i < 3; i++) {
      final dx = size.width * i / 3;
      final dy = size.height * i / 3;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
