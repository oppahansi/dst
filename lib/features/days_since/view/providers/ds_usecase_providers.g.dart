// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ds_usecase_providers.dart';

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

String _$dsRepoHash() => r'b57507399835884b8e517c55b4058df5f56bc992';

@ProviderFor(getEntries)
const getEntriesProvider = GetEntriesProvider._();

final class GetEntriesProvider
    extends $FunctionalProvider<GetEntries, GetEntries, GetEntries>
    with $Provider<GetEntries> {
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
  $ProviderElement<GetEntries> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetEntries create(Ref ref) {
    return getEntries(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetEntries value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetEntries>(value),
    );
  }
}

String _$getEntriesHash() => r'60d904b10c02f782387864f688f3090f1816e767';

@ProviderFor(addEntry)
const addEntryProvider = AddEntryProvider._();

final class AddEntryProvider
    extends $FunctionalProvider<AddEntry, AddEntry, AddEntry>
    with $Provider<AddEntry> {
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
  $ProviderElement<AddEntry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddEntry create(Ref ref) {
    return addEntry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddEntry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddEntry>(value),
    );
  }
}

String _$addEntryHash() => r'c6c0d97563bebfd1aa7d30d9aff4273025d9bb96';

@ProviderFor(updateEntry)
const updateEntryProvider = UpdateEntryProvider._();

final class UpdateEntryProvider
    extends $FunctionalProvider<UpdateEntry, UpdateEntry, UpdateEntry>
    with $Provider<UpdateEntry> {
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
  $ProviderElement<UpdateEntry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateEntry create(Ref ref) {
    return updateEntry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateEntry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateEntry>(value),
    );
  }
}

String _$updateEntryHash() => r'196d11caea1ef7a469869b23eb192ed022e3d054';

@ProviderFor(deleteEntry)
const deleteEntryProvider = DeleteEntryProvider._();

final class DeleteEntryProvider
    extends $FunctionalProvider<DeleteEntry, DeleteEntry, DeleteEntry>
    with $Provider<DeleteEntry> {
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
  $ProviderElement<DeleteEntry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteEntry create(Ref ref) {
    return deleteEntry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteEntry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteEntry>(value),
    );
  }
}

String _$deleteEntryHash() => r'f8764df5fa5a1577ed0a58fed452cb7edbee0cb8';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
