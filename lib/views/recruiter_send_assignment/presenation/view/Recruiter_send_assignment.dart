import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/ui_helper/ui_helper.dart';
import 'package:job_portal/widgets/widgets.dart';
import 'package:path_provider/path_provider.dart'; //  Added for temp file handling

import '../../domain/entities/recruiter_send_assignment_entity.dart';
import '../bloc/recruiter_send_assignment_bloc.dart';
import '../bloc/recruiter_send_assignment_event.dart';
import '../bloc/recruiter_send_assignment_state.dart';

class SendAssignmentPage extends StatefulWidget {
  final String candidateName;
  final int applicantId;

  const SendAssignmentPage({
    Key? key,
    required this.candidateName,
    required this.applicantId,
  }) : super(key: key);

  @override
  State<SendAssignmentPage> createState() => _SendAssignmentPageState();
}

class _SendAssignmentPageState extends State<SendAssignmentPage> {
  final TextEditingController messageController = TextEditingController(
    text: "Thank you for your interest in our internship opening. As a next step, we are expecting you to complete a short assignment.\n\nThanks,\nMansi",
  );
  final TextEditingController deadlineController = TextEditingController();

  DateTime? selectedDate;
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    // Initialize BLoC
    Future.microtask(() {
      context.read<RecruiterSendAssignmentBloc>();
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        deadlineController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // ✅ Updated _pickFile to handle file properly across platforms
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'zip', 'jpg', 'jpeg', 'png', 'gif', 'bmp', 'xls', 'xlsx'],
    );

    if (result == null) return; // User canceled

    final filePath = result.files.single.path;
    if (filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" Could not retrieve the file path.")),
      );
      return;
    }

    final file = File(filePath);
    final sizeInMB = file.lengthSync() / (1024 * 1024);

    if (sizeInMB > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" File size must be under 5 MB")),
      );
      return;
    }

    // ✅ Copy file to temporary directory for reliable access
    final tempDir = await getTemporaryDirectory();
    final extension = result.files.single.extension ?? 'bin';
    final tempFile = File('${tempDir.path}/assignment.$extension');
    final copiedFile = await file.copy(tempFile.path);

    setState(() {
      _selectedFile = copiedFile;
    });
  }

  void _sendAssignment() {
    if (messageController.text.trim().isEmpty) {
      _showError("Please enter a message.");
      return;
    }
    if (deadlineController.text.isEmpty) {
      _showError("Please select a deadline.");
      return;
    }
    if (_selectedFile == null) {
      _showError("Please upload an assignment file.");
      return;
    }

    final entity = RecruiterSendAssignmentEntity(
      message: messageController.text,
      deadline: deadlineController.text,
      assignmentFile: _selectedFile!,
    );

    context.read<RecruiterSendAssignmentBloc>().add(
      SendAssignmentRequested(
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RecruiterSendAssignmentBloc>(),
      child: BlocConsumer<RecruiterSendAssignmentBloc, RecruiterSendAssignmentState>(
        listener: (context, state) {
          if (state is RecruiterSendAssignmentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("✅ Assignment sent successfully!"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Future.delayed(Duration(seconds: 1), () {
              if (mounted) Navigator.pop(context);
            });
          }
          if (state is RecruiterSendAssignmentFailed) {
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
          if (state is RecruiterSendAssignmentLoading) {
            return Scaffold(
              appBar: buildCustomAppBar(titleText: "LOGO"),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Sending assignment...",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            appBar: buildCustomAppBar(titleText: "LOGO"),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Send Assignment",
                      style: mTextStyle32(mColor: Colors.black),
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text("To:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.candidateName,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Message Box
                    TextFormField(
                      controller: messageController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: "Enter your message",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Attachment link
                    InkWell(
                      onTap: _pickFile,
                      child: Text(
                        _selectedFile == null
                            ? "+ Attachment"
                            : "📎 ${_selectedFile!.path.split('/').last}",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Maximum file size 5 MB\nOnly jpeg, jpg, png, gif, bmp, pdf, zip, xls, doc allowed",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Submission deadline",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    SizedBox(height: 8),

                    // Deadline picker
                    TextFormField(
                      controller: deadlineController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        hintText: "dd/mm/yyyy",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today_outlined),
                          onPressed: () => _selectDate(context),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 50),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendAssignment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "Send Assignment",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}