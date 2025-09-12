// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/days_since/data/ds_repo_impl.dart';
import 'package:sdtpro/features/days_since/domain/repos/ds_repo.dart';
import 'package:sdtpro/features/days_since/domain/usecases/get_entries.dart';
import 'package:sdtpro/features/days_since/domain/usecases/add_entry.dart';
import 'package:sdtpro/features/days_since/domain/usecases/update_entry.dart';
import 'package:sdtpro/features/days_since/domain/usecases/delete_entry.dart';

part 'ds_usecase_providers.g.dart';

@riverpod
DsRepo dsRepo(Ref ref) => DsRepoImpl();

@riverpod
GetEntries getEntries(Ref ref) => GetEntries(ref.watch(dsRepoProvider));

@riverpod
AddEntry addEntry(Ref ref) => AddEntry(ref.watch(dsRepoProvider));

@riverpod
UpdateEntry updateEntry(Ref ref) => UpdateEntry(ref.watch(dsRepoProvider));

@riverpod
DeleteEntry deleteEntry(Ref ref) => DeleteEntry(ref.watch(dsRepoProvider));
