import 'package:bloc/bloc.dart';
import '../../../data/data_source/recruiter_dashboard_api_service/recruiter_dashboard_api_service.dart';
import 'Recruiter_Dashboard_Event.dart';
import 'Recruiter_Dashboard_State.dart';

class RecruiterDashboardBloc
    extends Bloc<RecruiterDashboardEvent, RecruiterDashboardState> {
  final RecruiterDashboardApiService apiService;

  RecruiterDashboardBloc(this.apiService)
      : super(RecruiterDashboardInitial()) {
    on<FetchTotalJobCount>(_onFetchDashboardStats);
  }

  Future<void> _onFetchDashboardStats(
      FetchTotalJobCount event,
      Emitter<RecruiterDashboardState> emit,
      ) async {
    emit(RecruiterDashboardLoading());
    try {
      //  Call new API
      final response = await apiService.getDashboardStats();

      //  Access all fields
      emit(RecruiterDashboardLoaded(
        totalCount: response.totalCount,
        pendingTasksCount: response.pendingTasks ?? 0,
        upcomingInterviewsCount: response.upcomingInterviews ?? 0,
      ));
    } on Exception catch (e) {
      emit(RecruiterDashboardError(e.toString()));
    }
  }
}