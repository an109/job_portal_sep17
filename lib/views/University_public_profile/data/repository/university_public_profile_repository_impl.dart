import '../../domain/entities/university_public_profile_entity.dart';
import '../../domain/repository/university_public_profile_repository.dart';
import '../data_source/university_public_profile_api_service.dart';

class UniversityPublicProfileRepositoryImpl implements UniversityPublicProfileRepository {
  final UniversityPublicProfileApiService _apiService;

  UniversityPublicProfileRepositoryImpl(this._apiService);

  @override
  @override
  Future<UniversityPublicProfileEntity> getUniversityPublicProfile(int userId) async {
    try {
      // ✅ Retrofit returns UniversityPublicProfileResponse directly
      final response = await _apiService.getUniversityPublicProfile(userId);

      // ✅ Extract the publicProfile (which contains all real data)
      final publicProfile = response.publicProfile;

      // ✅ Convert to Entity
      return UniversityPublicProfileEntity(
        id: publicProfile.id,
        universityLogoUrl: publicProfile.universityLogoUrl,
        pincode: publicProfile.pincode,
        profilePic: publicProfile.profilePic,
        collegeName: publicProfile.collegeName,
        address: publicProfile.address,
        websiteLink: publicProfile.websiteLink,
        about: publicProfile.about,
        socialMediaLink: publicProfile.socialMediaLink,
        user: publicProfile.user != null
            ? UserEntity.fromJson(publicProfile.user!.toJson())
            : null,
        courses: publicProfile.courses?.map((course) {
          return CourseEntity.fromJson(course.toJson());
        }).toList(),
        activity: response.activity,
      );

    } catch (e) {
      throw Exception("Failed to load university public profile: $e");
    }
  }
}