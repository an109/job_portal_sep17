import 'package:job_portal/views/job_related/domain/entities/job_details_entity.dart';

class JobDetailsResponseModel extends JobDetailsEntity {
        JobDetailsResponseModel.fromJson(Map<String, dynamic> json)
            : super(
                job_id: int.parse((json['job_id'] ?? '0').toString()),
                opportunity_type: json['opportunity_type'],
                has_applied: json['has_applied'] ?? false,
                job_type: json['job_type'] ?? '',
                jobProfile: json['job_role'] ?? '', // <-- Added fallback
                job_description: json['job_description'] ?? '',
                job_time: json['job_time'] ?? '',
                days_in_office: json['days_in_office'],
                cityChoice: (json['eligible_cities'] as List<dynamic>?)
                    ?.map((e) => e['name'].toString())
                    .toList(),

                skillsRequired: List<String>.from(json['skillsRequired'] ?? []),
                skill_required_note: json['skill_required_note'] ?? '',
                candidate_preferences: json['candidate_preferences'] ?? '',
                women_preferred: json['women_preferred'],
                company_name: json['company_name'] ?? '', // <-- Added fallback for safety
                logo_url: json['logo_url'],
                aboutCompany: json['aboutCompany'] ?? '', // <-- Added fallback for safety
                companyIndustry: json['companyIndustry'] ?? '', // <-- Added fallback for safety
                companyLocation: json['companyLocation'] ?? '', // <-- Added fallback for safety
                recruiter_name: json['recruiter_name'] ?? '', // <-- Added fallback for safety
                recruiter_email: json['recruiter_email'] ?? '', // <-- Added fallback for safety
                recruiter_phone: json['recruiter_phone'] ?? '', // <-- Added fallback for safety
                recruiterDesignation: (json['recruiterDesignation'] ?? 0).toString(), //  Convert int to String                recruiterProfilePic: json['recruiterprofile_pic'],
                is_email_verified: json['is_email_verified'] ?? false, // <-- Added fallback
                is_phone_verified: json['is_phone_verified'] ?? false, // <-- Added fallback
                is_gst_verified: json['is_gst_verified'] ?? false, // <-- Added fallback
                number_of_openings: json['number_of_openings'],
                hiringStatus: json['hiringStatus'] ?? '', // <-- Added fallback for safety
                hiring_preferences: json['hiring_preferences'] ?? '',
                languages_known: json['languages_known'] ?? '',
                salary: json['salary'] ?? '',
                stipend_type: json['stipend_type'] ?? '',
                incentive_per_year: json['incentive_per_year'] ?? '', // <-- Added fallback for safety
                perks: List<String>.from(json['perks'] ?? []),
                internshipDuration: json['internshipDuration'] ?? '',
                internship_start_date: json['internship_start_date'] ?? '', // <-- Added fallback for safety
                internship_from_date: json['internship_from_date'],
                internship_to_date: json['internship_to_date'],
                is_custom_internship_date: json['is_custom_internship_date'] ?? false, // <-- Added fallback
                college_name: json['college_name'] ?? '',
                course: json['course'] ?? '',
                phone_contact: json['phone_contact'] ?? '',
                alternate_phone_number: json['alternate_phone_number'] ?? '',
                screening_questions: List<String>.from(json['screening_questions'] ?? []),
                numberOfApplicants: json['number_of_applicants'] ?? 0, // <-- Added fallback
                postedDaysAgo: json['posted_days_ago'] ?? '', // <-- Added fallback for safety
        );
}