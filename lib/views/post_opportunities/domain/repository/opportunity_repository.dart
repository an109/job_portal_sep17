import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/post_opportunities/domain/entities/internship_metadata_entity.dart';

abstract class OpportunityRepository {
  Future<DataState<InternshipMetadataEntity>> getOpportunityFormMetadata();

  Future<DataState<InternshipMetadataEntity>> createJobPost(
      Map<String, dynamic> params);

  Future<DataState<dynamic>> getMasterAllData();
}
