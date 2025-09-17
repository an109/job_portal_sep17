import 'package:flutter/material.dart';
import 'package:job_portal/UI_Helper/responsive_extensions.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/widgets/widgets.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class RecruiterCreateQuickTicket extends StatefulWidget {
  const RecruiterCreateQuickTicket({super.key});

  @override
  State<RecruiterCreateQuickTicket> createState() =>
      _RecruiterCreateQuickTicketState();
}

class _RecruiterCreateQuickTicketState
    extends State<RecruiterCreateQuickTicket> {
  int? selectedPriorityIndex; // 0 = Low, 1 = Medium, 2 = High
  final List<String> priorities = ['Low', 'Medium', 'High'];
  TextEditingController eController = TextEditingController();
  TextEditingController ticketController = TextEditingController(); // ADDED THIS

  @override
  Widget build(BuildContext context) {
    // Use responsive extensions
    final screenHeight = context.screenHeight;
    final screenWidth = context.screenWidth;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Support",
            style: TextStyle(
                fontSize: context.responsiveFontSize(baseSize: 21),
                fontWeight: FontWeight.w600
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.rw(6)), // Responsive padding
            child: Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView( // WRAP IN SingleChildScrollView TO PREVENT OVERFLOW
        padding: EdgeInsets.symmetric(
          horizontal: context.rw(6), // Responsive padding
          vertical: context.rh(2), // Responsive padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Quick Ticket",
              style: mTextStyle32(mColor: Colors.black),
            ),
            SizedBox(height: context.rh(2)), // Responsive spacing
            Text(
              "Write and address new queries and issues",
              style: mTextStyle12(),
            ),
            SizedBox(height: context.rh(3)), // Responsive spacing
            Text(
              "Customer Email",
              style: mTextStyle12(),
            ),
            SizedBox(height: context.rh(0.5)), // Responsive spacing
            CustomTextField(
              controller: eController,
              hintText: "amangupta@gmail.com",
              fillColor: Color(0xffFFF7FB),
            ),
            SizedBox(height: context.rh(3)), // Responsive spacing
            Text(
              "Ticket Priority",
              style: mTextStyle12(),
            ),
            SizedBox(height: context.rh(0.5)), // Responsive spacing
            Container(
              height: context.rh(6), // Responsive height
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(priorities.length, (index) {
                  return Row(
                    children: [
                      RoundCheckBox(
                        size: context.rw(6), // Responsive size
                        isChecked: selectedPriorityIndex == index,
                        onTap: (selected) {
                          setState(() {
                            selectedPriorityIndex = selected! ? index : null;
                          });
                        },
                      ),
                      SizedBox(width: context.rw(1.5)), // Responsive spacing
                      Text(
                        priorities[index],
                        style: mTextStyle12(),
                      ),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(height: context.rh(3)), // Responsive spacing
            Text(
              "Ticket Body",
              style: mTextStyle12(),
            ),
            SizedBox(height: context.rh(0.5)), // Responsive spacing
            Container(
              height: context.rh(20), // Responsive height for multi-line input
              child: CustomTextField(
                controller: ticketController,
                hintText: "Type your issue here...",
                fillColor: Color(0xffFFF7FB),

              ),
            ),
            SizedBox(height: context.rh(3)), // Responsive spacing
            Center(
              child: SizedBox(
                width: context.rw(40), // Responsive button width
                child: commonRedContainer(
                    text: "Submit",
                    onTap: () {}
                ),
              ),
            ),
            SizedBox(height: context.rh(2)), // Extra space at bottom
          ],
        ),
      ),
    );
  }
}