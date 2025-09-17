import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/job_related/domain/usecases/jobs_usecase.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_bloc/job_event.dart';
import 'package:job_portal/views/job_related/presentation/bloc/job_bloc/job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final JobsUsecase _jobsUsecase;
  JobBloc(this._jobsUsecase) : super(const JobInitial()) {
    on<LoadJobs>(_onLoadJobs);
  }

  Future<void> _onLoadJobs(LoadJobs event, Emitter<JobState> emit) async {
    try {
      emit(const JobsLoading());
      final response = await _jobsUsecase();
      emit(JobsLoaded(response.data!));
    } catch (e) {
      developer.log("Error loading job list : $e");
      emit(const JobsError());
    }
  }
}
