// opportunity_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/views/post_opportunities/domain/entities/internship_metadata_entity.dart';

import '../../domain/entities/master_data_entity.dart';

@immutable
abstract class OpportunityState extends Equatable {
  const OpportunityState();

  @override
  List<Object?> get props => [];
}

class OpportunityInitial extends OpportunityState {
  const OpportunityInitial();
}

class OpportunityMetadataLoading extends OpportunityState {
  const OpportunityMetadataLoading();
}

class OpportunityMetadataLoaded extends OpportunityState {
  final InternshipMetadataEntity internshipMetadata;

  const OpportunityMetadataLoaded(this.internshipMetadata);

  @override
  List<Object?> get props => [internshipMetadata];
}

class OpportunityMetadataError extends OpportunityState {
  const OpportunityMetadataError();
}

class OpportunityJobPostLoading extends OpportunityState {
  const OpportunityJobPostLoading();
}

// class OpportunityJobPostLoaded extends OpportunityState {
//   final String id; // Add a unique ID
//
//   const OpportunityJobPostLoaded() : id = DateTime.now().toIso8601String(); // Generate a unique ID
//
//   @override
//   List<Object?> get props => [id]; // Include the ID in props
// }

class OpportunityJobPostLoaded extends OpportunityState {
  final InternshipMetadataEntity internshipMetadata;

  const OpportunityJobPostLoaded(this.internshipMetadata);


  @override
  List<Object?> get props => [internshipMetadata];
}

class OpportunityJobPostError extends OpportunityState {
  const OpportunityJobPostError();
}

//  New: States for Master Data
class MasterDataLoading extends OpportunityState {
  const MasterDataLoading();
}

class MasterDataLoaded extends OpportunityState {
  final MasterDataEntity masterData; // Will be Map<String, dynamic>

  const MasterDataLoaded(this.masterData);

  @override
  List<Object?> get props => [masterData];
}

class MasterDataError extends OpportunityState {
  const MasterDataError();
}