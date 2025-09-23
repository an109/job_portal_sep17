import '../entities/university_followers_following_entity.dart';

abstract class UniversityFollowersFollowingRepository {
  Future<List<UniversityFollowerFollowingEntity>> getFollowers(int userId);
  Future<List<UniversityFollowerFollowingEntity>> getFollowing(int userId);
}