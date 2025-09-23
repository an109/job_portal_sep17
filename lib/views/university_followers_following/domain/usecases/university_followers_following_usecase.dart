
import '../entities/university_followers_following_entity.dart';
import '../repository/university_followers_following_repository.dart';

class GetFollowersUseCase {
  final UniversityFollowersFollowingRepository repository;

  GetFollowersUseCase(this.repository);

  Future<List<UniversityFollowerFollowingEntity>> call(int userId) async {
    return await repository.getFollowers(userId);
  }
}

class GetFollowingUseCase {
  final UniversityFollowersFollowingRepository repository;

  GetFollowingUseCase(this.repository);

  Future<List<UniversityFollowerFollowingEntity>> call(int userId) async {
    return await repository.getFollowing(userId);
  }
}