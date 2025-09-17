import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_profile/domain/usecases/profile_usecases.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/job_applications_bloc/job_applications_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/job_applications_bloc/job_applications_state.dart';

class JobApplicationBloc
    extends Bloc<JobApplicationsEvent, JobApplicationsState> {
  final AllJobApplicationsUsecase _allJobApplicationsUsecase;
  JobApplicationBloc(this._allJobApplicationsUsecase)
      : super(const JobApplicationsInitial()) {
    on<LoadAllApplications>(_onLoadJobApplications);
  }

  Future<void> _onLoadJobApplications(
      LoadAllApplications event, Emitter<JobApplicationsState> emit) async {
    try {
      emit(const JobApplicationsLoading());
      final response = await _allJobApplicationsUsecase();
      print('>>>>>>>>>>> API Response Data: ${response.data}');
      emit(JobApplicationsLoaded(response.data!));
    } catch (e) {
      emit(const JobApplicationsError());
    }
  }
}
