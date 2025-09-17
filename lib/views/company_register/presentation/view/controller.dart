// company_profile_controller.dart

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/views/post_opportunities/presentation/views/post_opportunity_screen.dart';

import '../../../../utils/network/dio_client.dart';
import 'model.dart';

class CompanyProfileController extends GetxController {
  final DioClient dioClient = sl<DioClient>();
  final _prefs = sl<PreferencesManager>();

  /// Observables
  var isLoading = false.obs;
  var masterData = {}.obs;
  var companyProfile = Rxn<CompanyProfile>();

  /// ✅ Get token from shared preferences
  String? getToken() => _prefs.getToken();

  /// Fetch Master Data (/api/master/all)
  Future<void> fetchMasterData() async {
    try {
      isLoading.value = true;
      final response = await dioClient.instance.get("${Urls.baseUrl}${Urls.getMasterAllData}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        masterData.value = response.data["data"];
      } else {
        Get.snackbar("Error", "Failed to fetch master data");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Create Company Profile (/api/company-recruiter/profile)
  Future<void> createCompanyProfile(CompanyProfileRequest request) async {
    try {
      isLoading.value = true;

      final response = await dioClient.instance.post(
        "https://leafyscape.com/api/company-recruiter/profile",
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsed = CompanyProfileResponse.fromJson(response.data);
        companyProfile.value = parsed.profile;
        Get.snackbar("Success", parsed.message);
        Get.to(()=> PostInternshipsScreen());
      }
    } on DioException catch (e) {
      Get.snackbar("Error", e.response?.data["message"] ?? e.message);
      print("==============>Dio Error : $e");
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("==============>Catch Error : $e");
    } finally {
      isLoading.value = false;
    }
  }

}
