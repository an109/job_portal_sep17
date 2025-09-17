import '../../../../utils/resourses/data_state.dart';
import '../../../../utils/usecase/usecases.dart';
import '../entities/company_register_entity.dart';
import '../repository/company_register_repository.dart';

class CreateCompanyUsecase
    implements UseCase<DataState<CompanyRegisterEntity>, CompanyRegisterEntity> {
  final CompanyRegisterRepository _repository;

  CreateCompanyUsecase(this._repository);

  @override
  Future<DataState<CompanyRegisterEntity>> call({CompanyRegisterEntity? params}) {
    return _repository.registerCompany(params!);
  }


}

class GetMasterDataUsecase implements UseCase<DataState<Map<String, dynamic>>, void> {
  final CompanyRegisterRepository _repository;

  GetMasterDataUsecase(this._repository);

  @override
  Future<DataState<Map<String, dynamic>>> call({void params}) {
    return _repository.getMasterData();
  }
}