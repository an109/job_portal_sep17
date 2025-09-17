import 'dart:developer' as developer show log;

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/upload_resume_bloc/upload_resume_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/upload_resume_bloc/upload_resume_state.dart';

class UploadResumeBloc extends Bloc<UploadResumeEvent, UploadResumeState> {
  UploadResumeBloc() : super(const UploadResumeInitial()) {
    on<PickResume>(_onLoadResume);
    on<ResetUploadResume>((event, emit) {
      emit(const UploadResumeInitial());
    });
  }

  Future<void> _onLoadResume(
      PickResume event, Emitter<UploadResumeState> emit) async {
    try {
      emit(const PickResumeLoading());
      final file = await FilePicker.platform.pickFiles();

      if (file != null) {
        // skillCertificates[event.skillName!] = file;
        emit(PickResumeLoaded(file));
        developer.log(file.files.first.path ?? 'null path');
      } else {
        emit(const PickResumeNoFilePicked());
      }
    } catch (e) {
      developer.log('Error while picking images: ${e.toString()}');
      emit(const PickResumeError());
    }
  }
}
