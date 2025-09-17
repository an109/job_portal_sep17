import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class JobDetailsEvent extends Equatable {
  const JobDetailsEvent();
}

class LoadJobDetail extends JobDetailsEvent {
  final Map<String, dynamic> job_id;
  const LoadJobDetail(this.job_id);

  @override
  List<Object?> get props => [job_id];
}

// class LoadJobApply extends JobDetailsEvent {
//   final String job_id;
//   // final Map<String, dynamic> params;

//   const LoadJobApply(
//     this.job_id,
//   );

//   @override
//   List<Object?> get props => [job_id];
// }
