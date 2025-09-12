// Dart Imports
import 'dart:convert';

// Package Imports
import 'package:http/http.dart' as http;

// Project Imports
import 'package:sdtpro/core/utils/constants.dart';
import 'package:sdtpro/features/images/domain/entities/fis_result.dart';
import 'package:sdtpro/features/images/domain/repos/image_repo.dart';

class ImageRepoImpl implements ImageRepo {
  final http.Client _client;

  ImageRepoImpl({http.Client? client}) : _client = client ?? http.Client();

  Uri _buildUri(String path, Map<String, String> params) {
    return Uri.parse(
      '$fisApiBaseUrl$path',
    ).replace(queryParameters: {'api_key': fisApiKey, ...params});
  }

  Future<FisResult> _fetch(Uri uri) async {
    final response = await _client.get(uri);
    if (response.statusCode == 200) {
      return FisResult.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load images: ${response.statusCode}');
    }
  }

  @override
  Future<FisResult> getCuratedImages({int page = 1}) {
    final uri = _buildUri('/curated', {'page': page.toString()});
    return _fetch(uri);
  }

  @override
  Future<FisResult> searchImages({
    required String query,
    int page = 1,
    int perSource = 10,
  }) {
    final uri = _buildUri('/search', {
      'query': query,
      'page': page.toString(),
      'perSource': perSource.toString(),
    });
    return _fetch(uri);
  }
}
