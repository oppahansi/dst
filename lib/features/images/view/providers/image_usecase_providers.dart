// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdt/features/images/data/image_repo_impl.dart';
import 'package:sdt/features/images/domain/repos/image_repo.dart';
import 'package:sdt/features/images/domain/usecases/get_curated_images.dart';
import 'package:sdt/features/images/domain/usecases/search_images.dart';

part 'image_usecase_providers.g.dart';

@riverpod
ImageRepo imageRepo(Ref ref) {
  return ImageRepoImpl();
}

@riverpod
GetCuratedImages getCuratedImages(Ref ref) {
  return GetCuratedImages(ref.watch(imageRepoProvider));
}

@riverpod
SearchImages searchImages(Ref ref) {
  return SearchImages(ref.watch(imageRepoProvider));
}
