// Project Imports
import 'package:sdtpro/features/images/domain/entities/fis_result.dart';
import 'package:sdtpro/features/images/domain/repos/image_repo.dart';

class GetCuratedImages {
  final ImageRepo repository;
  GetCuratedImages(this.repository);

  Future<FisResult> call({int page = 1}) {
    return repository.getCuratedImages(page: page);
  }
}
