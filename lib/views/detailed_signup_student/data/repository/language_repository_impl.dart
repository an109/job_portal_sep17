// lib/data/repositories/master_data_repository_impl.dart

import 'package:dio/dio.dart';

import '../../domain/entities/metadata_entities.dart';
import '../../domain/repository/language_repository.dart';
import '../model/language_response.dart';


class MasterDataRepositoryImpl implements MasterDataRepository {
  final Dio _dio;

  MasterDataRepositoryImpl(this._dio);

  @override
  Future<List<LanguageEntity>> getAllLanguages() async {
    final response = await _dio.get('/master/languages'); // Adjust endpoint
    final masterData = MasterDataResponse.fromJson(response.data);
    return masterData.languages.map((lang) => lang.toEntity()).toList();
  }
}