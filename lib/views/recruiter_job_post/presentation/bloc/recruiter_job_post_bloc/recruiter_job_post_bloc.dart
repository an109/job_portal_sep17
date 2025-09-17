import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/recruiter_job_post/presentation/bloc/recruiter_job_post_bloc/recruiter_job_post_event.dart';
import 'package:job_portal/views/recruiter_job_post/presentation/bloc/recruiter_job_post_bloc/recruiter_job_post_state.dart';
import '../../../data/data_source/recruiter_job_post_api_service.dart';
import '../../../domain/entities/recruiter_job_post_entity.dart';

class RecruiterJobPostBloc extends Bloc<RecruiterJobPostEvent, RecruiterJobPostState> {
  final RecruiterJobPostApiService apiService;

  RecruiterJobPostBloc(this.apiService) : super(RecruiterJobPostInitial()) {
    on<FetchAllJobPosts>(_onFetchAllJobPosts);
    print("BLoC initialized");
  }

  Future<void> _onFetchAllJobPosts(FetchAllJobPosts event, Emitter<RecruiterJobPostState> emit) async {
    print("FetchAllJobPosts event received");
    emit(RecruiterJobPostLoading());
    try {
      final response = await apiService.getAllJobPosts();

      if (response.response.statusCode == 200 && response.data != null) {

        final List<RecruiterJobPostEntity> jobs = response.data.jobPosts
            ?.map((post) => post.toEntity())
            .toList() ??
            [];

        if (jobs.isNotEmpty) {
        }

        emit(RecruiterJobPostLoaded.all(jobs));
      } else {
        emit(RecruiterJobPostError(response.response.statusMessage ?? "Failed to load job posts"));
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      emit(RecruiterJobPostError(e.message ?? "Network error"));
    } catch (e, stackTrace) {
      print("Unexpected error in BLoC: $e");
      print("Stack trace: $stackTrace");
      emit(RecruiterJobPostError("Data mapping failed"));
    }
  }
}