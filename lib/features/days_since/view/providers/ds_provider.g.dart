// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ds_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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

String _$dsNotifierHash() => r'eea1ef1880377bd9807f8395a10e4c09e7667c5e';

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
