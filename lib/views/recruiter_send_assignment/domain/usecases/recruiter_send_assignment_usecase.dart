import '../../data/models/recruiter_send_assignment_response_model.dart';
import '../entities/recruiter_send_assignment_entity.dart';
import '../repository/recruiter_send_assignment_repository.dart';

class RecruiterSendAssignmentUseCase {
  final RecruiterSendAssignmentRepository _repository;

  RecruiterSendAssignmentUseCase(this._repository);

  Future<RecruiterSendAssignmentResponseModel> call({
    required int applicantId,
    required RecruiterSendAssignmentEntity entity,
  }) async {
    return await _repository.sendAssignment(
      applicantId: applicantId,
      entity: entity,
    );
  }
}