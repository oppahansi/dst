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

class AddDaysSinceEntrySheet extends ConsumerStatefulWidget {
  const AddDaysSinceEntrySheet({super.key});

  @override
  ConsumerState<AddDaysSinceEntrySheet> createState() =>
      _AddDaysSinceEntrySheetState();
}

class _AddDaysSinceEntrySheetState
    extends ConsumerState<AddDaysSinceEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedImageUrl;
  DaysSinceDisplayMode _displayMode = DaysSinceDisplayMode.simple;

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
    // Manually validate date selection
    setState(() {}); // a rebuild to show the error if date is null
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      return;
    }

    final newEntry = DaysSinceEntry(
      title: _titleController.text,
      date: _selectedDate!,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      imageUrl: _selectedImageUrl,
      displayMode: _displayMode,
    );

    // Call the notifier to add the entry
    await ref.read(daysSinceNotifierProvider.notifier).addEntry(newEntry);

    // Close the bottom sheet if still mounted
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // This padding is to avoid the keyboard when it appears
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
                "${loc.add} ${loc.days_since}",
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
              if (_selectedDate == null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Text(
                    loc.please_select_a_date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
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
              FilledButton(onPressed: _saveEntry, child: Text(loc.save)),
            ],
          ),
        ),
      ),
    );
  }
}
