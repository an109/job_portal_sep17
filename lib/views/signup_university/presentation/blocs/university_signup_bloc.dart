import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/signup_university/domain/usecase/university_signup_usecase.dart';
import 'package:job_portal/views/signup_university/presentation/blocs/university_signup_event.dart';
import 'package:job_portal/views/signup_university/presentation/blocs/university_signup_state.dart';

class UniversitySignupBloc
    extends Bloc<UniversitySignupEvent, UniversitySignupState> {
  final CoursesUsecase _coursesUsecase;
  UniversitySignupBloc(this._coursesUsecase)
      : super(const UniversitySignupInitial()) {
    on<LoadCourses>(_onLoadCourse);
  }

  Future<void> _onLoadCourse(
      LoadCourses event, Emitter<UniversitySignupState> emit) async {
    try {
      emit(const CoursesLoading());

      final response = await _coursesUsecase();

      emit(CoursesLoaded(response.data!)); // pass result
    } catch (e) {
      developer.log('Error in load courses in bloc : $e');
      emit(const CoursesError());
    }
  }
}
