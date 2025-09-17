import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/terms_and_conditions_bloc/terms_and_conditions_bloc.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/terms_and_conditions_bloc/terms_and_conditions_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/terms_and_conditions_bloc/terms_and_conditions_state.dart';
import '../../../../ui_helper/ui_helper.dart';

class UserTermsAndConditionsScreen extends StatefulWidget {
  const UserTermsAndConditionsScreen({super.key});

  @override
  State<UserTermsAndConditionsScreen> createState() =>
      _UserTermsAndConditionsScreenState();
}

class _UserTermsAndConditionsScreenState
    extends State<UserTermsAndConditionsScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final bloc = context.read<TermsAndConditionsBloc>();

    bloc.add(const LoadTnC());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<TermsAndConditionsBloc, TermsAndConditionsState>(
        builder: (context, state) {
          if (state is TnCLoaded) {
            final data = state.termsAndConditionEntity;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 11.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Terms & Conditions",
                    style: mTextStyle32(mColor: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Text(data.terms_and_condition),
                  ),
                ],
              ),
            );
          } else if (state is TnCLoading) {
            return const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Tnc Loading'),
                ],
              ),
            );
          } else if (state is TnCError) {
            return const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Tnc Error'),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  Text('Unhandeled state : Tnc state : $state')
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
