// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/view/widgets/simple_days_since_entry_tile.dart';
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

  @override
  void initState() {
    super.initState();
    // Add listener to rebuild on title change for the live preview.
    _titleController.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _titleController.removeListener(_rebuild);
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
      displayMode: DaysSinceDisplayMode.simple,
    );

    // Call the notifier to add the entry
    await ref.read(daysSinceNotifierProvider.notifier).addEntry(newEntry);

    // Close the bottom sheet if still mounted
    if (mounted) {
      context.pop();
    }
  }

  Widget _buildPreview(AppLocalizations loc) {
    final canPreview =
        _titleController.text.isNotEmpty && _selectedDate != null;

    if (!canPreview) {
      return const SizedBox.shrink();
    }

    final previewEntry = DaysSinceEntry(
      title: _titleController.text,
      date: _selectedDate!,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      displayMode: DaysSinceDisplayMode.simple,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.preview.capitalize(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SimpleDaysSinceEntryTile(entry: previewEntry, isTappable: false),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
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
              _buildPreview(loc),
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
                maxLines: 999,
                minLines: 5,
                decoration: InputDecoration(
                  labelText: loc.description_optional,
                ),
                onChanged: (value) => setState(() {}),
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
