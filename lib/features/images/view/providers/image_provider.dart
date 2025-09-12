// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/images/data/image_repo_impl.dart';
import 'package:sdtpro/features/images/domain/entities/fis_image.dart';
import 'package:sdtpro/features/images/domain/repos/image_repo.dart';

part 'image_provider.g.dart';

@riverpod
ImageRepo imageRepo(Ref ref) {
  return ImageRepoImpl();
}

class ImageSearchState {
  final List<FisImage> images;
  final bool hasMore;
  final String? query;
  final int page;

  const ImageSearchState({
    this.images = const [],
    this.hasMore = true,
    this.query,
    this.page = 1,
  });

  ImageSearchState copyWith({
    List<FisImage>? images,
    bool? hasMore,
    String? query,
    int? page,
  }) {
    return ImageSearchState(
      images: images ?? this.images,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      page: page ?? this.page,
    );
  }
}

@riverpod
class ImageSearch extends _$ImageSearch {
  @override
  Future<ImageSearchState> build() async {
    final result = await ref.watch(imageRepoProvider).getCuratedImages(page: 1);
    return ImageSearchState(
      images: result.images,
      hasMore: result.images.isNotEmpty && result.images.length < result.total,
      query: null,
      page: 1,
    );
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (query.isEmpty) {
        return build(); // Revert to curated
      }
      final result = await ref
          .read(imageRepoProvider)
          .searchImages(query: query, page: 1);
      return ImageSearchState(
        images: result.images,
        hasMore:
            result.images.isNotEmpty && result.images.length < result.total,
        query: query,
        page: 1,
      );
    });
  }

  Future<void> loadMore() async {
    final currentState = state.asData?.value;
    if (state.isLoading || currentState == null || !currentState.hasMore) {
      return;
    }

    final repo = ref.read(imageRepoProvider);
    final nextPage = currentState.page + 1;

    final result = currentState.query == null
        ? await repo.getCuratedImages(page: nextPage)
        : await repo.searchImages(query: currentState.query!, page: nextPage);

    final allImages = [...currentState.images, ...result.images];

    state = AsyncValue.data(
      currentState.copyWith(
        images: allImages,
        page: nextPage,
        hasMore: allImages.length < result.total,
      ),
    );
  }
}
