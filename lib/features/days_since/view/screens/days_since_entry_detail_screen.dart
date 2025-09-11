// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Project Imports
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/days_since/view/screens/add_stylized_days_since_entry_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/view/providers/days_since_provider.dart';
import 'package:sdtpro/features/days_since/view/widgets/edit_days_since_entry_sheet.dart';
import 'package:sdtpro/features/days_since/view/screens/days_since_screenshot_screen.dart';
import 'package:sdtpro/features/days_since/view/widgets/stylized_days_since_entry_card.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class DaysSinceEntryDetailScreen extends ConsumerStatefulWidget {
  final DaysSinceEntry entry;

  const DaysSinceEntryDetailScreen({super.key, required this.entry});

  @override
  ConsumerState<DaysSinceEntryDetailScreen> createState() =>
      _DaysSinceEntryDetailScreenState();
}

class _DaysSinceEntryDetailScreenState
    extends ConsumerState<DaysSinceEntryDetailScreen> {
  late final TextEditingController _descriptionController;
  bool _isEditingDescription = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.entry.description,
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _showEditor(BuildContext context) {
    if (widget.entry.displayMode == DaysSinceDisplayMode.stylized) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddStylizedDaysSinceEntryScreen(entry: widget.entry),
        ),
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => EditDaysSinceEntrySheet(entry: widget.entry),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final loc = AppLocalizations.of(context)!;
    final didConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.delete_entry_title),
        content: Text(loc.delete_entry_confirmation),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(loc.delete),
          ),
        ],
      ),
    );

    if (didConfirm == true && context.mounted) {
      await ref
          .read(daysSinceNotifierProvider.notifier)
          .deleteEntry(widget.entry.id!);
      context.pop(); // Close the detail screen
    }
  }

  void _showScreenshotScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DaysSinceScreenshotScreen(entry: widget.entry),
      ),
    );
  }

  Future<void> _printEntryDetails(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final days = DateTime.now().difference(widget.entry.date).inDays;

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  widget.entry.title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text('${loc.days_since}: $days'),
              pw.SizedBox(height: 20),
              pw.Text(_descriptionController.text),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  Widget _buildDescriptionSection(AppLocalizations loc) {
    // Only show editable description for stylized entries.
    if (widget.entry.displayMode != DaysSinceDisplayMode.stylized) {
      if (widget.entry.description != null &&
          widget.entry.description!.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              loc.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.entry.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        );
      } else {
        return const SizedBox.shrink(); // No description for simple entry
      }
    }

    // For stylized entries, provide an editable field.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: Icon(_isEditingDescription ? Symbols.save : Symbols.edit),
              tooltip: _isEditingDescription ? loc.save : loc.edit,
              onPressed: () async {
                if (_isEditingDescription) {
                  // Save logic
                  final updatedEntry = widget.entry.copyWith(
                    description: _descriptionController.text,
                  );
                  await ref
                      .read(daysSinceNotifierProvider.notifier)
                      .updateEntry(updatedEntry);
                }
                setState(() {
                  _isEditingDescription = !_isEditingDescription;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isEditingDescription)
          TextFormField(
            controller: _descriptionController,
            autofocus: true,
            maxLines: null, // Allows multiline
            minLines: 5,
            decoration: InputDecoration(hintText: loc.description_optional),
          )
        else
          Text(
            _descriptionController.text.isEmpty
                ? loc.tap_edit_to_add_description
                : _descriptionController.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: _descriptionController.text.isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
              color: _descriptionController.text.isEmpty
                  ? Theme.of(context).textTheme.bodySmall?.color
                  : null,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry.title),
        actions: [
          IconButton(
            icon: const Icon(Symbols.screenshot),
            tooltip: loc.screenshot_view,
            onPressed: () => _showScreenshotScreen(context),
          ),
          IconButton(
            icon: const Icon(Symbols.edit),
            tooltip: loc.edit,
            onPressed: () => _showEditor(context),
          ),
          IconButton(
            icon: const Icon(Symbols.delete),
            tooltip: loc.delete,
            onPressed: () => _confirmDelete(context, ref),
          ),
          if (widget.entry.description != null &&
              widget.entry.description!.isNotEmpty)
            IconButton(
              icon: const Icon(Symbols.print),
              tooltip: loc.print,
              onPressed: () => _printEntryDetails(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We can reuse the stylized card for a nice visual header
            StylizedDaysSinceEntryCard(entry: widget.entry, isTappable: false),
            _buildDescriptionSection(loc),
          ],
        ),
      ),
    );
  }
}
