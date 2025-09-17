import 'package:equatable/equatable.dart';

abstract class MasterDataEvent extends Equatable {
  const MasterDataEvent();

  @override
  List<Object?> get props => [];
}

class LoadMasterData extends MasterDataEvent {
  const LoadMasterData();
}
