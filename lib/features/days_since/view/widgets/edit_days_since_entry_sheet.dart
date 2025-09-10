// Flutter Imports
// Dart imports
import 'package:flutter/material.dart';

// Package Imports
// Package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
// Project imports
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/images/view/screens/image_search_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/view/providers/days_since_provider.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class EditDaysSinceEntrySheet extends ConsumerStatefulWidget {
  final DaysSinceEntry entry;
  const EditDaysSinceEntrySheet({super.key, required this.entry});

  @override
  ConsumerState<EditDaysSinceEntrySheet> createState() =>
      _EditDaysSinceEntrySheetState();
}

class _EditDaysSinceEntrySheetState
    extends ConsumerState<EditDaysSinceEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  DateTime? _selectedDate;
  String? _selectedImageUrl;
  late DaysSinceDisplayMode _displayMode;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _titleController = TextEditingController(text: entry.title);
    _descriptionController = TextEditingController(text: entry.description);
    _selectedDate = entry.date;
    _selectedImageUrl = entry.imageUrl;
    _displayMode = entry.displayMode;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final imageUrl = await context.push<String>(
      MaterialPageRoute(builder: (context) => const ImageSearchScreen()),
    );

    if (imageUrl != null) {
      setState(() => _selectedImageUrl = imageUrl);
    }
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      return;
    }

    final updatedEntry = widget.entry.copyWith(
      title: _titleController.text,
      date: _selectedDate!,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      imageUrl: _selectedImageUrl,
      displayMode: _displayMode,
    );

    await ref
        .read(daysSinceNotifierProvider.notifier)
        .updateEntry(updatedEntry);

    if (mounted) {
      context.pop(); // Close the edit sheet
      context.pop(); // Close the detail screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "${loc.edit} ${loc.days_since}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: loc.title),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.please_enter_a_title;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Symbols.calendar_today),
                title: Text(loc.date),
                subtitle: Text(
                  _selectedDate == null
                      ? loc.select_a_date
                      : DateFormat.yMMMd().format(_selectedDate!),
                ),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: loc.description_optional,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Symbols.image),
                title: Text(loc.image_optional),
                subtitle: _selectedImageUrl == null
                    ? Text(loc.tap_to_select_an_image)
                    : Text(loc.tap_to_change_the_image),
                trailing: _selectedImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: _selectedImageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
                onTap: _pickImage,
              ),
              if (_selectedImageUrl != null)
                TextButton.icon(
                  icon: const Icon(Symbols.delete, size: 16),
                  label: Text(loc.remove_image),
                  onPressed: () => setState(() => _selectedImageUrl = null),
                ),
              const SizedBox(height: 24),
              SegmentedButton<DaysSinceDisplayMode>(
                segments: [
                  ButtonSegment(
                    value: DaysSinceDisplayMode.simple,
                    icon: Icon(Symbols.list),
                    label: Text(loc.simple),
                  ),
                  ButtonSegment(
                    value: DaysSinceDisplayMode.stylized,
                    icon: Icon(Symbols.gallery_thumbnail),
                    label: Text(loc.stylized),
                  ),
                ],
                selected: {_displayMode},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _displayMode = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saveEntry,
                child: Text(loc.save_changes),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
