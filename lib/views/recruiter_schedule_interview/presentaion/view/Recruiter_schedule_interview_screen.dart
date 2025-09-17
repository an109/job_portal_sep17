import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/widgets/widgets.dart';

import '../../../recruiter_job_post/presentation/view/Recruiter_total_job_posts.dart';
import '../../domain/entities/recruiter_schedule_interview_entity.dart';
import '../bloc/recruiter_schedule_interview_bloc.dart';
import '../bloc/recruiter_schedule_interview_event.dart';
import '../bloc/recruiter_schedule_interview_state.dart';

class ScheduleInterviewPage extends StatefulWidget {
  final String candidateName;
  final int applicantId;

  const ScheduleInterviewPage({
    Key? key,
    required this.candidateName,
    required this.applicantId,
  }) : super(key: key);

  @override
  State<ScheduleInterviewPage> createState() => _ScheduleInterviewPageState();
}

class _ScheduleInterviewPageState extends State<ScheduleInterviewPage> {
  late String _interviewType;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _videoLinkController;

  @override
  void initState() {
    super.initState();
    _interviewType = 'Video call';
    _dateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _videoLinkController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _videoLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RecruiterScheduleInterviewBloc>(),
      child: Scaffold(
        appBar: buildCustomAppBar(titleText: "LOGO"),
        body: BlocConsumer<RecruiterScheduleInterviewBloc, RecruiterScheduleInterviewState>(
          listener: (context, state) {
            if (state is RecruiterScheduleInterviewSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(" Interview scheduled with ${widget.candidateName}!"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) Navigator.pop(context);
              });
            }
            if (state is RecruiterScheduleInterviewFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("❌ ${state.error}"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is RecruiterScheduleInterviewLoading) {
              return Center(child: CircularProgressIndicator());
            }

            // 👇 Your original UI — 100% unchanged
            return _buildUI(context);
          },
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Schedule Interview",
            style: mTextStyle32(mColor: Colors.black),
          ),
          SizedBox(height: 25),

          // To: Candidate Name
          Row(
            children: [
              Text("To: ", style: mTextStyle14(mFontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(widget.candidateName, style: mTextStyle14()),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Message Preview
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi ${widget.candidateName.split(' ').first},",
                  style: mTextStyle16(mFontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  "Can you please confirm your availability for the mentioned date and time? Let me know in case of reschedule.\n\nI am available at +91-9996222046 for any further clarification.\n\nThanks,\nRishabh",
                  style: mTextStyle14(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Interview Type
          Text("Interview type", style: mTextStyle14(mFontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              _radioButton('Video call', 'Video call'),
              _radioButton('Phone', 'Phone'),
              _radioButton('In-office', 'In-office'),
            ],
          ),
          const SizedBox(height: 20),

          // Interview Date
          Text("Interview date", style: mTextStyle14(mFontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _dateController,
            hintText: "dd/mm/yyyy",
            fillColor: Colors.white,
            suffixIcon: Icons.calendar_today,
            onSuffixTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (pickedDate != null) {
                setState(() {
                  _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                });
              }
            },
          ),
          const SizedBox(height: 20),

          // Interview Time
          Text("Interview time", style: mTextStyle14(mFontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _startTimeController,
                  hintText: "start time",
                  fillColor: Colors.white,
                  suffixIcon: Icons.access_time,
                  onSuffixTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _startTimeController.text =
                        "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text("To", style: mTextStyle14()),
              const SizedBox(width: 8),
              Expanded(
                child: CustomTextField(
                  controller: _endTimeController,
                  hintText: "end time",
                  fillColor: Colors.white,
                  suffixIcon: Icons.access_time,
                  onSuffixTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _endTimeController.text =
                        "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Video Call Link
          if (_interviewType == 'Video call') ...[
            Text("Share video call link", style: mTextStyle14(mFontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _videoLinkController,
              hintText: "e.g. https://meet.google.com/uwv-ulva-uv  ",
              fillColor: Colors.white,
            ),
            const SizedBox(height: 20),
          ],

          // Schedule Button
          Align(
            alignment: Alignment.center,
            child: Transform.scale(
              scale: 1.4,
              child: ViewAppContainer(
                title: "Schedule Interview",
                bgColor: Colors.redAccent,
                textColor: Colors.white,
                onTap: _scheduleInterview,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scheduleInterview() {
    if (_dateController.text.isEmpty) {
      _showError("Please select an interview date.");
      return;
    }

    if (_startTimeController.text.isEmpty || _endTimeController.text.isEmpty) {
      _showError("Please select both start and end time.");
      return;
    }

    if (_interviewType == 'Video call' && _videoLinkController.text.trim().isEmpty) {
      _showError("Please enter a video call link for video interviews.");
      return;
    }

    // Format date: dd/mm/yyyy → yyyy-mm-dd
    final parts = _dateController.text.split('/');
    if (parts.length != 3) {
      _showError("Invalid date format.");
      return;
    }
    final day = parts[0];
    final month = parts[1];
    final year = parts[2];
    final formattedDate = '$year-$month-$day';

    // Map UI value to backend expected value
    String interviewTypeValue;
    switch (_interviewType) {
      case 'Video call':
        interviewTypeValue = 'videocall';
        break;
      case 'Phone':
        interviewTypeValue = 'phone';
        break;
      case 'In-office':
        interviewTypeValue = 'inoffice';
        break;
      default:
        interviewTypeValue = 'videocall';
    }

    final entity = RecruiterScheduleInterviewEntity(
      message: "Hi ${widget.candidateName.split(' ').first},\n\nCan you please confirm your availability for the mentioned date and time? Let me know in case of reschedule.\n\nI am available at +91-9996222046 for any further clarification.\n\nThanks,\nRishabh",
      interviewType: interviewTypeValue,
      interviewDate: formattedDate,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
      videoLink: _interviewType == 'Video call' ? _videoLinkController.text.trim() : null,
    );

    context.read<RecruiterScheduleInterviewBloc>().add(
      ScheduleInterviewRequested(
        applicantId: widget.applicantId,
        entity: entity,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("❌ $message"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _radioButton(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: _interviewType,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _interviewType = newValue;
              });
            }
          },
          activeColor: AppColors.blueTextColor,
        ),
        Text(label, style: mTextStyle14()),
      ],
    );
  }
}