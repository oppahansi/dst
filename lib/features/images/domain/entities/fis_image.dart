
class FisImage {
  final String url;
  final String preview;
  final String? description;
  final String? photographer;
  final String? license;
  final String? source;

  FisImage({
    required this.url,
    required this.preview,
    this.description,
    this.photographer,
    this.license,
    this.source,
  });

  factory FisImage.fromMap(Map<String, dynamic> map) {
    return FisImage(
      url: map['url'] as String,
      preview: map['preview'] as String,
      description: map['description'] as String?,
      photographer: map['photographer'] as String?,
      license: map['license'] as String?,
      source: map['source'] as String?,
    );
  }
}