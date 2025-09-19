import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/usecases/upload_file_usecase.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_event.dart';
import 'package:job_portal/utils/upload_file_get_url/presentation/bloc/upload_file_state.dart';

import '../../../resourses/data_state.dart';

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
      developer.log("📤 Upload Usecase Response: ${response.data}");
      if (response.data == null) {
        throw Exception("Upload response is null");
      }

      final responseData = response.data ;
      final urlList = responseData?.url;
      if (response is DataSuccess && response.data != null) {
        final responseData = response.data!;
        final urlList = responseData.url;

        if (urlList.isEmpty) {
          throw Exception("Empty URL list in response");
        }

        emit(UploadFileLoaded(responseData, uploadType: event.uploadType));
      }
      // Check if response failed
      else if (response is DataFailed) {
        throw response.error ?? Exception("Upload failed");
      }
      // Handle null data
      else {
        throw Exception("Upload response is null or invalid");
      }
      if (urlList == null || urlList is! List || urlList.isEmpty) {
        throw Exception("Invalid or empty URL in response: $responseData");
      }

      emit(UploadFileLoaded(response.data!));
    } catch (e) {
      developer.log("error in uploading file : ${e}");
      emit(const UploadFileError());
    }
  }
}
