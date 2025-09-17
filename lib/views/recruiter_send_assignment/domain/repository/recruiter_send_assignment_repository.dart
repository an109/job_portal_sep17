import '../../data/models/recruiter_send_assignment_response_model.dart';
import '../entities/recruiter_send_assignment_entity.dart';

abstract class RecruiterSendAssignmentRepository {
  Future<RecruiterSendAssignmentResponseModel> sendAssignment({
    required int applicantId,
    required RecruiterSendAssignmentEntity entity,
  });
}