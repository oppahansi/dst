// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ds_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(dsRepo)
const dsRepoProvider = DsRepoProvider._();

final class DsRepoProvider extends $FunctionalProvider<DsRepo, DsRepo, DsRepo>
    with $Provider<DsRepo> {
  const DsRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dsRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dsRepoHash();

  @$internal
  @override
  $ProviderElement<DsRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DsRepo create(Ref ref) {
    return dsRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DsRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DsRepo>(value),
    );
  }
}

String _$dsRepoHash() => r'8f7cea907c15589f456e3a4cebf230fa26b15bbe';

@ProviderFor(DsNotifier)
const dsNotifierProvider = DsNotifierProvider._();

final class DsNotifierProvider
    extends $AsyncNotifierProvider<DsNotifier, List<DsEntry>> {
  const DsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dsNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dsNotifierHash();

  @$internal
  @override
  DsNotifier create() => DsNotifier();
}

String _$dsNotifierHash() => r'380f18708aabfd07dadb00c66660b4f4207011f3';

abstract class _$DsNotifier extends $AsyncNotifier<List<DsEntry>> {
  FutureOr<List<DsEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<DsEntry>>, List<DsEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DsEntry>>, List<DsEntry>>,
              AsyncValue<List<DsEntry>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
