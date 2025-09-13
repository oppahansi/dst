// Project Imports
import 'package:sdt/features/images/domain/entities/fis_result.dart';

abstract class ImageRepo {
  Future<FisResult> getCuratedImages({int page = 1});
  Future<FisResult> searchImages({
    required String query,
    int page = 1,
    int perSource = 10,
  });
}
