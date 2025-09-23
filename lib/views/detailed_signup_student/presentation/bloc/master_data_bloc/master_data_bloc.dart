import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../data/model/master_data_response.dart';
import '../../../domain/entities/metadata_entities.dart';
import 'master_data_event.dart';
import 'master_data_state.dart';

class MasterDataBloc extends Bloc<MasterDataEvent, MasterDataState> {
  final Dio dio;

  MasterDataBloc({required this.dio}) : super(MasterDataInitial()) {
    on<LoadMasterData>(_onLoadMasterData);
  }

  Future<void> _onLoadMasterData(
      LoadMasterData event, Emitter<MasterDataState> emit) async {
    emit(MasterDataLoading());
    try {
      final response = await dio.get("http://bvrcrafts.com:5000/api/master/all");
      // ✅ MINIMAL FIX: Check if response.data is Map, else throw meaningful error
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Invalid response format: ${response.data}');
      }

      final masterData = MasterDataResponse.fromJson(response.data);


      // Map backend companies to your entity
      final companies = masterData.data.companies
          .map((c) => CompanyEntity(id: c.id, name: c.name))
          .toList();

      print('📡 API Response: ${response.data}');
      emit(MasterDataLoaded(
        locations: masterData.data.locations,
        jobLocations: [], // if your API has job_locations, map them here
        genders: [],      // if your API has genders, map them here
        colleges: masterData.data.colleges,
        courses: masterData.data.courses,
        domains: masterData.data.domains,
        skills: masterData.data.skills,
        specializations: masterData.data.specializations,
        companies: companies,

      ));
    } catch (e) {
      emit(MasterDataError(e.toString()));
    }
  }
}
