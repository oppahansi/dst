// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_usecase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provides the concrete implementation of the SettingsRepository.
/// In a real app, you might switch this out for a mock repository during tests.
@ProviderFor(settingsRepository)
const settingsRepositoryProvider = SettingsRepositoryProvider._();

/// Provides the concrete implementation of the SettingsRepository.
/// In a real app, you might switch this out for a mock repository during tests.
final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  /// Provides the concrete implementation of the SettingsRepository.
  /// In a real app, you might switch this out for a mock repository during tests.
  const SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'dd4f69cba0cdcf0a0fe2f1f6bd458bb30ff1e8ca';

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

String _$getSettingsHash() => r'0124e14b0161bcf7dfae8bdf66a3f5fbe9575be2';

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

String _$updateThemeHash() => r'489dfc994712a2f2709db9ab53b8f5235de8fc75';

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

String _$updateLocaleHash() => r'ed55089a6e6f3a6531123ffd8db98b93e20217f5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
