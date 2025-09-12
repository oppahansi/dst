// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/sdt/data/sdt_repo_impl.dart';
import 'package:sdtpro/features/sdt/domain/repos/sdt_repo.dart';
import 'package:sdtpro/features/sdt/domain/usecases/get_sdt_entries.dart';
import 'package:sdtpro/features/sdt/domain/usecases/add_sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/usecases/update_sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/usecases/delete_sdt_entry.dart';

part 'sdt_usecase_providers.g.dart';

@riverpod
SdtRepo sdtRepo(Ref ref) => SdtRepoImpl();

@riverpod
GetSdtEntries getEntries(Ref ref) => GetSdtEntries(ref.watch(sdtRepoProvider));

@riverpod
AddSdtEntry addEntry(Ref ref) => AddSdtEntry(ref.watch(sdtRepoProvider));

@riverpod
UpdateSdtEntry updateEntry(Ref ref) =>
    UpdateSdtEntry(ref.watch(sdtRepoProvider));

@riverpod
DeleteSdtEntry deleteEntry(Ref ref) =>
    DeleteSdtEntry(ref.watch(sdtRepoProvider));
