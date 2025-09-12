// Project Imports
import 'package:sdtpro/features/images/domain/entities/fis_result.dart';
import 'package:sdtpro/features/images/domain/repos/image_repo.dart';

class SearchImages {
  final ImageRepo repository;
  SearchImages(this.repository);

  Future<FisResult> call({
    required String query,
    int page = 1,
    int perSource = 10,
  }) {
    return repository.searchImages(
      query: query,
      page: page,
      perSource: perSource,
    );
  }
}
