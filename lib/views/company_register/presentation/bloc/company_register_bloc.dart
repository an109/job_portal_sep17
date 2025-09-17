import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../domain/entities/company_register_entity.dart';
import '../../domain/usecases/company_register_usecase.dart';
import 'company_register_event.dart';
import 'company_register_state.dart';

class CompanyRegisterBloc extends Bloc<CompanyRegisterEvent, CompanyRegisterState> {
  final CreateCompanyUsecase createCompanyUsecase;
  final GetMasterDataUsecase getMasterDataUsecase;

  CompanyRegisterBloc({
    required this.createCompanyUsecase,
    required this.getMasterDataUsecase,
  }) : super(CompanyRegisterInitial()) {
    on<LoadMasterData>((event, emit) async {
      emit(CompanyRegisterLoading());

      final result = await getMasterDataUsecase.call();

      if (result is DataSuccess<Map<String, dynamic>>) {
        emit(MasterDataLoaded(result.data!));
      } else if (result is DataFailed<Map<String, dynamic>>) {
        final message = result.error?.message ?? 'Failed to load master data';
        emit(MasterDataError(message));
      }
    });

    on<CreateCompany>((event, emit) async {
      emit(CompanyRegisterLoading());

      final result = await createCompanyUsecase.call(params: CompanyRegisterEntity(
        designation: event.data['designation'],
        companyName: event.data['companyName'],
        industry: event.data['industry'],
        location: event.data['location'],
        about: event.data['about'],
        logoUrl: event.data['logoUrl'],
        profilePic: event.data['profilePic'],
        hiringPreferences: event.data['hiringPreferences'],
        languagesKnown: List<String>.from(event.data['languagesKnown'] ?? []),
        isEmailVerified: event.data['isEmailVerified'] ?? false,
        isPhoneVerified: event.data['isPhoneVerified'] ?? false,
        isGstVerified: event.data['isGstVerified'] ?? false,
      ));

      if (result is DataSuccess<CompanyRegisterEntity>) {
        emit(CompanyRegisterSuccess(result.data));
      } else if (result is DataFailed<CompanyRegisterEntity>) {
        final message = result.error?.message ?? 'Failed to register company';
        emit(CompanyRegisterError(message));
      }
    });
  }
}