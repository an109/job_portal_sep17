// base url and other const data

class Urls {
  // static const baseurlIP = "https://leafyscape.com/";
  static const baseurlIP = "http://bvrcrafts.com:5000/";
  static String placeHolderImage = 'assets/Images/placeholder_image.jpg';
  static const baseUrl = "${baseurlIP}api/";

  static const userRegisteration = "users/register";
  static const userLogin = "users/login";
  static const sendOtpEmail = "otp/send-otp";
  static const sendOtpMobile = "mobileotp/sendotp";
  static const verifyOtpEmail = "otp/verify-otp";
  static const verifyOtpMobile = "mobileotp/verifyotp";
  static const getUserBasicInfo = "users/getUserData";
  static const getColleges = "master/school-college";
  static const getSpecialization = "master/specialization/course/{course_id}";
  static const getCourses = "master/courses";
  static const getDomainAll = "domain/all";
  static const getSubSkills = "skills/by-domain";
  static const getJobRoles = "master/job-roles";
  static const submitDetailedUserProfile = "user-details/detail";
  static const submitSkillsAndCertificates = "upload-skill";
  static const getInternshipFormMetadata = "internship-filters";
  static const createJobPost = "jobpost/create";
  static const opportunities = "opportunities";
  static const jobDetails = "jobdetails/";
  static const getLocations = "master/location";
  static const getFeedPosts = "feed/posts";
  static const getPublicProfile = "user-details/public-profile/";
  static const getUserDetails = "user-details/detail/";
  static const getTermsAndConditions = "user-details/getterms_and_condition";
  static const updateUserDetailsById = "user-details/detail/"; //
  static const changeUserEmail = "users/changeEmail";
  static const feedPostLike1 = "feed/posts/";
  static const feedPostLike2 = "/like";
  static const feedPostComment1 = "feed/posts/";
  static const feedPostComment2 = "/comment";
  static const applyForJob = "jobpost/apply/{job_id}";
  static const uploadFileGetUrl = "upload-image";
  static const createFeedPost = "feed/feed";
  static const getJobApplications = "user/applications";
  static const getFollowers = "feed/{id}/followers";
  static const getFollowing = "feed/{id}/following";
  static const raiseTicket = "tickets/raise";
  static const forgotPassword = "users/forgotPassword";
  static const changePassword = "users/changePassword";
  static const resetPasswordWithOTP = "users/resetPasswordWithOtp";

  static const String getUniFollowers = 'feed/{user_id}/followers';
  static const String getUniFollowing = 'feed/{user_id}/following';

  // Job Posts
  static const String getJobPostsList = "jobpost/list";
  static const String getTotalJobPostCount = "jobpost/totalcount";

  static const String getApplicantsForJob =
      "jobpost/{jobPostId}/allapplicant"; //

  static const String totalJobPost = "company-recruiter/jobpost/list";

  static const String getAllApplicantsCount = "jobpost/11/applicantCount";

  static const String totalJobCount = "jobpost/totalcount";

  static const String getFullApplicantDetails =
      'jobpost/{jobId}/applicant/{applicantId}';

  static const String scheduleInterview = "interview-invitations/{applicantId}";

  static const String getDashboardStats = "company-recruiter/dashboardStats";

  static const String getViewPendingTask = "pendingtask/grouped";

  static const String getUpcomingInterviews = "interview-invitations/upcoming/all";

  static const String getPipelineCandidates = "company-recruiter/candidates";

  static const String sendAssignment = "assignments/{applicantId}";

  // Master All Data

  static const String getMasterAllData = "master/all";

  static const String registerCompany = "company-recruiter/profile";

  static const String registerUniversity = "universitydetail";

  static const String updateRecruiterProfile = "company-recruiter/profile";

  static const String unipublicprofile = "university/{user_id}";

  static const String placeHolderImagePath = 'assets/Images/placeholder_image.jpg';

  static String getFullImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) {
      return placeHolderImage;
    }
    if (relativePath.startsWith('http://') || relativePath.startsWith('https://')) {
      if (relativePath.contains('example.com') || relativePath.contains('dummyimage.com')) {
        return placeHolderImage;
      }
      return relativePath;
    }
    // Handle local device paths (Android/iOS cache)
    if (relativePath.startsWith('/data/') ||
        relativePath.startsWith('/storage/') ||
        relativePath.startsWith('file://') ||
        relativePath.contains('com.example.job_portal')) {
     print('Local file path detected, returning null (placeholder): $relativePath');
      return placeHolderImage; // Will show placeholder
    }
    String cleanPath = relativePath.startsWith('/')
        ? relativePath.substring(1)
        : relativePath;
    return '$baseUrl$relativePath';
  }

}

