import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import '../../../../ui_helper/ui_helper.dart';
import '../../../../widgets/widgets.dart';
import '../../../user_profile/presentation/views/User_messages_screen.dart';
import 'job_details_view.dart';
import 'Job_filters_Screen.dart';

class CompanyFilteredJobsScreen extends StatefulWidget {
  VoidCallback? onBack;
  CompanyFilteredJobsScreen({this.onBack});

  @override
  State<CompanyFilteredJobsScreen> createState() => _CompanyFilteredJobsState();
}

class _CompanyFilteredJobsState extends State<CompanyFilteredJobsScreen> {
  TextEditingController jobSearchController = TextEditingController();

  List<Map<String, dynamic>> vList = [
    {
      "job_title": "Digital Marketing Executive",
      "company_name": "Uber",
      "image":
          "https://static-00.iconduck.com/assets.00/uber-icon-1024x1024-4icncyyo.png",
      "location": "Mumbai",
      "experience": "1-2 years",
      "salary": "INR 3,00,000",
      "status": "Actively Hiring",
      "posted": "2 weeks ago",
    },
    {
      "job_title": "UX Designer",
      "company_name": "Uber",
      "image":
          "https://static-00.iconduck.com/assets.00/uber-icon-1024x1024-4icncyyo.png",
      "location": "Remote",
      "experience": "2-4 years",
      "salary": "INR 6,00,000",
      "status": "Actively Hiring",
      "posted": "2 week ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "LOGO",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  color: TColors.primary),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MessagesScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: SvgPicture.asset("assets/Icons/message_icon.svg"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: SvgPicture.asset("assets/Icons/notifications_icon.svg"),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Jobs",
                                style: mTextStyle32(mColor: Colors.black),
                              ),
                              Text(
                                  "Start applying to the latest job vacancies at the\nleading companies in India below.",
                                  style:
                                      mTextStyle14(mColor: Color(0xff6C7278))),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: 300,
                                      child: CustomTextField(
                                        controller: jobSearchController,
                                        hintText: "Search",
                                        suffixIcon: Icons.search,
                                      )),
                                  Spacer(),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    JobFiltersScreen()));
                                      },
                                      child: SvgPicture.asset(
                                          "assets/Icons/settings-sliders 1.svg"))
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                  child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: vList.length,
                                itemBuilder: (context, index) {
                                  final job = vList[index];
                                  return JobCard(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              JobDetailsScreen(
                                                  // job_id: 0,
                                                  ),
                                        ),
                                      );
                                    },
                                    imageUrl: job['image'],
                                    jobTitle: job['job_title'],
                                    company: job['company_name'],
                                    location: job['location'],
                                    experience: job['experience'],
                                    salary: job['salary'],
                                    status: job['status'],
                                    posted: job['posted'],
                                  );
                                },
                              ))
                            ],
                          )),
                    ]))));
  }
}

class JobCard extends StatelessWidget {
  final String imageUrl,
      jobTitle,
      company,
      location,
      experience,
      salary,
      status,
      posted;
  VoidCallback onTap;

  JobCard({
    required this.imageUrl,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.experience,
    required this.salary,
    required this.status,
    required this.posted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// First Row - Icon + Title + Company + Right Tags
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(imageUrl,
                      height: 48, width: 48, fit: BoxFit.cover),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(jobTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(company, style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    greyContainer(text: status, bgColor: TColors.secondary),
                    SizedBox(height: 6),
                    greyContainer(text: posted, bgColor: Color(0xffEFF0F6)),
                    SizedBox(height: 6),
                  ],
                )
              ],
            ),
            SizedBox(height: 12),
            // Second Row - Grey Containers aligned Left under the Icon
            Row(
              children: [
                greyContainer(text: location, bgColor: Color(0xffEFF0F6)),
                Spacer(),
                greyContainer(text: experience, bgColor: Color(0xffEFF0F6)),
                Spacer(),
                greyContainer(text: salary, bgColor: Color(0xffEFF0F6)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
