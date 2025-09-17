import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/job_related/domain/usecases/jobs_usecase.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_apply_bloc/job_apply_event.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_apply_bloc/job_apply_state.dart';

class JobApplyBloc extends Bloc<JobApplyEvent, JobApplyState> {
  final JobApplyUsecase _jobApplyUsecase;
  JobApplyBloc(this._jobApplyUsecase) : super(const JobApplyInitial()) {
    on<LoadJobApply>(_onJobApply);
  }

  Future<void> _onJobApply(
      LoadJobApply event, Emitter<JobApplyState> emit) async {
    try {
      emit(const JobApplyLoading());
      final map = {
        'job_id': event.job_id,
        'params': {
          "why_should_we_hire_you": "I am highly skilled and motivated.",
          "confirm_availability": "Yes",
          "project": "Project description here",
          "github_link": "https://github.com/yourprofile",
          "portfolio_link": "https://yourportfolio.com",
          "education": "B.tech"
        }
      };
      final response = await _jobApplyUsecase(params: map);
      developer.log("Details of job in bloc : ${response.data}");
      emit(JobApplyLoaded(response.data!));
    } catch (e) {
      developer.log("Error of apply of job in bloc : $e");
      emit(const JobApplyError());
    }
  }
}
