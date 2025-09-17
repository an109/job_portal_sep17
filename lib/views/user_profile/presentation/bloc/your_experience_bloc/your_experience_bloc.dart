import 'dart:developer' as developer show log;

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/your_experience_bloc/your_experience_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/your_experience_bloc/your_experience_state.dart';

class YourExperienceBloc
    extends Bloc<YourExperienceEvent, YourExperienceState> {
  Map<String, dynamic> experienceProofs = {};

  YourExperienceBloc() : super(const YourExperienceInitial()) {
    on<LoadPickExperienceProof>(_onLoadExperienceProof);
  }

  Future<void> _onLoadExperienceProof(
      LoadPickExperienceProof event, Emitter<YourExperienceState> emit) async {
    try {
      emit(const PickExperienceProofLoading());
      final file = await FilePicker.platform.pickFiles();

      if (file != null && event.experienceName != null) {
        experienceProofs[event.experienceName!] = file;
        developer.log(file.files.first.name ?? 'null path');
        emit(PickExperienceProofLoaded(experienceProofs));

      } else {
        emit(const NoExperienceProofPicked());
      }
    } catch (e) {
      developer.log('Error while picking images: ${e.toString()}');
      emit(const PickExperienceProofError());
    }
  }
}
