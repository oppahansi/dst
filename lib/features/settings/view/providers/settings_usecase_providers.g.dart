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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
