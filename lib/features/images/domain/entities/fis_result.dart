// Project Imports
import 'package:sdt/features/images/domain/entities/fis_image.dart';

class FisResult {
  final int total;
  final int page;
  final int perPage;
  final List<FisImage> images;

  FisResult({
    required this.total,
    required this.page,
    required this.perPage,
    required this.images,
  });

  factory FisResult.fromMap(Map<String, dynamic> map) {
    return FisResult(
      total: map['total'] as int,
      page: map['page'] as int,
      perPage: map['perPage'] as int,
      images: (map['images'] as List<dynamic>)
          .map((e) => FisImage.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
