import 'dart:io';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/network/dio_client.dart';
import '../../domain/entities/recruiter_send_assignment_entity.dart';
import '../../domain/repository/recruiter_send_assignment_repository.dart';
import '../models/recruiter_send_assignment_response_model.dart';

class RecruiterSendAssignmentRepositoryImpl implements RecruiterSendAssignmentRepository {
  final DioClient _dioClient;

  RecruiterSendAssignmentRepositoryImpl(this._dioClient);

  @override
  Future<RecruiterSendAssignmentResponseModel> sendAssignment({
    required int applicantId,
    required RecruiterSendAssignmentEntity entity,
  }) async {
    if (entity.assignmentFile == null) {
      throw Exception("Assignment file is required");
    }

    final formData = FormData.fromMap({
      'message': entity.message,
      'deadline': entity.deadline,
      'assignment': await MultipartFile.fromFile(
        entity.assignmentFile!.path,
        filename: entity.assignmentFile!.path.split('/').last,
      ),
    });

    try {
      final response = await _dioClient.instance.post(
        '/api/assignments/$applicantId',
        data: formData,
      );

      return RecruiterSendAssignmentResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? e.response?.data['error']?.toString() ?? 'Failed to send assignment'
          : e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception("Unknown error: $e");
    }
  }
}