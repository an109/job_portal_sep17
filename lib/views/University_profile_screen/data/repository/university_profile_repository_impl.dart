// university_profile_repository_impl.dart
import 'package:dio/dio.dart';
import '../../../../utils/constants/urls.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../../../utils/storage/shared_preference.dart';
import '../../domain/entities/university_profile_entity.dart';
import '../../domain/repository/university_profile_repository.dart';
import '../data_source/university_profile_api_service.dart';

class UniversityProfileRepositoryImpl implements UniversityProfileRepository {
  final UniversityProfileApiService _apiService;
  final PreferencesManager _prefs;

  UniversityProfileRepositoryImpl(this._apiService, this._prefs);

  @override
  Future<DataState<UniversityProfileEntity>> getUniversityProfile() async {
    try {
      final response = await _apiService.getUniversityProfile();
      final entity = UniversityProfileEntity(
        collegeName: response.collegeName,
        address: response.address,
        pincode: response.pincode,
        websiteLink: response.websiteLink,
        about: response.about,
        profilePic: response.profilePic,
        universityLogoUrl: response.universityLogoUrl,
        socialMediaLink: response.socialMediaLink,
        emailIdVerified: response.emailIdVerified,
        aadharVerified: response.aadharVerified,
        phoneVerified: response.phoneVerified,
        phone: response.phone,
        email: response.email,
        courseIds: response.courseIds,
      );
      return DataSuccess(entity);
    } on DioException catch (e) {
      return DataFailed(e);
    } catch (e) {
      final error = DioException(
        requestOptions: RequestOptions(path: Urls.universityDetail),
        message: 'Failed to map university profile: $e',
      );
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<void>> updateUniversityProfile(UniversityProfileEntity entity) async {
    try {
      await _apiService.updateUniversityProfile( entity);
      return const DataSuccess(null);
    } on DioException catch (e) {
      return DataFailed(e);
    } catch (e) {
      final error = DioException(
        requestOptions: RequestOptions(path: Urls.universityDetail),
        message: 'Unexpected error during update: $e',
      );
      return DataFailed(error);
    }
  }
}