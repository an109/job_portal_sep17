// opportunity_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class OpportunityEvent extends Equatable {
  const OpportunityEvent();
}

class OpportunityMetaDataLoad extends OpportunityEvent {
  const OpportunityMetaDataLoad();

  @override
  List<Object?> get props => [];
}

class LoadMasterDataEvent extends OpportunityEvent {
  const LoadMasterDataEvent();

  @override
  List<Object?> get props => [];
}

class OpportunityCreateJobPost extends OpportunityEvent {
  final Map<String, dynamic> params;
  final int activeStatus;

  const OpportunityCreateJobPost(this.params, {this.activeStatus = 1});

  @override
  List<Object?> get props => [params, activeStatus];
}