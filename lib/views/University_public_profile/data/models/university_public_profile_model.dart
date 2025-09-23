import 'dart:convert';

class UniversityPublicProfileResponse {
  final PublicProfile publicProfile;
  final List<dynamic> activity;

  UniversityPublicProfileResponse({
    required this.publicProfile,
    required this.activity,
  });

  factory UniversityPublicProfileResponse.fromJson(Map<String, dynamic> json) {
    return UniversityPublicProfileResponse(
      publicProfile: PublicProfile.fromJson(json['publicProfile']),
      activity: json['activity'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publicProfile': publicProfile.toJson(),
      'activity': activity,
    };
  }
}

class PublicProfile {
  final int? id;
  final String? universityLogoUrl;
  final String? pincode;
  final String? profilePic;
  final String? collegeName;
  final String? address;
  final String? websiteLink;
  final String? about;
  final String? socialMediaLink;
  final User? user;
  final List<Course>? courses;

  PublicProfile({
    this.id,
    this.universityLogoUrl,
    this.pincode,
    this.profilePic,
    this.collegeName,
    this.address,
    this.websiteLink,
    this.about,
    this.socialMediaLink,
    this.user,
    this.courses,
  });

  factory PublicProfile.fromJson(Map<String, dynamic> json) {
    return PublicProfile(
      id: json['id'] as int?,
      universityLogoUrl: json['university_logo_url'] as String?,
      pincode: json['pincode'] as String?,
      profilePic: json['profile_pic'] as String?,
      collegeName: json['college_name'] as String?,
      address: json['address'] as String?,
      websiteLink: json['website_link'] as String?,
      about: json['about'] as String?,
      socialMediaLink: json['social_media_link'] as String?,
      user: json['User'] != null ? User.fromJson(json['User'] as Map<String, dynamic>) : null,
      courses: (json['courses'] as List?)?.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_logo_url': universityLogoUrl,
      'pincode': pincode,
      'profile_pic': profilePic,
      'college_name': collegeName,
      'address': address,
      'website_link': websiteLink,
      'about': about,
      'social_media_link': socialMediaLink,
      'User': user?.toJson(),
      'courses': courses?.map((e) => e.toJson()).toList(),
    };
  }
}

// Reuse existing classes:
class User {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? userRole;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.userRole,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      userRole: json['user_role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'user_role': userRole,
    };
  }
}

class Course {
  final int? id;
  final String? name;

  Course({this.id, this.name});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}