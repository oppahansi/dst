// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
import 'package:sdt/features/images/view/providers/image_provider.dart';
import 'package:sdt/features/images/view/widgets/image_grid.dart';
import 'package:sdt/l10n/app_localizations.dart';

class ImageSearchScreen extends ConsumerStatefulWidget {
  const ImageSearchScreen({super.key});

  @override
  ConsumerState<ImageSearchScreen> createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends ConsumerState<ImageSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    ref.read(imageSearchProvider.notifier).search(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.select_an_image)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: _searchController,
              hintText: loc.search_for_an_image,
              onSubmitted: (_) => _performSearch(),
              trailing: [
                IconButton(
                  icon: const Icon(Symbols.search),
                  onPressed: _performSearch,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ref
                  .watch(imageSearchProvider)
                  .when(
                    data: (result) {
                      if (result.images.isEmpty) {
                        return Center(child: Text(loc.no_images_found));
                      }
                      return Column(
                        children: [
                          Expanded(child: ImageGrid(images: result.images)),
                          if (result.hasMore)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: OutlinedButton.icon(
                                onPressed: () => ref
                                    .read(imageSearchProvider.notifier)
                                    .loadMore(),
                                icon: const Icon(Symbols.downloading),
                                label: Text(loc.load_more),
                              ),
                            ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(loc.failed_to_load_images),
                          Text(
                            error.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
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
