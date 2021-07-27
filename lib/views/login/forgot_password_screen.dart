import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/dialog.dart';
import 'package:flutter_application_1/components/rounded_button.dart';
import 'package:flutter_application_1/components/rounded_input_field.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/views/login/login_background.dart';
import 'package:flutter_application_1/views/login/reset_forgotten_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _email;
  bool _isSendingResetEmail = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return LoginBackground(children: [
      SizedBox(
        width: kCalculatedWidth(size),
        child: Text('Forgot Password',
            style: theme.textTheme.headline4.copyWith(color: Colors.white),
            textAlign: TextAlign.start),
      ),
      SizedBox(height: 10),
      RoundedInputField(
          key: Key('forgotEmail'),
          icon: Icons.email,
          hintText: 'Email',
          onChanged: (result) => _email = result,
          keyboardType: TextInputType.emailAddress),
      SizedBox(height: 10),
      RoundedButton(
          key: Key('sendResetEmail'),
          label: _isSendingResetEmail
              ? 'Sending Reset Email...'
              : 'Send Reset Email',
          onPressed: () async {
            if (_isSendingResetEmail) {
              return;
            }

            _setLoadingState(true);

            try {
              final result = await AuthService.forgotPassword(_email);
              await CommonDialogs.showInformationalDialog(
                  context, 'Forgotten Password', 'Request sent successfully.');

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ResetForgottenPasswordScreen(_email)));
            } catch (ex) {
              CommonDialogs.showInformationalDialog(
                  context, 'Account Error', ex.toString());
            }

            _setLoadingState(false);
          })
    ]);
  }

  void _setLoadingState(bool isLoading) {
    setState(() => _isSendingResetEmail = isLoading);
  }
}