// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdt_seed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(seedExamplesIfNeeded)
const seedExamplesIfNeededProvider = SeedExamplesIfNeededProvider._();

final class SeedExamplesIfNeededProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const SeedExamplesIfNeededProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seedExamplesIfNeededProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seedExamplesIfNeededHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return seedExamplesIfNeeded(ref);
  }
}

String _$seedExamplesIfNeededHash() =>
    r'ba5bc73742f475f1381a0788141111604796043b';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
