import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_education_approval/presentation/bloc/user_education_approval_event.dart';
import 'package:job_portal/views/user_education_approval/presentation/bloc/user_education_approval_state.dart';

import '../../../../utils/resourses/data_state.dart';
import '../../domain/usecases/user_education_approval_usecase.dart';

class UserEducationApprovalBloc extends Bloc<UserEducationApprovalEvent, UserEducationApprovalState> {
  final UserEducationApprovalUsecase useCase;

  UserEducationApprovalBloc(this.useCase) : super(UserEducationApprovalLoading()) {
    on<LoadMasterData>((event, emit) async {
      emit(UserEducationApprovalLoading());
      try {
        final result = await useCase.getMasterData();
        if (result is DataSuccess) {
          emit(UserEducationApprovalLoaded(result.data!));
        } else {
          emit(UserEducationApprovalError(result.error.toString()));
        }
      } catch (e) {
        emit(UserEducationApprovalError(e.toString()));
      }
    });

    on<UpdateUserEducation>((event, emit) async {
      emit(UserEducationApprovalLoading());
      try {
        final result = await useCase.updateUserEducation(event.id, event.request);
        if (result is DataSuccess) {
          emit(UserEducationApprovalUpdated(result.data));
          // emit(UserEducationApprovalLoaded(result.data));
        } else {
          emit(UserEducationApprovalError(result.error.toString()));
        }
      } catch (e) {
        emit(UserEducationApprovalError(e.toString()));
      }
    });


  }
}