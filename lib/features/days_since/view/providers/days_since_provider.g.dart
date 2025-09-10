// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'days_since_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(daysSinceRepository)
const daysSinceRepositoryProvider = DaysSinceRepositoryProvider._();

final class DaysSinceRepositoryProvider
    extends
        $FunctionalProvider<
          DaysSinceRepository,
          DaysSinceRepository,
          DaysSinceRepository
        >
    with $Provider<DaysSinceRepository> {
  const DaysSinceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'daysSinceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$daysSinceRepositoryHash();

  @$internal
  @override
  $ProviderElement<DaysSinceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DaysSinceRepository create(Ref ref) {
    return daysSinceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DaysSinceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DaysSinceRepository>(value),
    );
  }
}

String _$daysSinceRepositoryHash() =>
    r'4112e105e79a834a3d6788d7665f28732f949e43';

@ProviderFor(DaysSinceNotifier)
const daysSinceNotifierProvider = DaysSinceNotifierProvider._();

final class DaysSinceNotifierProvider
    extends $AsyncNotifierProvider<DaysSinceNotifier, List<DaysSinceEntry>> {
  const DaysSinceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'daysSinceNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$daysSinceNotifierHash();

  @$internal
  @override
  DaysSinceNotifier create() => DaysSinceNotifier();
}

String _$daysSinceNotifierHash() => r'c160f93bde7a6e8c4d36ba2f5c2195ecd5e56de0';

abstract class _$DaysSinceNotifier
    extends $AsyncNotifier<List<DaysSinceEntry>> {
  FutureOr<List<DaysSinceEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<DaysSinceEntry>>, List<DaysSinceEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<DaysSinceEntry>>,
                List<DaysSinceEntry>
              >,
              AsyncValue<List<DaysSinceEntry>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
