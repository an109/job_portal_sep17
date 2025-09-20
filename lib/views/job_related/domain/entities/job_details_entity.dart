class JobDetailsEntity {
  final int? job_id;
  final String opportunity_type;
  final String? job_type;
  final String? jobProfile;
  final String? job_description;
  final String? job_time;
  final int? days_in_office;
  final List<String>? cityChoice;
  final List<String> skillsRequired;
  final String? skill_required_note;
  final String? candidate_preferences;
  final bool? women_preferred;
  final String company_name;
  final String? logo_url;
  final String aboutCompany;
  final String companyIndustry;
  final String companyLocation;
  final String recruiter_name;
  final String recruiter_email;
  final String recruiter_phone;
  final String recruiterDesignation;
  final String? recruiterProfilePic;
  final bool is_email_verified;
  final bool is_phone_verified;
  final bool is_gst_verified;
  final int? number_of_openings;
  final String hiringStatus;
  final String? hiring_preferences;
  final String? languages_known;
  final String? salary; // <-- Made nullable
  final String? stipend_type; // <-- Made nullable
  final String incentive_per_year;
  final List<String> perks;
  final String? internshipDuration; // <-- Made nullable
  final String internship_start_date;
  final String? internship_from_date;
  final String? internship_to_date;
  final bool is_custom_internship_date;
  final String? college_name; // <-- Made nullable
  final String? course; // <-- Made nullable
  final String? phone_contact; // <-- Made nullable
  final String? alternate_phone_number; // <-- Made nullable
  final List<String> screening_questions;
  final int numberOfApplicants;
  final String postedDaysAgo;
  final bool has_applied;

  JobDetailsEntity({
    required this.job_id,
    required this.opportunity_type,
    this.job_type, // <-- No longer required
    this.jobProfile, // <-- No longer required
    this.job_description, // <-- No longer required
    this.job_time, // <-- No longer required
    this.days_in_office,
    this.cityChoice,
    required this.skillsRequired,
    this.skill_required_note, // <-- No longer required
    this.candidate_preferences, // <-- No longer required
    this.women_preferred,
    required this.company_name,
    this.logo_url,
    required this.aboutCompany,
    required this.companyIndustry,
    required this.companyLocation,
    required this.recruiter_name,
    required this.recruiter_email,
    required this.recruiter_phone,
    required this.recruiterDesignation,
    this.recruiterProfilePic,
    required this.is_email_verified,
    required this.is_phone_verified,
    required this.is_gst_verified,
    this.number_of_openings,
    required this.hiringStatus,
    this.hiring_preferences,
    this.languages_known,
    this.salary,
    this.stipend_type,
    required this.incentive_per_year,
    required this.perks,
    this.internshipDuration,
    required this.internship_start_date,
    this.internship_from_date,
    this.internship_to_date,
    required this.is_custom_internship_date,
    this.college_name,
    this.course,
    this.phone_contact,
    this.alternate_phone_number,
    required this.screening_questions,
    required this.numberOfApplicants,
    required this.postedDaysAgo,
    required this.has_applied,
  });
}
