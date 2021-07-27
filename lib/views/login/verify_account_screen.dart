import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/dialog.dart';
import 'package:flutter_application_1/components/rounded_button.dart';
import 'package:flutter_application_1/components/rounded_input_field.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/views/login/login_background.dart';
import 'package:flutter_application_1/views/main_screen.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String email;

  VerifyAccountScreen(this.email);

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState(email);
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  String _email;
  String _code;
  bool _isVerifying = false;

  _VerifyAccountScreenState(this._email);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return LoginBackground(children: [
      SizedBox(
        width: kCalculatedWidth(size),
        child: Text('Create Account',
            style: theme.textTheme.headline1.copyWith(color: Colors.white),
            textAlign: TextAlign.start),
      ),
      RoundedInputField(
          key: Key('inputCode'),
          icon: Icons.check_circle,
          hintText: 'Code',
          onChanged: (result) => _code = result,
          keyboardType: TextInputType.text),
      RoundedButton(
          key: Key('verifyAccount'),
          label: _isVerifying ? 'Verifying Account...' : 'Verify Account',
          onPressed: () async {
            if (_isVerifying) {
              return;
            }

            if (_code == null || _code.isEmpty) {
              CommonDialogs.showInformationalDialog(
                  context, 'Create Account Error', 'Please enter a code.');
              return;
            }

            _setLoadingState(true);

            try {
              final result = await AuthService.verify(_email, _code);
              await CommonDialogs.showInformationalDialog(
                  context, 'Create Account Success', result);

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false);
            } catch (ex) {
              CommonDialogs.showGenericErrorDialog(context,
                  content: ex.toString());
            }

            _setLoadingState(false);
          }),
      SizedBox(height: 10),
      RoundedButton(
          key: Key('resendCode'),
          label: 'Resend Code',
          // isPrimary: false,
          onPressed: () async => await AuthService.resendVerification(_email)
      )
    ]);
  }

  void _setLoadingState(bool isLoading) {
    setState(() => _isVerifying = isLoading);
  }
}
