import 'package:craftworks_app/widgets/user_type_widget.dart';
import 'package:flutter/material.dart';

class ChooseUserTypeView extends StatefulWidget {
  const ChooseUserTypeView({super.key});

  @override
  State<ChooseUserTypeView> createState() => _ChooseUserTypeViewState();
}

class _ChooseUserTypeViewState extends State<ChooseUserTypeView> {
  String selectedRole = 'craftworker';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserTypeWidget(
              title: 'craftworker',
              subTitle: 'I am seeking for a job',
              icon: Icons.person,
              value: 'craftworker',
              selectedRole: selectedRole,
              onTap: () => setState(() => selectedRole = 'craftworker'),
            ),
            const SizedBox(width: 16),
            UserTypeWidget(
              title: 'Client',
              subTitle: 'I want to find a craftworker',
              icon: Icons.business_center,
              value: 'client',
              selectedRole: selectedRole,
              onTap: () => setState(() => selectedRole = 'client'),
            ),
          ],
        ),
      ),
    );
  }
}
