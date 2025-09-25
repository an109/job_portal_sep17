

import '../../domain/entities/metadata_entities.dart';

class MasterDataResponse {
  final List<LanguageResponse> languages;

  MasterDataResponse({required this.languages});

  factory MasterDataResponse.fromJson(Map<String, dynamic> json) {
    final langList = (json['languages'] as List?)
        ?.map((e) => LanguageResponse.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [];
    return MasterDataResponse(languages: langList);
  }
}

class LanguageResponse {
  final int id;
  final String name;

  LanguageResponse({required this.id, required this.name});

  factory LanguageResponse.fromJson(Map<String, dynamic> json) {
    return LanguageResponse(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  LanguageEntity toEntity() {
    return LanguageEntity(id: id, name: name);
  }
}