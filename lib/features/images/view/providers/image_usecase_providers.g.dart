// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_usecase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(imageRepo)
const imageRepoProvider = ImageRepoProvider._();

final class ImageRepoProvider
    extends $FunctionalProvider<ImageRepo, ImageRepo, ImageRepo>
    with $Provider<ImageRepo> {
  const ImageRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageRepoHash();

  @$internal
  @override
  $ProviderElement<ImageRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageRepo create(Ref ref) {
    return imageRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageRepo>(value),
    );
  }
}

String _$imageRepoHash() => r'bc9c6189696734ad155c700159008bec967ed880';

@ProviderFor(getCuratedImages)
const getCuratedImagesProvider = GetCuratedImagesProvider._();

final class GetCuratedImagesProvider
    extends
        $FunctionalProvider<
          GetCuratedImages,
          GetCuratedImages,
          GetCuratedImages
        >
    with $Provider<GetCuratedImages> {
  const GetCuratedImagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCuratedImagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCuratedImagesHash();

  @$internal
  @override
  $ProviderElement<GetCuratedImages> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCuratedImages create(Ref ref) {
    return getCuratedImages(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCuratedImages value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCuratedImages>(value),
    );
  }
}

String _$getCuratedImagesHash() => r'37fc520e702bb0494f6a38f587f936930cedddcf';

@ProviderFor(searchImages)
const searchImagesProvider = SearchImagesProvider._();

final class SearchImagesProvider
    extends $FunctionalProvider<SearchImages, SearchImages, SearchImages>
    with $Provider<SearchImages> {
  const SearchImagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchImagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchImagesHash();

  @$internal
  @override
  $ProviderElement<SearchImages> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SearchImages create(Ref ref) {
    return searchImages(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchImages value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchImages>(value),
    );
  }
}

String _$searchImagesHash() => r'409a062dcfe493f0809a25acd39160feb9934d30';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
