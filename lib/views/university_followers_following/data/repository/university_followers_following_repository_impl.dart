// lib/data/repository/university_followers_following_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/university_followers_following_entity.dart';
import '../../domain/repository/university_followers_following_repository.dart';
import '../data_source/university_followers_following_api_service.dart';


class UniversityFollowersFollowingRepositoryImpl implements UniversityFollowersFollowingRepository {
  final UniversityFollowersFollowingApiService _apiService;

  UniversityFollowersFollowingRepositoryImpl(this._apiService);

  @override
  Future<List<UniversityFollowerFollowingEntity>> getFollowers(int userId) async {
    try {
      final response = await _apiService.getFollowers(userId);
      return response.map((e) => UniversityFollowerFollowingEntity.fromModel(e)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to fetch followers: ${e.message}');
    }
  }

  @override
  Future<List<UniversityFollowerFollowingEntity>> getFollowing(int userId) async {
    try {
      final response = await _apiService.getFollowing(userId);
      return response.map((e) => UniversityFollowerFollowingEntity.fromModel(e)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to fetch following: ${e.message}');
    }
  }
}