import 'package:craftworks_app/widgets/craftsmanOptions.dart';
import 'package:flutter/material.dart';

class CraftsmanStartOptionsView extends StatefulWidget {
  const CraftsmanStartOptionsView({super.key});

  @override
  State<CraftsmanStartOptionsView> createState() =>
      _CraftsmanStartOptionsViewState();
}

class _CraftsmanStartOptionsViewState extends State<CraftsmanStartOptionsView> {
  String selectedOption = 'Add post';

  void _handleStart() {
    if (selectedOption == 'Add post') {
      Navigator.pushNamed(context, '/post-skills');
    } else if (selectedOption == 'View posts') {
      Navigator.pushNamed(context, '/craftsman_categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(" How do you want to start?")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CraftsmanOptions(
                  title: 'Add post',
                  subTitle: 'I want to add a job post',
                  icon: Icons.add_circle_outline,
                  value: 'Add post',
                  selectedOption: selectedOption,
                  onTap: () => setState(() => selectedOption = 'Add post'),
                ),
                const SizedBox(width: 16),
                CraftsmanOptions(
                  title: 'View posts',
                  subTitle: 'I want to view job posts',
                  icon: Icons.visibility_outlined,
                  value: 'View posts',
                  selectedOption: selectedOption,
                  onTap: () => setState(() => selectedOption = 'View posts'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _handleStart,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
