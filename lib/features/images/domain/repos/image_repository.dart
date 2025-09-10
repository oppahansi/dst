// Project Imports
import 'package:sdtpro/features/images/domain/entities/fis_result.dart';

abstract class ImageRepository {
  Future<FisResult> getCuratedImages({int page = 1});
  Future<FisResult> searchImages({
    required String query,
    int page = 1,
    int perSource = 10,
  });
}
