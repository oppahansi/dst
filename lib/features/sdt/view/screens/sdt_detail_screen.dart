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
import 'package:sdt/core/utils/extensions.dart';
import 'package:sdt/features/sdt/domain/entities/sdt_settings.dart';
import 'package:sdt/features/sdt/view/screens/sdt_add_screen.dart';
import 'package:sdt/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdt/features/sdt/view/providers/sdt_usecase_providers.dart';
import 'package:sdt/features/sdt/view/providers/sdt_provider.dart';
// for ds/dt invalidation
import 'package:sdt/features/sdt/view/screens/sdt_screenshot_screen.dart';
import 'package:sdt/features/sdt/view/widgets/ds_card.dart';
import 'package:sdt/l10n/app_localizations.dart';
import 'package:sdt/core/utils/date_math.dart';
import 'package:sdt/features/settings/view/providers/settings_provider.dart';

class SdtDetailScreen extends ConsumerStatefulWidget {
  final SdtEntry entry;

  const SdtDetailScreen({super.key, required this.entry});

  @override
  ConsumerState<SdtDetailScreen> createState() => _SdtDetailScreenState();
}

class _SdtDetailScreenState extends ConsumerState<SdtDetailScreen> {
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SdtAddScreen(entry: widget.entry)),
    );
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
      try {
        // Call delete use case directly
        await ref.read(deleteEntryProvider)(widget.entry.id!);

        // Invalidate filtered lists so UI refreshes
        ref.invalidate(dsNotifierProvider);
        ref.invalidate(dtNotifierProvider);

        if (!context.mounted) return;
        context.pop();
      } catch (e) {
        if (!context.mounted) return;
        context.showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _showScreenshotScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SdtScreenshotScreen(entry: widget.entry),
      ),
    );
  }

  Future<void> _printEntryDetails(BuildContext context) async {
    // Use controller text, not the original widget.entry.description
    final text = _descriptionController.text.trim();
    if (text.isEmpty) {
      context.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.no_description_to_print),
        ),
      );
      return;
    }

    final loc = AppLocalizations.of(context)!;
    final app = ref.watch(settingsNotifierProvider);
    final settings = widget.entry.settings ?? SdtSettings();
    final isFuture = SdtDateMath.isFuture(widget.entry.date);
    final days = SdtDateMath.daysBetweenToday(
      widget.entry.date,
      includeToday: app.countToday,
      includeLastDay: app.countLastDay,
    );

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
              pw.Text('$days ${isFuture ? loc.days_to : loc.days_since}'),
              if (settings.showSubtitleDate) ...[
                pw.SizedBox(height: 4),
                pw.Text(
                  '${loc.date}: ${DateFormat(settings.subtitleDateFormat, loc.localeName).format(widget.entry.date)}',
                ),
              ],
              pw.SizedBox(height: 20),
              pw.Text(text),
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
                      final updatedEntry = widget.entry.copyWith(
                        description: _descriptionController.text,
                      );
                      try {
                        // Use case + explicit invalidation
                        await ref.read(updateEntryProvider).call(updatedEntry);
                        ref.invalidate(dsNotifierProvider);
                        ref.invalidate(dtNotifierProvider);
                        if (!mounted) return;
                        FocusScope.of(context).unfocus();
                        setState(() => _isEditingDescription = false);
                        context.showSnackBar(
                          SnackBar(content: Text(loc.saved)),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        context.showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    } else {
                      setState(() => _isEditingDescription = true);
                    }
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
            SdtCard(entry: widget.entry, isTappable: false),
            _buildDescriptionSection(loc),
          ],
        ),
      ),
    );
  }
}
