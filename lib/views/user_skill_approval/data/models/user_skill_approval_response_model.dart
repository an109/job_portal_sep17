// user_skill_approval_response_model.dart
class UserSkillApprovalResponseModel {
  final int id;
  final List<SkillModel> skills;

  UserSkillApprovalResponseModel({required this.id, required this.skills});

  factory UserSkillApprovalResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> skillList = json['skills'] ?? [];
    final skills = skillList
        .map((e) => SkillModel.fromJson(e))
        .toList();

    return UserSkillApprovalResponseModel(
      id: json['id'],
      skills: skills,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skills': skills.map((e) => e.toJson()).toList(),
    };
  }
}

class AuthorityModel {
  final int id;
  final String name;
  final String? logoUrl;

  AuthorityModel({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  factory AuthorityModel.fromJson(Map<String, dynamic> json) {
    return AuthorityModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logoUrl: json['logo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
    };
  }
}

class SkillModel {
  final String domain;
  final List<String> subSkills;
  final List<AuthorityModel> authority;
  final List<int> authorityIds;
  final List<String> certificateImage;

  SkillModel({
    required this.domain,
    required this.subSkills,
    required this.authority,
    required this.authorityIds,
    required this.certificateImage,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      domain: json['domain'] ?? '',
      subSkills: List<String>.from(json['subSkills'] ?? []),
      authority: (json['authority'] as List<dynamic>? ?? [])
          .map((e) => AuthorityModel.fromJson(e))
          .toList(),
      authorityIds: List<int>.from(json['authority_ids'] ?? []),
      certificateImage: List<String>.from(json['certificate_image'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domain': domain,
      'subSkills': subSkills,
      'authority': authority.map((a) => a.toJson()).toList(),
      'authority_ids': authorityIds,
      'certificate_image': certificateImage,
    };
  }
}