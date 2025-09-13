// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdt_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(DsNotifier)
const dsNotifierProvider = DsNotifierProvider._();

final class DsNotifierProvider
    extends $AsyncNotifierProvider<DsNotifier, List<SdtEntry>> {
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

String _$dsNotifierHash() => r'9687bb301f9efeab0dc43c017239d0d1b7a4157e';

abstract class _$DsNotifier extends $AsyncNotifier<List<SdtEntry>> {
  FutureOr<List<SdtEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<SdtEntry>>, List<SdtEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SdtEntry>>, List<SdtEntry>>,
              AsyncValue<List<SdtEntry>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DtNotifier)
const dtNotifierProvider = DtNotifierProvider._();

final class DtNotifierProvider
    extends $AsyncNotifierProvider<DtNotifier, List<SdtEntry>> {
  const DtNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dtNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dtNotifierHash();

  @$internal
  @override
  DtNotifier create() => DtNotifier();
}

String _$dtNotifierHash() => r'c7308e81ae576ca6e2864982ae9ba43e29b254ec';

abstract class _$DtNotifier extends $AsyncNotifier<List<SdtEntry>> {
  FutureOr<List<SdtEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<SdtEntry>>, List<SdtEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SdtEntry>>, List<SdtEntry>>,
              AsyncValue<List<SdtEntry>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
