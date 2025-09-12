// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_provider.dart';

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

@ProviderFor(ImageSearch)
const imageSearchProvider = ImageSearchProvider._();

final class ImageSearchProvider
    extends $AsyncNotifierProvider<ImageSearch, ImageSearchState> {
  const ImageSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageSearchHash();

  @$internal
  @override
  ImageSearch create() => ImageSearch();
}

String _$imageSearchHash() => r'bd4da7ab07efeaac91b2f746b0d5cc3fdb0d2db1';

abstract class _$ImageSearch extends $AsyncNotifier<ImageSearchState> {
  FutureOr<ImageSearchState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<ImageSearchState>, ImageSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ImageSearchState>, ImageSearchState>,
              AsyncValue<ImageSearchState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
