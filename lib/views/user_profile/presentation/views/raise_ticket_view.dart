import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';
import 'package:job_portal/utils/theme/custom_themes/color_theme.dart';
import 'package:job_portal/views/user_profile/domain/entities/public_profile_entity.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/raise_ticket_bloc/raise_ticket_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/raise_ticket_bloc/raise_ticket_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/raise_ticket_bloc/raise_ticket_state.dart';
import 'package:job_portal/widgets/widgets.dart';

class RaiseTicketView extends StatefulWidget {
  final PublicProfileEntity userProfile;
  const RaiseTicketView({super.key, required this.userProfile});

  @override
  State<RaiseTicketView> createState() => _RaiseTicketViewState();
}

class _RaiseTicketViewState extends State<RaiseTicketView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController ticketSubjectController = TextEditingController();
  TextEditingController ticketBodyController = TextEditingController();
  String _priority = 'Medium';

  Map<String, dynamic> createParams() {
    final _prefs = sl<PreferencesManager>();
    final user_id = _prefs.getUserId();

    final curr = widget.userProfile;
    final map = {
      "user_id": user_id ?? '6',
      "name": curr.first_name + curr.last_name,
      "email": curr.email,
      // "role": curr.user_type,
      "role": 'STUDENT',
      "issue_title": ticketSubjectController.text.trim(),
      "issue_detail": ticketBodyController.text.trim(),
      "priority": _priority.toUpperCase()
    };

    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Support',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Create quick ticket.',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Write and address new queries and issues',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: TColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Customer Email',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: TColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  Text(
                    widget.userProfile.email,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: TColors.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Ticket Priority',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: TColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPriorityOption("High"),
                    _buildPriorityOption("Medium"),
                    _buildPriorityOption("Low"),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Ticket Subject',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: TColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: ticketSubjectController,
                hintText: 'Type subject here',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Subject is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              Text(
                'Ticket Body',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: TColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: ticketBodyController,
                hintText: 'Type issue here',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Body cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              BlocListener<RaiseTicketBloc, RaiseTicketState>(
                listener: (context, state) {
                  if (state is RaiseATicketLoaded) {
                    final data = state.raiseTicketEntity;
                    showSnackbar(data.message!, context);
                    Navigator.pop(context);
                  } else if (state is RaiseATicketLoading) {
                    developer.log('raise ticket loading.');
                  } else if (state is RaiseATicketError) {
                    developer.log('raise ticket error.');
                  }
                },
                child: SizedBox(),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width *
                          0.9, // max 90% of screen
                    ),
                    child: SizedBox(
                      width: 10000,
                      child: nextButton(
                        title: 'Submit',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            developer.log('Valid form');
                            final data = createParams();
                            context
                                .read<RaiseTicketBloc>()
                                .add(RaiseATicket(data));
                          } else {
                            developer.log('Invalid form');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityOption(String label) {
    final isSelected = _priority == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _priority = label;
        });
      },
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                width: 2,
              ),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            // style: const TextStyle(
            //   fontSize: 16,
            //   color: Colors.black,
            // ),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                // color: TColors.textSecondary,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
        ],
      ),
    );
  }
}
