// Flutter Imports
// Dart imports
import 'package:flutter/material.dart';

// Package Imports
// Package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
// Project imports
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/domain/entities/stylized_settings.dart';
import 'package:sdtpro/features/days_since/view/providers/days_since_provider.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class EditSimpleDsSheet extends ConsumerStatefulWidget {
  final DaysSinceEntry entry;
  const EditSimpleDsSheet({super.key, required this.entry});

  @override
  ConsumerState<EditSimpleDsSheet> createState() => _EditSimpleDsSheetState();
}

class _EditSimpleDsSheetState extends ConsumerState<EditSimpleDsSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  DateTime? _selectedDate;
  late bool _showDate;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _titleController = TextEditingController(text: entry.title);
    _descriptionController = TextEditingController(text: entry.description);
    _selectedDate = entry.date;
    _showDate =
        entry.stylizedSettings?.showSubtitleDate ?? true; // Default to true
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
      displayMode: DaysSinceDisplayMode.simple,
      stylizedSettings: (widget.entry.stylizedSettings ?? StylizedSettings())
          .copyWith(showSubtitleDate: _showDate),
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
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(loc.show_date),
                value: _showDate,
                onChanged: (value) {
                  setState(() => _showDate = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: loc.description_optional,
                ),
                minLines: 5,
                maxLines: 999,
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
