import 'package:job_portal/utils/resourses/data_state.dart';
import '../../domain/entities/recruiter_dashboard_entity.dart';

abstract class RecruiterDashboardRepository {
  Future<DataState<RecruiterDashboardEntity>> getTotalJobCount();

  Future<DataState<RecruiterDashboardEntity>> getDashboardStats();
}