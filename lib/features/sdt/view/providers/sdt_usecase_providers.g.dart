// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdt_usecase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(sdtRepo)
const sdtRepoProvider = SdtRepoProvider._();

final class SdtRepoProvider
    extends $FunctionalProvider<SdtRepo, SdtRepo, SdtRepo>
    with $Provider<SdtRepo> {
  const SdtRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sdtRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sdtRepoHash();

  @$internal
  @override
  $ProviderElement<SdtRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SdtRepo create(Ref ref) {
    return sdtRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SdtRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SdtRepo>(value),
    );
  }
}

String _$sdtRepoHash() => r'c55590e3bfcc0717ac0dce0fc4c91ca181605e32';

@ProviderFor(getEntries)
const getEntriesProvider = GetEntriesProvider._();

final class GetEntriesProvider
    extends $FunctionalProvider<GetSdtEntries, GetSdtEntries, GetSdtEntries>
    with $Provider<GetSdtEntries> {
  const GetEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getEntriesHash();

  @$internal
  @override
  $ProviderElement<GetSdtEntries> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetSdtEntries create(Ref ref) {
    return getEntries(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSdtEntries value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSdtEntries>(value),
    );
  }
}

String _$getEntriesHash() => r'b9a834d21016888f2f6ef51e0aed9d5099ce6584';

@ProviderFor(addEntry)
const addEntryProvider = AddEntryProvider._();

final class AddEntryProvider
    extends $FunctionalProvider<AddSdtEntry, AddSdtEntry, AddSdtEntry>
    with $Provider<AddSdtEntry> {
  const AddEntryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addEntryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addEntryHash();

  @$internal
  @override
  $ProviderElement<AddSdtEntry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddSdtEntry create(Ref ref) {
    return addEntry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddSdtEntry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddSdtEntry>(value),
    );
  }
}

String _$addEntryHash() => r'196f1a6885c75330aab78b3648be581a53b234b0';

@ProviderFor(updateEntry)
const updateEntryProvider = UpdateEntryProvider._();

final class UpdateEntryProvider
    extends $FunctionalProvider<UpdateSdtEntry, UpdateSdtEntry, UpdateSdtEntry>
    with $Provider<UpdateSdtEntry> {
  const UpdateEntryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateEntryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateEntryHash();

  @$internal
  @override
  $ProviderElement<UpdateSdtEntry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateSdtEntry create(Ref ref) {
    return updateEntry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateSdtEntry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateSdtEntry>(value),
    );
  }
}

String _$updateEntryHash() => r'802f3a589d98b5fc2c21e60daf4b424105e93bcf';

@ProviderFor(deleteEntry)
const deleteEntryProvider = DeleteEntryProvider._();

final class DeleteEntryProvider
    extends $FunctionalProvider<DeleteSdtEntry, DeleteSdtEntry, DeleteSdtEntry>
    with $Provider<DeleteSdtEntry> {
  const DeleteEntryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteEntryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteEntryHash();

  @$internal
  @override
  $ProviderElement<DeleteSdtEntry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteSdtEntry create(Ref ref) {
    return deleteEntry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteSdtEntry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteSdtEntry>(value),
    );
  }
}

String _$deleteEntryHash() => r'357adca3c2f8f296e947eb856eab4b78d05b5cb0';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
