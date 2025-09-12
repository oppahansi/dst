// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_usecase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provides the concrete implementation of the SettingsRepository.
/// In a real app, you might switch this out for a mock repository during tests.
@ProviderFor(settingsRepo)
const settingsRepoProvider = SettingsRepoProvider._();

/// Provides the concrete implementation of the SettingsRepository.
/// In a real app, you might switch this out for a mock repository during tests.
final class SettingsRepoProvider
    extends $FunctionalProvider<SettingsRepo, SettingsRepo, SettingsRepo>
    with $Provider<SettingsRepo> {
  /// Provides the concrete implementation of the SettingsRepository.
  /// In a real app, you might switch this out for a mock repository during tests.
  const SettingsRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepoHash();

  @$internal
  @override
  $ProviderElement<SettingsRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsRepo create(Ref ref) {
    return settingsRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepo>(value),
    );
  }
}

String _$settingsRepoHash() => r'a5f2076161640bf5f6ee3d4d2ef4288c534990d1';

/// Provides the GetSettings use case, injecting the repository.
@ProviderFor(getSettings)
const getSettingsProvider = GetSettingsProvider._();

/// Provides the GetSettings use case, injecting the repository.
final class GetSettingsProvider
    extends $FunctionalProvider<GetSettings, GetSettings, GetSettings>
    with $Provider<GetSettings> {
  /// Provides the GetSettings use case, injecting the repository.
  const GetSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSettingsHash();

  @$internal
  @override
  $ProviderElement<GetSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetSettings create(Ref ref) {
    return getSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSettings>(value),
    );
  }
}

String _$getSettingsHash() => r'89feb5126bd8e1c85e9af1f5e76e8efbf881c760';

/// Provides the UpdateTheme use case.
@ProviderFor(updateTheme)
const updateThemeProvider = UpdateThemeProvider._();

/// Provides the UpdateTheme use case.
final class UpdateThemeProvider
    extends $FunctionalProvider<UpdateTheme, UpdateTheme, UpdateTheme>
    with $Provider<UpdateTheme> {
  /// Provides the UpdateTheme use case.
  const UpdateThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateThemeHash();

  @$internal
  @override
  $ProviderElement<UpdateTheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateTheme create(Ref ref) {
    return updateTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateTheme>(value),
    );
  }
}

String _$updateThemeHash() => r'5cbb603e6a9048d4c90461fd54359e3bc43b07d0';

/// Provides the UpdateLocale use case.
@ProviderFor(updateLocale)
const updateLocaleProvider = UpdateLocaleProvider._();

/// Provides the UpdateLocale use case.
final class UpdateLocaleProvider
    extends $FunctionalProvider<UpdateLocale, UpdateLocale, UpdateLocale>
    with $Provider<UpdateLocale> {
  /// Provides the UpdateLocale use case.
  const UpdateLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateLocaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateLocaleHash();

  @$internal
  @override
  $ProviderElement<UpdateLocale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateLocale create(Ref ref) {
    return updateLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateLocale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateLocale>(value),
    );
  }
}

String _$updateLocaleHash() => r'47ff3e245e63f0d15ebef82e4cb565e33ad22cb3';

/// Provides the UpdateDsSortOrder use case.
@ProviderFor(updateDsSortOrder)
const updateDsSortOrderProvider = UpdateDsSortOrderProvider._();

/// Provides the UpdateDsSortOrder use case.
final class UpdateDsSortOrderProvider
    extends
        $FunctionalProvider<
          UpdateDsSortOrder,
          UpdateDsSortOrder,
          UpdateDsSortOrder
        >
    with $Provider<UpdateDsSortOrder> {
  /// Provides the UpdateDsSortOrder use case.
  const UpdateDsSortOrderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateDsSortOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateDsSortOrderHash();

  @$internal
  @override
  $ProviderElement<UpdateDsSortOrder> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateDsSortOrder create(Ref ref) {
    return updateDsSortOrder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateDsSortOrder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateDsSortOrder>(value),
    );
  }
}

String _$updateDsSortOrderHash() => r'673561a8465479aba93166631d5f0a106b024778';

/// Provides the UpdateDtSortOrder use case.
@ProviderFor(updateDtSortOrder)
const updateDtSortOrderProvider = UpdateDtSortOrderProvider._();

/// Provides the UpdateDtSortOrder use case.
final class UpdateDtSortOrderProvider
    extends
        $FunctionalProvider<
          UpdateDtSortOrder,
          UpdateDtSortOrder,
          UpdateDtSortOrder
        >
    with $Provider<UpdateDtSortOrder> {
  /// Provides the UpdateDtSortOrder use case.
  const UpdateDtSortOrderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateDtSortOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateDtSortOrderHash();

  @$internal
  @override
  $ProviderElement<UpdateDtSortOrder> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateDtSortOrder create(Ref ref) {
    return updateDtSortOrder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateDtSortOrder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateDtSortOrder>(value),
    );
  }
}

String _$updateDtSortOrderHash() => r'6305a19e289fd078faf4f07ab6121f9414846560';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
