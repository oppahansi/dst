// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdt_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(SdtNotifier)
const sdtNotifierProvider = SdtNotifierProvider._();

final class SdtNotifierProvider
    extends $AsyncNotifierProvider<SdtNotifier, List<SdtEntry>> {
  const SdtNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sdtNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sdtNotifierHash();

  @$internal
  @override
  SdtNotifier create() => SdtNotifier();
}

String _$sdtNotifierHash() => r'b80afd46cdc97cb33cc5356d9e9209717753b9f9';

abstract class _$SdtNotifier extends $AsyncNotifier<List<SdtEntry>> {
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
