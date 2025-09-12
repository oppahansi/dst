// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(imageRepository)
const imageRepositoryProvider = ImageRepositoryProvider._();

final class ImageRepositoryProvider
    extends $FunctionalProvider<ImageRepo, ImageRepo, ImageRepo>
    with $Provider<ImageRepo> {
  const ImageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageRepositoryHash();

  @$internal
  @override
  $ProviderElement<ImageRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageRepo create(Ref ref) {
    return imageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageRepo>(value),
    );
  }
}

String _$imageRepositoryHash() => r'8da52d30be5661d20b701fe79743143607422629';

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
