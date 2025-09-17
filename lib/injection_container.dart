import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/utils/network/dio_client.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/upload_file_get_url/data/data_source/upload_file_api_service.dart';
import 'package:job_portal/utils/upload_file_get_url/data/repository/upload_file_repository_impl.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/repository/upload_file_repository.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/usecases/upload_file_usecase.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_bloc.dart';
import 'package:job_portal/views/Common_Screens/data/data_source/forgot_password_api_service.dart';
import 'package:job_portal/views/Common_Screens/data/repository/forgot_password_repository_impl.dart';
import 'package:job_portal/views/Common_Screens/domain/repository/forgot_password_repository.dart';
import 'package:job_portal/views/Common_Screens/domain/usecase/forgot_password_usecases.dart';
import 'package:job_portal/views/Common_Screens/presentation/bloc/forgot_password_bloc.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/data/data_sources/Recruiter_update_profile_api_service.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/data/repository/Recruiter_update_profile_repository_impl.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/domain/repository/Recruiter_update_profile_repository.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/domain/usecases/Recruiter_update_profile_usecase.dart';
import 'package:job_portal/views/Recruiter_Profile_Screens/presentation/bloc/Recruiter_update_profile_bloc.dart';
import 'package:job_portal/views/company_register/data/data_sources/company_register_api_service.dart';
import 'package:job_portal/views/company_register/data/repository/company_register_response_impl.dart';
import 'package:job_portal/views/company_register/domain/repository/company_register_repository.dart';
import 'package:job_portal/views/company_register/domain/usecases/company_register_usecase.dart';
import 'package:job_portal/views/company_register/presentation/bloc/company_register_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/data/data_source/detailed_api_service.dart';
import 'package:job_portal/views/detailed_signup_student/data/repository/skill_repository_impl.dart';
import 'package:job_portal/views/detailed_signup_student/domain/repository/skill_repository.dart';
import 'package:job_portal/views/detailed_signup_student/domain/usecases/skill_usecase.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/master_data_bloc/master_data_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_bloc.dart';
import 'package:job_portal/views/feed/data/data_sources/feed_api_service.dart';
import 'package:job_portal/views/feed/data/repository/feed_repository_impl.dart';
import 'package:job_portal/views/feed/domain/repository/feed_repository.dart';
import 'package:job_portal/views/feed/domain/usecases/feed_usecase.dart';
import 'package:job_portal/views/feed/presentation/bloc/create_feed_post_bloc/create_feed_post_bloc.dart';
import 'package:job_portal/views/feed/presentation/bloc/feed_bloc/feed_bloc.dart';
import 'package:job_portal/views/job_related/data/data_source/job_screens_api_service.dart';
import 'package:job_portal/views/job_related/data/repository/jobs_repository_impl.dart';
import 'package:job_portal/views/job_related/domain/repository/jobs_repository.dart';
import 'package:job_portal/views/job_related/domain/usecases/jobs_usecase.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_apply_bloc/job_apply_bloc.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_bloc/job_bloc.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_details_bloc/job_details_bloc.dart';
import 'package:job_portal/views/login/data/data_source/login_api_service.dart';
import 'package:job_portal/views/login/data/repository/login_repository_impl.dart';
import 'package:job_portal/views/login/domain/repository/login_repository.dart';
import 'package:job_portal/views/login/domain/usecases/login_usecase.dart';
import 'package:job_portal/views/login/presentation/bloc/remote_login_bloc.dart';
import 'package:job_portal/views/post_opportunities/data/data_sources/opportunities_api_service.dart';
import 'package:job_portal/views/post_opportunities/data/repository/opportunities_repository_impl.dart';
import 'package:job_portal/views/post_opportunities/domain/repository/opportunity_repository.dart';
import 'package:job_portal/views/post_opportunities/domain/usecases/metadata_usecase.dart';
import 'package:job_portal/views/post_opportunities/presentation/bloc/opportunity_bloc.dart';
import 'package:job_portal/views/recruiter_application/data/data_source/recruiter_application_api_service.dart';
import 'package:job_portal/views/recruiter_application/data/repository/recruiter_application_repository_impl.dart';
import 'package:job_portal/views/recruiter_application/domain/repository/recruiter_application_repository.dart';
import 'package:job_portal/views/recruiter_application/domain/usecases/recruiter_application_usecase.dart';
import 'package:job_portal/views/recruiter_application/presentation/bloc/recruiter_application_bloc.dart';
import 'package:job_portal/views/recruiter_dashboard/data/data_source/recruiter_dashboard_api_service/recruiter_dashboard_api_service.dart';
import 'package:job_portal/views/recruiter_dashboard/data/repository/recruiter_dashboard_repository_impl.dart';
import 'package:job_portal/views/recruiter_dashboard/domain/usecases/recruiter_dashboard_usecases.dart';
import 'package:job_portal/views/recruiter_dashboard/presentation/bloc/recruiter_dashboard_bloc/Recruiter_Dashboard_Bloc.dart';
import 'package:job_portal/views/recruiter_full_view_application/data/data_sources/recruiter_full_view_application_api_service.dart';
import 'package:job_portal/views/recruiter_full_view_application/data/repository/recruiter_full_view_application_repository_impl.dart';
import 'package:job_portal/views/recruiter_full_view_application/domain/repository/recruiter_full_view_application_repository.dart';
import 'package:job_portal/views/recruiter_full_view_application/domain/usecases/recruiter_full_view_application_usecase.dart';
import 'package:job_portal/views/recruiter_full_view_application/presentation/bloc/recruiter_full_view_application_bloc.dart';
import 'package:job_portal/views/recruiter_job_post/data/data_source/recruiter_job_post_api_service.dart';
import 'package:job_portal/views/recruiter_job_post/data/repository/recruiter_job_post_repository_impl.dart';
import 'package:job_portal/views/recruiter_job_post/domain/usecases/recruiter_job_post_usecase.dart';
import 'package:job_portal/views/recruiter_job_post/presentation/bloc/recruiter_job_post_bloc/recruiter_job_post_bloc.dart';
import 'package:job_portal/views/recruiter_pending_tasks/data/data_source/recruiter_pending_tasks_api_service.dart';
import 'package:job_portal/views/recruiter_pending_tasks/data/repository/recruiter_pending_tasks_repository_impl.dart';
import 'package:job_portal/views/recruiter_pending_tasks/domain/repository/recruiter_pending_tasks_repository.dart';
import 'package:job_portal/views/recruiter_pending_tasks/domain/usecases/recruiter_pending_tasks_usecase.dart';
import 'package:job_portal/views/recruiter_pending_tasks/presentation/bloc/recruiter_pending_tasks_bloc.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/data/data_source/recruiter_pipeline_candidates_api_service.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/data/repository/recruiter_pipeline_candidates_repository_impl.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/domain/repository/recruiter_pipeline_candidates_repository.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/domain/usecases/recruiter_pipeline_candidates_usecase.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/presentation/bloc/recruiter_pipeline_candidates_bloc.dart';
import 'package:job_portal/views/recruiter_schedule_interview/data/data_sources/recruiter_schedule_interview_api_service.dart';
import 'package:job_portal/views/recruiter_schedule_interview/data/repository/recruiter_schedule_interview_repository_impl.dart';
import 'package:job_portal/views/recruiter_schedule_interview/domain/repository/recruiter_schedule_interview_repository.dart';
import 'package:job_portal/views/recruiter_schedule_interview/domain/usecases/recruiter_schedule_interview_usecase.dart';
import 'package:job_portal/views/recruiter_schedule_interview/presentaion/bloc/recruiter_schedule_interview_bloc.dart';
import 'package:job_portal/views/recruiter_send_assignment/data/repository/recruiter_application_repository_impl.dart';
import 'package:job_portal/views/recruiter_send_assignment/domain/repository/recruiter_send_assignment_repository.dart';
import 'package:job_portal/views/recruiter_send_assignment/domain/usecases/recruiter_send_assignment_usecase.dart';
import 'package:job_portal/views/recruiter_send_assignment/presenation/bloc/recruiter_send_assignment_bloc.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/data/data_source/recruiter_upcoming_interviews_api_service.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/data/repository/recruiter_upcoming_interviews_repository_impl.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/domain/repository/recruiter_upcoming_interviews_repository.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/domain/usecases/recruiter_upcoming_interviews_usecase.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/presentation/bloc/recruiter_upcoming_interviews_bloc.dart';
import 'package:job_portal/views/signup_recruiter/data/data_source/recruiter_signup_api_service.dart';
import 'package:job_portal/views/signup_recruiter/data/repository/recruiter_signup_repository_impl.dart';
import 'package:job_portal/views/signup_recruiter/domain/repository/recruiter_signup_repository.dart';
import 'package:job_portal/views/signup_recruiter/domain/usecases/recruiter_signup_usecase.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/recruiter_signup_bloc/recruiter_signup_bloc.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/verify_otp_recruiter_bloc/verify_otp_recruiter_bloc.dart';
import 'package:job_portal/views/signup_student/data/data_source/signup_api_service.dart';
import 'package:job_portal/views/detailed_signup_student/data/repository/detailed_signup_repository_impl.dart';
import 'package:job_portal/views/signup_student/data/repository/signup_repository_impl.dart';
import 'package:job_portal/views/detailed_signup_student/domain/repository/detailed_signup_repository.dart';
import 'package:job_portal/views/signup_student/domain/repository/signup_repository.dart';
import 'package:job_portal/views/detailed_signup_student/domain/usecases/detailed_signup_usecase.dart';
import 'package:job_portal/views/signup_student/domain/usecase/signup_usecase.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_bloc.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:job_portal/views/signup_university/data/data_source/university_signup_api_service.dart';
import 'package:job_portal/views/signup_university/data/repository/university_signup_repository_impl.dart';
import 'package:job_portal/views/signup_university/domain/repository/university_signup_repository.dart';
import 'package:job_portal/views/signup_university/domain/usecase/university_signup_usecase.dart';
import 'package:job_portal/views/signup_university/presentation/blocs/university_signup_bloc.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/data/data_source/user_auth_otp_api_service.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/data/repository/user_auth_otp%20repository_impl.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/domain/repository/user_auth_otp_repository.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/domain/usecases/user_auth_otp_usecase.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/presentation/bloc/user_auth_bloc.dart';
import 'package:job_portal/views/user_education_approval/data/data_sources/user_education_approval_api_service.dart';
import 'package:job_portal/views/user_education_approval/data/repository/user_education_approval_repository_impl.dart';
import 'package:job_portal/views/user_education_approval/domain/repository/user_education_approval_repository.dart';
import 'package:job_portal/views/user_education_approval/domain/usecases/user_education_approval_usecase.dart';
import 'package:job_portal/views/user_education_approval/presentation/bloc/user_education_approval_bloc.dart';
import 'package:job_portal/views/user_profile/data/data_sources/profile_api_service.dart';
import 'package:job_portal/views/user_profile/data/repository/change_password_repository_impl.dart';
import 'package:job_portal/views/user_profile/data/repository/profile_repository_impl.dart';
import 'package:job_portal/views/user_profile/domain/repository/change_password_repository.dart';
import 'package:job_portal/views/user_profile/domain/repository/profile_repository.dart';
import 'package:job_portal/views/user_profile/domain/usecases/change_password_usecase.dart';
import 'package:job_portal/views/user_profile/domain/usecases/profile_usecases.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/job_applications_bloc/job_application_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/manage_account_bloc/manage_account_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/raise_ticket_bloc/raise_ticket_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/terms_and_conditions_bloc/terms_and_conditions_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/upload_resume_bloc/upload_resume_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/your_experience_bloc/your_experience_bloc.dart';
import 'package:job_portal/views/user_skill_approval/data/data_sources/user_skill_approval_api_service.dart';
import 'package:job_portal/views/user_skill_approval/data/repository/user_skill_approval_repository_impl.dart';
import 'package:job_portal/views/user_skill_approval/domain/repository/user_skill_approval_repository.dart';
import 'package:job_portal/views/user_skill_approval/domain/usecases/user_skill_approval_usecase.dart';
import 'package:job_portal/views/user_skill_approval/presentation/bloc/user_skill_approval_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_portal/views/recruiter_send_assignment/data/data_source/recruiter_send_assignment_api_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final sharedPreference = await SharedPreferences.getInstance();
  // Register Shared Preference
  sl.registerSingleton<SharedPreferences>(sharedPreference);
  // Register Preference Manager passing the shared preference instance
  sl.registerSingleton<PreferencesManager>(
      await PreferencesManager.create(sharedPreference));

  // Register dio client
  sl.registerSingleton<DioClient>(DioClient(Urls.baseUrl));

  // Dependencies / Api services
  sl.registerSingleton<SignupApiService>(
      SignupApiService(sl<DioClient>().instance));
  sl.registerSingleton<LoginApiService>(
      LoginApiService(sl<DioClient>().instance));
  sl.registerSingleton<DetailedApiService>(
      DetailedApiService(sl<DioClient>().instance));
  sl.registerSingleton<RecruiterSignupApiService>(
      RecruiterSignupApiService(sl<DioClient>().instance));
  sl.registerSingleton<RecruiterDashboardApiService>(
      RecruiterDashboardApiService(sl<DioClient>().instance));
  sl.registerSingleton<OpportunitiesApiService>(
      OpportunitiesApiService(sl<DioClient>().instance));
  sl.registerSingleton<JobScreensApiService>(
      JobScreensApiService(sl<DioClient>().instance));
  sl.registerSingleton<UniversitySignupApiService>(
      UniversitySignupApiService(sl<DioClient>().instance));
  sl.registerSingleton<FeedApiService>(
      FeedApiService(sl<DioClient>().instance));
  sl.registerSingleton<ProfileApiService>(
      ProfileApiService(sl<DioClient>().instance));
  sl.registerSingleton<UploadFileApiService>(
      UploadFileApiService(sl<DioClient>().instance));
  sl.registerSingleton<RecruiterJobPostApiService>(
      RecruiterJobPostApiService(sl<DioClient>().instance));
  sl.registerSingleton<RecruiterFullViewApplicationApiService>(
      RecruiterFullViewApplicationApiService(sl<DioClient>().instance));
  sl.registerSingleton<RecruiterScheduleInterviewApiService>(
      RecruiterScheduleInterviewApiService(sl<DioClient>().instance));
  sl.registerSingleton<RecruiterApplicationApiService>(
      RecruiterApplicationApiService(sl<DioClient>().instance));
  sl.registerLazySingleton<UserSkillApprovalApiService>(() {
    final dio = sl<DioClient>().instance;
    dio.options.headers['Authorization'] = 'Bearer YOUR_JWT_TOKEN';
    return UserSkillApprovalApiService(dio);
  });
  // sl.registerLazySingleton<UserSkillApprovalApiService>(() {
  //   final dio = sl<Dio>();
  //   dio.options.headers['Authorization'] = 'Bearer YOUR_JWT_TOKEN';
  //   return UserSkillApprovalApiService(dio);
  // });
      // User Profile Get Verified for Authentication
  sl.registerSingleton<UserAuthOtpApiService>(
      UserAuthOtpApiService(sl<DioClient>().instance));
  sl.registerSingleton<ForgotPasswordApiService>(
    ForgotPasswordApiService(sl<DioClient>().instance),
  );
  sl.registerSingleton<RecruiterPendingTasksApiService>(
      RecruiterPendingTasksApiService(sl<DioClient>().instance));
  sl.registerSingleton<RecruiterPipelineCandidatesApiService>(
      RecruiterPipelineCandidatesApiService(sl<DioClient>().instance));
  sl.registerSingleton<RecruiterUpcomingInterviewsApiService>(
      RecruiterUpcomingInterviewsApiService(sl<DioClient>().instance));
  sl.registerSingleton<RecruiterSendAssignmentApiService>(
      RecruiterSendAssignmentApiService(sl<DioClient>().instance));
  sl.registerSingleton<CompanyRegisterApiService>(
    CompanyRegisterApiService(sl<DioClient>().instance),
  );
  sl.registerSingleton<RecruiterUpdateProfileApiService>(
    RecruiterUpdateProfileApiService(sl<DioClient>().instance),
  );
  sl.registerSingleton<UserEducationApprovalApiService>(
      UserEducationApprovalApiService(sl<DioClient>().instance)
  );

  // Blocs
  sl.registerFactory<RemoteSignupBloc>(() => RemoteSignupBloc(sl(), sl()));
  sl.registerFactory<RemoteLoginBloc>(() => RemoteLoginBloc(sl(), sl(), sl()));
  sl.registerFactory<DetailedSignupBloc>(() => DetailedSignupBloc(sl()));
  sl.registerFactory<SkillBloc>(() => SkillBloc(sl()));
  sl.registerFactory<RecruiterSignupBloc>(
      () => RecruiterSignupBloc(sl(), sl()));
  sl.registerFactory<OpportunityBloc>(() => OpportunityBloc(sl(), sl()));
  sl.registerFactory<JobBloc>(() => JobBloc(sl()));
  sl.registerFactory<JobDetailsBloc>(() => JobDetailsBloc(sl(), sl()));
  sl.registerFactory<VerifyOtpBloc>(() => VerifyOtpBloc(sl()));
  sl.registerFactory<VerifyOtpRecruiterBloc>(
      () => VerifyOtpRecruiterBloc(sl()));
  sl.registerFactory<UniversitySignupBloc>(() => UniversitySignupBloc(sl()));
  sl.registerFactory<FeedBloc>(() => FeedBloc(sl(), sl(), sl()));
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(sl(), sl(), sl()));
  sl.registerFactory<MyProfileBloc>(() => MyProfileBloc(sl(), sl()));
  sl.registerFactory<TermsAndConditionsBloc>(
      () => TermsAndConditionsBloc(sl()));
  sl.registerFactory(
    () => RecruiterFullViewApplicationBloc(useCase: sl()),
  );
  // sl.registerFactory<ManageAccountBloc>(() => ManageAccountBloc(sl()));
  sl.registerFactory<ManageAccountBloc>(() => ManageAccountBloc(
    sl<UpdateUserEmailUsecase>(),
    sl<ChangePasswordUsecase>(),
  ));
  sl.registerFactory<JobApplyBloc>(() => JobApplyBloc(sl()));
  sl.registerFactory<UploadFileBloc>(() => UploadFileBloc(sl()));
  sl.registerFactory<CreateFeedPostBloc>(() => CreateFeedPostBloc(sl()));
  sl.registerFactory<UploadResumeBloc>(() => UploadResumeBloc());
  sl.registerFactory<RecruiterDashboardBloc>(
      () => RecruiterDashboardBloc(sl()));
  sl.registerFactory<RecruiterJobPostBloc>(
    () => RecruiterJobPostBloc(sl<RecruiterJobPostApiService>()),
  );
  sl.registerFactory<RecruiterScheduleInterviewBloc>(
      () => RecruiterScheduleInterviewBloc(sl()));
  sl.registerFactory<JobApplicationBloc>(() => JobApplicationBloc(sl()));
  sl.registerFactory<RecruiterApplicationBloc>(
      () => RecruiterApplicationBloc(useCase: sl()));
  sl.registerFactory<UserAuthBloc>(
        () => UserAuthBloc(
      sendOtpToMobileUseCase: sl<SendOtpToMobileUseCase>(),
      verifyPhoneNumberUseCase: sl<VerifyPhoneNumberUseCase>(),
    ),
  );
  sl.registerFactory<UserSkillApprovalBloc>(() => UserSkillApprovalBloc(useCase: sl()));
  sl.registerFactory<YourExperienceBloc>(() => YourExperienceBloc());
  sl.registerFactory<RaiseTicketBloc>(() => RaiseTicketBloc(sl()));
  sl.registerFactory<ForgotPasswordBloc>(() => ForgotPasswordBloc(
    sendOtpToEmailUsecase: sl(),
    verifyOtpAndResetPasswordUsecase: sl(),
  ));
  sl.registerFactory<RecruiterPipelineCandidatesBloc>(() => RecruiterPipelineCandidatesBloc(sl()));
  sl.registerFactory<RecruiterUpcomingInterviewsBloc>(() => RecruiterUpcomingInterviewsBloc(sl()));
  sl.registerFactory<RecruiterPendingTasksBloc>(() => RecruiterPendingTasksBloc(sl()));
  sl.registerFactory<RecruiterSendAssignmentBloc>(() => RecruiterSendAssignmentBloc(sl()));
  sl.registerFactory<CompanyRegisterBloc>(
        () => CompanyRegisterBloc(
      createCompanyUsecase: sl<CreateCompanyUsecase>(),
      getMasterDataUsecase: sl<GetMasterDataUsecase>(),
    ),
  );
  sl.registerFactory<RecruiterUpdateProfileBloc>(() => RecruiterUpdateProfileBloc(sl()));


  sl.registerFactory(() => MasterDataBloc(dio: sl<DioClient>().instance));
  sl.registerFactory<UserEducationApprovalBloc>(() => UserEducationApprovalBloc(sl()));

  // Use Cases
  sl.registerLazySingleton<SignupUsecase>(() => SignupUsecase(sl()));
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));
  sl.registerLazySingleton<DetailedSignupUsecase>(
      () => DetailedSignupUsecase(sl()));
  sl.registerLazySingleton<SkillUsecase>(() => SkillUsecase(sl()));
  sl.registerLazySingleton<RecruiterSignupUsecase>(
      () => RecruiterSignupUsecase(sl()));
  sl.registerLazySingleton<MetadataUsecase>(() => MetadataUsecase(sl()));
  sl.registerLazySingleton<CreateJobPostUsecase>(
      () => CreateJobPostUsecase(sl()));
  sl.registerLazySingleton<JobsUsecase>(() => JobsUsecase(sl()));
  sl.registerLazySingleton<JobsDetailsUsecase>(() => JobsDetailsUsecase(sl()));
  sl.registerLazySingleton<SendOtpEmailUsecase>(
      () => SendOtpEmailUsecase(sl()));
  sl.registerLazySingleton<VerifyOtpEmailUsecase>(
      () => VerifyOtpEmailUsecase(sl()));
  sl.registerLazySingleton<VerifyOtpEmailRecruiterUsecase>(
      () => VerifyOtpEmailRecruiterUsecase(sl()));
  sl.registerLazySingleton<SendOtpEmailRecruiterUsecase>(
      () => SendOtpEmailRecruiterUsecase(sl()));
  sl.registerLazySingleton<CoursesUsecase>(() => CoursesUsecase(sl()));
  sl.registerLazySingleton<LoginSendOtpEmailUsecase>(
      () => LoginSendOtpEmailUsecase(sl()));
  sl.registerLazySingleton<LoginVerifyOtpEmailUsecase>(
      () => LoginVerifyOtpEmailUsecase(sl()));
  sl.registerLazySingleton<FeedUsecase>(() => FeedUsecase(sl()));
  sl.registerLazySingleton<ProfileUsecase>(() => ProfileUsecase(sl()));
  sl.registerLazySingleton<UserDetailUsecase>(() => UserDetailUsecase(sl()));
  sl.registerLazySingleton<TermsAndConditionsUsecase>(
      () => TermsAndConditionsUsecase(sl()));
  sl.registerLazySingleton<UpdateUserProfileUsecase>(
      () => UpdateUserProfileUsecase(sl()));
  sl.registerLazySingleton<UpdateUserEmailUsecase>(
      () => UpdateUserEmailUsecase(sl()));
  sl.registerLazySingleton<ChangePasswordUsecase>(
          () => ChangePasswordUsecase(sl()));
  sl.registerLazySingleton<FeedPostLikeUsecase>(
      () => FeedPostLikeUsecase(sl()));
  sl.registerLazySingleton<FeedPostCommentUsecase>(
      () => FeedPostCommentUsecase(sl()));
  sl.registerLazySingleton<JobApplyUsecase>(() => JobApplyUsecase(sl()));
  sl.registerLazySingleton<UploadFileUsecase>(() => UploadFileUsecase(sl()));
  sl.registerLazySingleton<CreateFeedPostUsecase>(
      () => CreateFeedPostUsecase(sl()));
  sl.registerLazySingleton<AllJobApplicationsUsecase>(
      () => AllJobApplicationsUsecase(sl()));
  sl.registerLazySingleton<GetFollowersUsecase>(
      () => GetFollowersUsecase(sl()));
  sl.registerLazySingleton<GetFollowingUsecase>(
      () => GetFollowingUsecase(sl()));
  sl.registerLazySingleton<RaiseTicketUsecase>(() => RaiseTicketUsecase(sl()));
  sl.registerLazySingleton<RecruiterDashboardUsecase>(
          () => RecruiterDashboardUsecase(sl()));
  sl.registerLazySingleton(
        () => GetApplicantDetailsUseCase(sl()),
  );
  sl.registerLazySingleton<RecruiterJobPostsUseCase>(
          () => RecruiterJobPostsUseCase(sl()));
  sl.registerLazySingleton<RecruiterScheduleInterviewUseCase>(
          () => RecruiterScheduleInterviewUseCase(sl()));
  sl.registerLazySingleton<RecruiterApplicationUseCase>(
          () => RecruiterApplicationUseCase(sl()));
  sl.registerLazySingleton<SendOtpToMobileUseCase>(
      () => SendOtpToMobileUseCase(sl()));
  sl.registerLazySingleton<VerifyPhoneNumberUseCase>(
      () => VerifyPhoneNumberUseCase(sl()));
  sl.registerLazySingleton<SendOtpToEmailUsecase>(
        () => SendOtpToEmailUsecase(sl()),
  );
  sl.registerLazySingleton<VerifyOtpAndResetPasswordUsecase>(
        () => VerifyOtpAndResetPasswordUsecase(sl()),
  );
  // sl.registerLazySingleton<ProfileUsecase>(
  //       () => ProfileUsecase(sl<ProfileRepository>()),
  // );
  sl.registerLazySingleton<UpdateUserSkillsUseCase>(() => UpdateUserSkillsUseCase(sl()));
  sl.registerLazySingleton<RecruiterPendingTasksUseCase>(
          () => RecruiterPendingTasksUseCase(sl()));
  sl.registerLazySingleton<RecruiterUpcomingInterviewsUseCase>(
          () => RecruiterUpcomingInterviewsUseCase(sl()));
  sl.registerLazySingleton<RecruiterPipelineCandidatesUseCase>(
          () => RecruiterPipelineCandidatesUseCase(sl()));
  sl.registerLazySingleton<RecruiterSendAssignmentUseCase>(
          () => RecruiterSendAssignmentUseCase(sl()));
  sl.registerLazySingleton<CreateCompanyUsecase>(
        () => CreateCompanyUsecase(
      sl<CompanyRegisterRepository>(),
    ),
  );
  sl.registerLazySingleton<GetMasterDataUsecase>(
        () => GetMasterDataUsecase(
      sl<CompanyRegisterRepository>(),
    ),
  );
  sl.registerLazySingleton<RecruiterUpdateProfileUseCase>(() => RecruiterUpdateProfileUseCase(sl()));
  sl.registerLazySingleton<UserEducationApprovalUsecase>(
          () => UserEducationApprovalUsecase(sl()));



  // Repository
  sl.registerLazySingleton<SignupRepository>(() => SignupRepositoryImpl(sl()));
  sl.registerLazySingleton<ChangePasswordRepository>(() => ChangePasswordRepositoryImpl(sl()));

  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));
  sl.registerLazySingleton<DetailedSignupRepository>(
          () => DetailedSignupRepositoryImpl(sl<DetailedApiService>()));
  sl.registerLazySingleton<RecruiterFullViewApplicationRepository>(
    () => RecruiterFullViewApplicationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SkillRepository>(() => SkillRepositoryImpl(sl()));
  sl.registerLazySingleton<RecruiterSignupRepository>(
      () => RecruiterSignupRepositoryImpl(sl()));
  sl.registerLazySingleton<OpportunityRepository>(
      () => OpportunitiesRepositoryImpl(sl()));
  sl.registerLazySingleton<JobsRepository>(() => JobsRepositoryImpl(sl()));
  sl.registerLazySingleton<UniversitySignupRepository>(
      () => UniversitySignupRepositoryImpl(sl()));
  sl.registerLazySingleton<FeedRepository>(() => FeedRepositoryImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton<UploadFileRepository>(
      () => UploadFileRepositoryImpl(sl()));
  sl.registerLazySingleton<RecruiterDashboardRepositoryImpl>(
      () => RecruiterDashboardRepositoryImpl(sl()));
  sl.registerLazySingleton<RecruiterJobPostRepositoryImpl>(
      () => RecruiterJobPostRepositoryImpl(sl()));
  sl.registerLazySingleton<RecruiterScheduleInterviewRepository>(
      () => RecruiterScheduleInterviewRepositoryImpl(sl()));
  sl.registerLazySingleton<RecruiterApplicationRepository>(
      () => RecruiterApplicationRepositoryImpl(sl()));
  sl.registerLazySingleton<UserAuthOtpRepository>(
      () => UserAuthOtpRepositoryImpl(apiService: sl()));
  sl.registerLazySingleton<ForgotPasswordRepository>(
        () => ForgotPasswordRepositoryImpl(apiService: sl<ForgotPasswordApiService>()),
  );
  // sl.registerLazySingleton<UserAuthOtpRepository>(
  //       () => UserAuthOtpRepositoryImpl(
  //     apiService: sl<UserAuthOtpApiService>(),
  //   ),
  // );
  sl.registerLazySingleton<UserSkillApprovalRepository>(() => UserSkillApprovalRepositoryImpl(sl()));
  sl.registerLazySingleton<RecruiterPendingTasksRepository>(
          () => RecruiterPendingTasksRepositoryImpl(sl()));
  sl.registerLazySingleton<RecruiterUpcomingInterviewsRepository>(
          () => RecruiterUpcomingInterviewsRepositoryImpl(sl()));
  sl.registerLazySingleton<RecruiterPipelineCandidatesRepository>(
          () => RecruiterPipelineCandidatesRepositoryImpl(sl()));

  sl.registerLazySingleton<RecruiterSendAssignmentRepository>(
          () => RecruiterSendAssignmentRepositoryImpl(sl()));
  sl.registerLazySingleton<CompanyRegisterRepository>(
        () => CompanyRegisterRepositoryImpl(
      sl<CompanyRegisterApiService>(),
    ),
  );
  sl.registerLazySingleton<RecruiterUpdateProfileRepository>(
        () => RecruiterUpdateProfileRepositoryImpl(sl()),
  );
  sl.registerSingleton<UserEducationApprovalRepository>(
      UserEducationApprovalRepositoryImpl(sl())
  );

}
