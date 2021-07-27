import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/user_bloc.dart';
import 'package:flutter_application_1/components/rounded_button.dart';
import 'package:flutter_application_1/components/rounded_input_field.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/asset_image_paths.dart';
import 'package:flutter_application_1/views/login/create_account_screen.dart';
import 'package:flutter_application_1/views/login/forgot_password_screen.dart';
import 'package:flutter_application_1/views/login/login_background.dart';
import 'package:flutter_application_1/views/main_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;
  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserBloc>(context, listen: false);

    var emailTextController;
    if (userProvider.email != null &&
        userProvider.email.isNotEmpty &&
        _email == null) {
      emailTextController = TextEditingController(text: userProvider.email);
      _email = userProvider.email;
    }
    
    return LoginBackground(
      children: [
        Image.asset(AssetImagePaths.logoVertical, width: size.width * 0.4),
        SizedBox(height: kLargePadding),
        RoundedInputField(
            key: Key('loginEmail'),
            icon: Icons.email_outlined,
            hintText: 'Email',
            onChanged: (result) => _email = result,
            textEditingController: emailTextController,
            keyboardType: TextInputType.emailAddress),
        RoundedInputField(
            key: Key('loginPassword'),
            icon: Icons.lock_open_rounded,
            hintText: 'Password',
            isTextObscured: true,
            onChanged: (result) => _password = result),
        FlatButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ForgotPasswordScreen())),
            child: Text('Forgot Password?',
                style:
                    theme.textTheme.bodyText1.copyWith(color: Colors.white))),
        SizedBox(height: 30),
        Column(children: [
          RoundedButton(
              label: _isLoggingIn ? 'Signing In...' : 'Sign In',
              //temp
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MainScreen()))),
              // onPressed: () async {
              //   if (_isLoggingIn) {
              //     return;
              //   }

              //   if (_email == null ||
              //       _email.isEmpty ||
              //       _password == null ||
              //       _password.isEmpty) {
              //     CommonDialogs.showInformationalDialog(context,
              //         'Sign In Error', 'Please enter an email and password.');
              //     return;
              //   }

              //   _setLoadingState(true);

              //   final result = await userProvider.login(_email, _password);

              //   _setLoadingState(false);

              //   if (result != null && result.isNotEmpty) {
              //     if (result == 'missing builder email verification') {
              //       // TODO: change response code
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (context) => VerifyAccountScreen(_email)));
              //       return;
              //     }

              //     CommonDialogs.showInformationalDialog(
              //         context, 'Sign In Error', result);
              //     return;
              //   }
              // }),
          SizedBox(height: 10),
          RoundedButton(
              label: 'Create Account',
              // isPrimary: false,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateAccountScreen()))),
        ])
      ],
    );
  }

  void _setLoadingState(bool isLoading) {
    setState(() => _isLoggingIn = isLoading);
  }
}