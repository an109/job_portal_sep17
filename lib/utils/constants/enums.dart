// ignore_for_file: constant_identifier_names

enum USERTYPE {
  STUDENT,
  COMPANY,
  UNIVERSITY,
}

enum JOBSEEKERTYPE {
  SchoolStudent,
  CollegeStudent,
  Fresher,
  WorkingProffesional,
}

enum DETAILEDPROFILEPARAMS {
  user_id,
  email,
  first_name,
  last_name,
  phone,
  dob,
  city,
  jobLocation,
  gender,
  languages,
  user_type,

  // school student
  educationStandard,

  // college student / fresher
  course,
  college_name,
  specialization,
  start_year,
  end_year,

  // Working professionals
  experiences,
  company_recruiter_profile_id,
  jobRole,
  company,
  start_date,
  end_date,
  description,

  // preference page
  currently_looking_for,
  work_mode,

  // verification info
  about_us,
  career_objective,
  resume,
  is_email_verified,
  is_phone_verified,
  is_gst_verified,
  user_profile_pic,
  aadhaarNumber,
  aadhaarCardFile,
  isAadhaarVerified,
}

// Map<String, dynamic> payload = {
//   "user_id": 58,
//   "first_name": "Megha",
//   "last_name": "Gupta",
//   "email": "a@gmail.com",
//   "phone": "58798598",
//   "dob": "1990-01-01",
//   "city": "Delhi",
//   "gender": "Female",
//   "user_type": "Working Professional",
//   "jobLocation": "San Francisco",
//   "experiences": [
//     {
//       "user_id": 57,
//       "company_recruiter_profile_id": "4",
//       "jobRole": "Software Engineer",
//       "company": "OriginCore",
//       "start_date": "2022-01-01",
//       "end_date": "2023-01-01",
//       "description": "Worked on backend development"
//     }
//   ],
//   "salary_details": "100000",
//   "currently_looking_for": "job",
//   "work_mode": "Remote"
// };
// submit detailed profile params
// enum DETAILEDPROFILEPARAMS {
//   user_id,
//   first_name,
//   last_name,
//   email,
//   phone,
//   dob,
//   city,
//   gender,
//   languages,
//   user_type,
//   jobLocation,
//   experiences,
//   company_recruiter_profile_id,
//   jobRole,
//   company,
//   start_date,
//   end_date,
//   description,
//   salary_details,
//   currently_looking_for,
//   work_mode,
// }
