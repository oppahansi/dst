// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Project Imports
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/days_since/domain/entities/ds_settings.dart';
import 'package:sdtpro/features/days_since/view/screens/ds_add_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/ds_entry.dart';
import 'package:sdtpro/features/days_since/view/providers/days_since_provider.dart';
import 'package:sdtpro/features/days_since/view/screens/ds_screenshot_screen.dart';
import 'package:sdtpro/features/days_since/view/widgets/ds_card.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class DsDetailScreen extends ConsumerStatefulWidget {
  final DsEntry entry;

  const DsDetailScreen({super.key, required this.entry});

  @override
  ConsumerState<DsDetailScreen> createState() => _DsDetailScreenState();
}

class _DsDetailScreenState extends ConsumerState<DsDetailScreen> {
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
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DsAddScreen(entry: widget.entry)));
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

      if (!context.mounted) return;

      context.pop();
    }
  }

  void _showScreenshotScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DsScreenshotScreen(entry: widget.entry),
      ),
    );
  }

  Future<void> _printEntryDetails(BuildContext context) async {
    if (widget.entry.description == null || widget.entry.description!.isEmpty) {
      context.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.no_description_to_print),
        ),
      );

      return;
    }

    final loc = AppLocalizations.of(context)!;
    final days = DateTime.now().difference(widget.entry.date).inDays;
    final settings = widget.entry.settings ?? DsSettings();

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
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text('$days ${loc.days_since}'),
              if (settings.showSubtitleDate) ...[
                pw.SizedBox(height: 4),
                pw.Text(
                  '${loc.date}: ${DateFormat(settings.subtitleDateFormat, loc.localeName).format(widget.entry.date)}',
                ),
              ],
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Symbols.print),
                  tooltip: loc.print,
                  onPressed: () => _printEntryDetails(context),
                ),
                IconButton(
                  icon: Icon(
                    _isEditingDescription ? Symbols.save : Symbols.edit,
                  ),
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
                    setState(
                      () => _isEditingDescription = !_isEditingDescription,
                    );
                  },
                ),
              ],
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DsCard(entry: widget.entry, isTappable: false),
            _buildDescriptionSection(loc),
          ],
        ),
      ),
    );
  }
}
