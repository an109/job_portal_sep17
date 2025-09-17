import 'dart:convert';
import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/domain/usecases/detailed_signup_usecase.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_event.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/signup_as_anyone_bloc/detailed_signup_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../utils/resourses/data_state.dart';
import '../../../domain/entities/metadata_entities.dart';

class DetailedSignupBloc
    extends Bloc<DetailedSignupEvent, DetailedSignupState> {
  final DetailedSignupUsecase _detailedSignupUsecase;

  DetailedSignupBloc(this._detailedSignupUsecase)
      : super(const DetailedSignupInitial()) {
    on<DetailedSignupGetBasicUserInfo>(_onGetBasicUserInfo);
    on<DetailedSignupGetCollegeDetails>(_onGetCollegeDetails);
    on<DetailedSingupSubmitUserDetails>(_onSubmitUserDetails);
    on<DetailedSignupGetSpecializations>(_onGetSpecializations);
  }

  Future<void> _onGetMasterAllData(DetailedSignupGetMasterAllData event, Emitter<DetailedSignupState> emit) async {
    try {
      developer.log('Fetching Master All API data...');
      final response = await _detailedSignupUsecase.getMasterAllData();
      if (response is DataSuccess) {
        final masterData = response.data;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('master_api_response', jsonEncode(masterData.toJson()));
        developer.log('Master API data cached successfully.');
        emit(const MasterAllDataLoaded());
      } else if (response is DataFailed) {
        developer.log('Master API failed: ${response.error}');
        emit(const MasterAllDataError());
      }
    } catch (e) {
      developer.log('Exception during Master API call: $e');
      emit(const MasterAllDataError());
    }
  }

  Future<void> _onGetBasicUserInfo(DetailedSignupGetBasicUserInfo event, Emitter<DetailedSignupState> emit) async {
    try {
      emit(const DetailedSignupGetBasicUserInfoLoading());
      final responseUserInfo = await _detailedSignupUsecase.getBasicUserInfo(event.emailMap);
      final responseLocations = await _detailedSignupUsecase.getLocations();
      developer.log('Response of get basic user info : ${responseUserInfo.data!.message}');
      emit(DetailedSignupGetBasicUserInfoLoaded(
          responseUserInfo.data!, responseLocations.data!));
    } catch (e) {
      developer.log('Ending up in error get basic user info : $e');
      emit(const DetailedSignupGetBasicUserInfoError());
    }
  }

  Future<void> _onGetCollegeDetails(DetailedSignupGetCollegeDetails event, Emitter<DetailedSignupState> emit) async {
    try {
      emit(const DetailedSignupGetCollegeDetailsLoading());
      developer.log('Course and clg updated .1bloc');
      final colleges = await _detailedSignupUsecase.getColleges(event.emailMap);
      final courses = await _detailedSignupUsecase.getCourses();
      developer.log('Course and clg updated .2bloc: $colleges');
      emit(DetailedSignupGetCollegeDetailsLoaded(
        colleges.data!,
        courses.data!,
      ));
      developer.log('Course and clg updated .3bloc');
    } catch (e) {
      emit(const DetailedSignupGetCollegeDetailsError());
      developer.log('Course and clg updated .4bloc');
    }
  }

  Future<void> _onGetSpecializations(
      DetailedSignupGetSpecializations event,
      Emitter<DetailedSignupState> emit,
      ) async {
    // Preserve existing college and course data
    CollegeListEntity? collegesListResponse;
    CourseListEntity? coursesListResponse;
    if (state is DetailedSignupGetCollegeDetailsLoaded) {
      collegesListResponse = (state as DetailedSignupGetCollegeDetailsLoaded).collegesListResponse;
      coursesListResponse = (state as DetailedSignupGetCollegeDetailsLoaded).coursesListResponse;
    }

    emit(DetailedSignupSpecializationLoading(
      collegesListResponse: collegesListResponse,
      coursesListResponse: coursesListResponse,
    ));

    try {
      developer.log('🔧 Specialization UseCase Result: ${event.course_id}');
      final specializations = await _detailedSignupUsecase.getSpecialization(event.course_id);
      developer.log('🔧 Specialization UseCase Result: $specializations');

      if (specializations is DataSuccess<List<SpecializationEntity>>) {
        final data = specializations.data;
        if (data != null && data.isNotEmpty) {
          emit(DetailedSignupSpecializationLoaded(
            data,
            collegesListResponse: collegesListResponse,
            coursesListResponse: coursesListResponse,
          ));
          developer.log(' Specializations loaded: ${data.length} items');
        } else {
          emit(const DetailedSignupSpecializationError());
          developer.log(' No specializations found for course ID: ${event.course_id}');
        }
      } else {
        emit(const DetailedSignupSpecializationError());
        developer.log(' Failed to load specializations: $specializations');
      }
    } catch (e, st) {
      developer.log(' Exception in _onGetSpecializations: $e\n$st');
      emit(const DetailedSignupSpecializationError());
    }
  }

  Future<void> _onSubmitUserDetails(DetailedSingupSubmitUserDetails event, Emitter<DetailedSignupState> emit) async {
    try {
      emit(const DetailedSingupSubmitUserDetailsLoading());
      final response = await _detailedSignupUsecase.submitDetailedUserProfile(event.params);
      emit(DetailedSingupSubmitUserDetailsLoaded(response.data!));
    } catch (e) {
      emit(const DetailedSingupSubmitUserDetailsError('Something error occurred'));
    }
  }
}