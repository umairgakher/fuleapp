// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Acceptance of Terms',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'By accessing and using this fuel app, you agree to comply with and be bound by the following terms and conditions.',
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Use of the App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '2.1. The fuel app is provided for informational purposes only. It does not constitute professional advice or recommendations.',
            ),
            Text(
              '2.2. You must use the app responsibly and in accordance with applicable laws and regulations.',
            ),
            Text(
              '2.3. Any reliance on the information provided by the app is at your own risk.',
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Privacy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '3.1. We respect your privacy and handle your personal information in accordance with our Privacy Policy. By using the app, you consent to the collection and use of your personal information as described in the Privacy Policy.',
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Intellectual Property',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '4.1. All content and materials available in the app, including but not limited to text, graphics, logos, images, and software, are the property of the app owner and are protected by applicable intellectual property laws.',
            ),
            Text(
              '4.2. You may not modify, reproduce, distribute, or create derivative works based on the app\'s content without prior written consent from the app owner.',
            ),
            SizedBox(height: 16.0),
            Text(
              '5. Limitation of Liability',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '5.1. The app owner shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising out of or in connection with your use of the app.',
            ),
            Text(
              '5.2. The app owner does not guarantee the accuracy, completeness, or reliability of the app\'s content.',
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Modifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '6.1. The app owner reserves the right to modify or update these terms and conditions at any time without prior notice.',
            ),
            Text(
              '6.2. It is your responsibility to review the terms and conditions periodically for any changes.',
            ),
          ],
        ),
      ),
    );
  }
}
