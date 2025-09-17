import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_portal/utils/constants/image_string.dart';
import 'package:job_portal/widgets/widgets.dart';
import '../../../../ui_helper/ui_helper.dart';

class ChooseYourTemplateScreen extends StatefulWidget {
  const ChooseYourTemplateScreen({super.key});

  @override
  State<ChooseYourTemplateScreen> createState() =>
      _ChooseYourTemplateScreenState();
}

class _ChooseYourTemplateScreenState extends State<ChooseYourTemplateScreen> {
  List<Map<String, dynamic>> mTemplates = [
    {
      "S.no": "1",
      "Title": "Template-1",
      'resume': ImageString.resume1Png,
      // 'resume': ImageString.resume1,
    },
    {
      "S.no": "2",
      "Title": "Template-2",
      'resume': ImageString.resume1Png,
      // 'resume': ImageString.resume1,
    },
    {
      "S.no": "3",
      "Title": "Template-3",
      // 'resume': ImageString.resume3,
      'resume': ImageString.resume3Png,
    },
    {
      "S.no": "4",
      "Title": "Template-4",
      'resume': ImageString.resume4Png,
      // 'resume': ImageString.resume4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {},
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose Resume template",
                style: mTextStyle32(mColor: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 160 / 230,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  shrinkWrap: true,
                  itemCount: mTemplates.length,
                  itemBuilder: (_, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0, color: Colors.grey),
                        ),
                        child: Image.asset(
                          mTemplates[index]['resume'],
                          fit: BoxFit
                              .cover, // Makes the image cover the container
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        // child: SvgPicture.asset(mTemplates[index]['resume']),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: nextButton(
                  title: "Download",
                  onTap: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
