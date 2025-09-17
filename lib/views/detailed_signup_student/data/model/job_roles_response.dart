// class JobRolesListResponse {
//   final List<String> jobRoles;

//   JobRolesListResponse({required this.jobRoles});

//   factory JobRolesListResponse.fromJson(List<dynamic> json) {
//     return JobRolesListResponse(
//       jobRoles: List<String>.from(json),
//     );
//   }

//   List<dynamic> toJson() {
//     return jobRoles;
//   }
// }

//above was original below is saved because of error
class JobRolesListResponse {
  final List<String> jobRoles;

  JobRolesListResponse({required this.jobRoles});

  factory JobRolesListResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>?;

    if (list == null) {
      throw Exception('jobRoles field is missing or null');
    }

    // Extract only the 'title' field from each job role object
    final roles = list.map((e) => e['title'] as String).toList();

    return JobRolesListResponse(jobRoles: roles);
  }

  Map<String, dynamic> toJson() {
    return {
      'jobRoles': jobRoles,
    };
  }
}
