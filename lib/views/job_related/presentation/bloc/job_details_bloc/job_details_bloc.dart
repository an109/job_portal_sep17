import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/job_related/domain/usecases/jobs_usecase.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_details_bloc/job_details_event.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_details_bloc/job_details_state.dart';

class JobDetailsBloc extends Bloc<JobDetailsEvent, JobDetailsState> {
  final JobsDetailsUsecase _jobsDetailsUsecase;
  final JobApplyUsecase _jobApplyUsecase;
  JobDetailsBloc(this._jobsDetailsUsecase, this._jobApplyUsecase)
      : super(const JobDetailsInitial()) {
    on<LoadJobDetail>(_onLoadJobDetail);
    // on<LoadJobApply>(_onJobApply);
  }

  Future<void> _onLoadJobDetail(
      LoadJobDetail event, Emitter<JobDetailsState> emit) async {
    try {
      emit(const JobDetailsLoading());
      Map<String, dynamic> param = event.job_id;
      final response = await _jobsDetailsUsecase(params: param);
      emit(JobDetailsLoaded(response.data!));
      developer.log("Details of job in bloc : ${response.data}");

    } catch (e) {
      developer.log("Error of details of job in bloc : $e");
      emit(const JobDetailsError());
    }
  }

  // Future<void> _onJobApply(
  //     LoadJobApply event, Emitter<JobDetailsState> emit) async {
  //   try {
  //     emit(const JobApplyLoading());
  //     final map = {
  //       'job_id': event.job_id,
  //       'params': {
  //         "why_should_we_hire_you": "I am highly skilled and motivated.",
  //         "confirm_availability": "Yes",
  //         "project": "Project description here",
  //         "github_link": "https://github.com/yourprofile",
  //         "portfolio_link": "https://yourportfolio.com",
  //         "education": "B.tech"
  //       }
  //     };
  //     final response = await _jobApplyUsecase(params: map);
  //     developer.log("Details of job in bloc : ${response.data}");
  //     emit(JobApplyLoaded(response.data!));
  //   } catch (e) {
  //     developer.log("Error of details of job in bloc : $e");
  //     emit(const JobApplyError());
  //   }
  // }
}
