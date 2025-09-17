// user_skill_approval_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:job_portal/views/user_skill_approval/presentation/bloc/user_skill_approval_event.dart';
import 'package:job_portal/views/user_skill_approval/presentation/bloc/user_skill_approval_state.dart';

import '../../domain/usecases/user_skill_approval_usecase.dart';

class UserSkillApprovalBloc extends Bloc<UserSkillApprovalEvent, UserSkillApprovalState> {
  final UpdateUserSkillsUseCase useCase;

  UserSkillApprovalBloc({required this.useCase}) : super(UserSkillApprovalInitial()) {
    on<LoadUserSkills>((event, emit) async {
      emit(UserSkillApprovalLoading());
      try {
        // In real app, fetch from repo
        // For now, simulate
        final fakeSkills = [
          {'skill': 'Flutter', 'authority': 'Advanced', 'skill_id': 1},
          {'skill': 'Dart', 'authority': 'Intermediate', 'skill_id': 2},
        ];
        emit(UserSkillApprovalLoaded(fakeSkills));
      } catch (e) {
        emit(UserSkillApprovalError(e.toString()));
      }
    });

    on<SaveUserSkills>((event, emit) async {
      emit(UserSkillApprovalLoading());
      final success = await useCase.execute(event.userId, {
        'skills': event.skills,
      });
      if (success) {
        emit(UserSkillApprovalSaved(true));
      } else {
        emit(UserSkillApprovalError('Failed to save skills'));
      }
    });
  }
}