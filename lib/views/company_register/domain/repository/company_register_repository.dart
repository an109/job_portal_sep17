import '../../../../utils/resourses/data_state.dart';
import '../entities/company_register_entity.dart';

abstract class CompanyRegisterRepository {
  Future<DataState<CompanyRegisterEntity>> registerCompany(CompanyRegisterEntity entity);
  Future<DataState<Map<String, dynamic>>> getMasterData();
}