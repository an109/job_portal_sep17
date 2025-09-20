// opportunity_bloc.dart
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/post_opportunities/domain/usecases/metadata_usecase.dart';
import 'package:job_portal/views/post_opportunities/presentation/bloc/opportunity_event.dart';
import 'package:job_portal/views/post_opportunities/presentation/bloc/opportunity_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/resourses/data_state.dart';
import '../../domain/entities/internship_metadata_entity.dart';
import '../../domain/entities/master_data_entity.dart';

class OpportunityBloc extends Bloc<OpportunityEvent, OpportunityState> {
  final MetadataUsecase _metadataUsecase;
  final CreateJobPostUsecase _createJobPostUsecase;

  OpportunityBloc(this._metadataUsecase, this._createJobPostUsecase)
      : super(const OpportunityInitial()) {
    on<OpportunityMetaDataLoad>(_onLoadMetaData);
    on<OpportunityCreateJobPost>(_onCreateJobPost);
    on<LoadMasterDataEvent>(_onLoadMasterData); //  Added
  }

  Future<void> _onLoadMetaData(
      OpportunityMetaDataLoad event, Emitter<OpportunityState> emit) async {
    try {
      emit(const OpportunityMetadataLoading());

      //  Load from master/all instead
      final response = await _metadataUsecase.getMasterAllData();

      if (response is DataSuccess && response.data != null) {
        final masterDataJson = response.data as Map<String, dynamic>;

        //  Convert to InternshipMetadataEntity
        final metadata = InternshipMetadataEntity.fromMasterData(masterDataJson);

        emit(OpportunityMetadataLoaded(metadata));
      } else {
        emit(const OpportunityMetadataError());
      }
    } catch (e) {
      emit(const OpportunityMetadataError());
    }
  }

  // Future<void> _onCreateJobPost(
  //     OpportunityCreateJobPost event, Emitter<OpportunityState> emit) async {
  //   try {
  //     emit(const OpportunityJobPostLoading());
  //     final response = await _createJobPostUsecase(params: event.params);
  //     if (response is DataSuccess && response.data != null) {
  //       emit(OpportunityJobPostLoaded(response.data!));
  //     } else {
  //       emit(const OpportunityJobPostError());
  //     }
  //   } catch (e) {
  //     emit(const OpportunityJobPostError());
  //   }
  // }

  Future<void> _onCreateJobPost(
      OpportunityCreateJobPost event, Emitter<OpportunityState> emit) async {
    try {
      emit(const OpportunityJobPostLoading());
      final paramsWithStatus = {
        ...event.params,
        'active_status': event.activeStatus,
      };
      final response = await _createJobPostUsecase(params: paramsWithStatus);

      print('>>> BLOC: Response is DataSuccess: ${response is DataSuccess}');
      print('>>> BLOC: Response data is not null: ${response.data != null}');
      print('>>> BLOC: Full response: $response');

      if (response is DataSuccess && response.data != null) {
        print('>>>>>>>>>>>>>>>> BLOC: EMITTING OpportunityJobPostLoaded');
        emit(OpportunityJobPostLoaded(response.data!));
      } else {
        print('>>>>>>>>>>>>>>>>>>>>>> BLOC: EMITTING OpportunityJobPostError (Condition Failed)');
        emit(const OpportunityJobPostError());
      }
    } catch (e) {
      print('>>>>>>>>>>>>>> BLOC: EXCEPTION CAUGHT: $e'); // 🚨 This is likely being printed
      emit(const OpportunityJobPostError());
    }
  }

  //  New: Handle master data loading
  Future<void> _onLoadMasterData(
      LoadMasterDataEvent event, Emitter<OpportunityState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('master_api_response');

      //  Try cache first
      if (cached != null) {
        final jsonMap = jsonDecode(cached) as Map<String, dynamic>;
        final masterData = MasterDataEntity.fromJson(jsonMap);
        emit(MasterDataLoaded(masterData));
        return;
      }

      //  Fetch from API
      emit(const MasterDataLoading());
      final response = await _metadataUsecase.getMasterAllData();

      if (response is DataSuccess && response.data != null) {
        final masterData = MasterDataEntity.fromJson(response.data);

        //  Save to cache
        await prefs.setString('master_api_response', jsonEncode(masterData.toJson()));

        emit(MasterDataLoaded(masterData));
      } else {
        emit(const MasterDataError());
      }
    } on Exception catch (e) {
      emit(const MasterDataError());
    }
  }}