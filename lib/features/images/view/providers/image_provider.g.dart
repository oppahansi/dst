// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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

String _$imageSearchHash() => r'9905143485adc1fcb31a0337c25ecdb1183d811e';

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
