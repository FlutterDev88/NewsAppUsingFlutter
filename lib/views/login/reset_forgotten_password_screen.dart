import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/dialog.dart';
import 'package:flutter_application_1/components/rounded_button.dart';
import 'package:flutter_application_1/components/rounded_input_field.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/views/login/login_background.dart';

class ResetForgottenPasswordScreen extends StatefulWidget {
  final String _email;

  const ResetForgottenPasswordScreen(this._email);

  @override
  _ResetForgottenPasswordScreenState createState() =>
      _ResetForgottenPasswordScreenState(_email);
}

class _ResetForgottenPasswordScreenState
    extends State<ResetForgottenPasswordScreen> {
  final String _email;
  String _code;
  String _password;
  String _confirmPassword;
  bool _isChangingPassword = false;

  _ResetForgottenPasswordScreenState(this._email);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return LoginBackground(children: [
      SizedBox(
        width: kCalculatedWidth(size),
        child: Text('Reset Password',
            style: theme.textTheme.headline1.copyWith(color: Colors.white),
            textAlign: TextAlign.start),
      ),
      SizedBox(height: 10),
      RoundedInputField(
          key: Key('resetCode'),
          icon: Icons.check_circle,
          hintText: 'Code',
          onChanged: (result) => _code = result,
          keyboardType: TextInputType.text),
      RoundedInputField(
          key: Key('resetPassword'),
          icon: Icons.lock,
          hintText: 'Password',
          isTextObscured: true,
          onChanged: (result) => _password = result),
      RoundedInputField(
          key: Key('resetConfirm'),
          icon: Icons.lock,
          hintText: 'Confirm Password',
          isTextObscured: true,
          onChanged: (result) => _confirmPassword = result),
      SizedBox(height: 10),
      RoundedButton(
          key: Key('changePassword'),
          label:
              _isChangingPassword ? 'Changing Password...' : 'Change Password',
          onPressed: () async {
            if (_isChangingPassword) {
              return;
            }

            if (_code == null ||
                _code.isEmpty ||
                _password == null ||
                _password.isEmpty ||
                _confirmPassword == null ||
                _confirmPassword.isEmpty) {
              CommonDialogs.showInformationalDialog(
                  context, 'Reset Error', 'Please fill in all fields.');
              return;
            }

            if (_password != _confirmPassword) {
              CommonDialogs.showInformationalDialog(context, 'Reset Error',
                  'Please ensure your passwords match.');
              return;
            }

            _setLoadingState(true);

            try {
              final result = await AuthService.resetForgottenPassword(
                  _email, _code, _password);
              await CommonDialogs.showInformationalDialog(
                  context, 'Password Reset', result);
              _resetNavigationToLoginScreen();
            } catch (ex) {
              CommonDialogs.showGenericErrorDialog(context,
                  content: ex.toString());
            }

            _setLoadingState(false);
          }),
      RoundedButton(
        label: 'Account Sign In',
        // isPrimary: false,
        onPressed: () => _resetNavigationToLoginScreen(),
      )
    ]);
  }

  void _resetNavigationToLoginScreen() {
    //temp
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => MainScreen()),
    //     (Route<dynamic> route) => false);
  }

  void _setLoadingState(bool isLoading) {
    setState(() => _isChangingPassword = isLoading);
  }
}
