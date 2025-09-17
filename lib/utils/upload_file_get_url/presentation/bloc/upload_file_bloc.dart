import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/usecases/upload_file_usecase.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_event.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_state.dart';

class UploadFileBloc extends Bloc<UploadFileEvent, UploadFileState> {
  final UploadFileUsecase _uploadFileUsecase;
  UploadFileBloc(this._uploadFileUsecase) : super(const UploadFileInitial()) {
    on<LoadUploadFile>(_onLoadUploadFile);
  }

  Future<void> _onLoadUploadFile(
      LoadUploadFile event, Emitter<UploadFileState> emit) async {
    try {
      emit(const UploadFileLoading());
      final map = {'formdata': event.data};
      final response = await _uploadFileUsecase(params: map);
      emit(UploadFileLoaded(response.data!));
    } catch (e) {
      developer.log("error in uploading file : ${e}");
      emit(const UploadFileError());
    }
  }
}
