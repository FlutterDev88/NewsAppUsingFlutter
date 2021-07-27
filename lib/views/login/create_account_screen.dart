import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/theme_bloc.dart';
import 'package:flutter_application_1/blocs/user_bloc.dart';
import 'package:flutter_application_1/components/dialog.dart';
import 'package:flutter_application_1/components/rounded_button.dart';
import 'package:flutter_application_1/components/rounded_input_field.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/validator_service.dart';
import 'package:flutter_application_1/views/login/login_background.dart';
import 'package:flutter_application_1/views/login/verify_account_screen.dart';
import 'package:flutter_application_1/views/main_screen.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  final bool isUpdatingAccount;

  CreateAccountScreen({this.isUpdatingAccount = false});

  @override
  _CreateAccountScreenState createState() =>
      _CreateAccountScreenState(isUpdatingAccount);
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String _name;
  String _email;
  String _phoneNumber;
  String _password;
  String _confirmPassword;
  String _avatar = 'avatar1';
  String _themeName;
  bool _isUpdatingAccount = false;
  bool _isLoading = false;

  _CreateAccountScreenState(this._isUpdatingAccount);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final themeProvider = Provider.of<ThemeBloc>(context, listen: true);
    _themeName = themeProvider.getThemeName();

    String mainVerb;
    String secondaryVerb;

    var emailTextController;
    var nameTextController;
    var phoneNumberTextController;

    if (_isUpdatingAccount) {
      mainVerb = 'Update';
      secondaryVerb = 'Updating';

      if (_name == null || _name.isEmpty) {
        final userProvider = Provider.of<UserBloc>(context, listen: false);
        _name = userProvider.user.name;
        _email = userProvider.user.email;
        _phoneNumber = userProvider.user.phoneNumber;
        nameTextController = TextEditingController(text: _name);
        emailTextController = TextEditingController(text: _email);
        phoneNumberTextController = TextEditingController(text: _phoneNumber);
        _avatar = userProvider.user.avatar;
      }
    } else {
      mainVerb = 'Create';
      secondaryVerb = 'Creating';
    }

    return LoginBackground(children: [
      SizedBox(
        width: kCalculatedWidth(size),
        child: Text('$mainVerb Account',
            style: theme.textTheme.headline4.copyWith(color: Colors.white),
            textAlign: TextAlign.start),
      ),
      SizedBox(height: 10),
      SizedBox(
          width: kCalculatedWidth(size),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            RoundedInputField(
                key: Key('inputName'),
                icon: Icons.person,
                hintText: 'Builder Name',
                onChanged: (result) => _name = result,
                width: size.width * 0.6,
                textEditingController: nameTextController),
                //temp
            // GestureDetector(
            //     onTap: () async {
            //       final newAvatar = await showModalBottomSheet<String>(
            //           context: context,
            //           isScrollControlled: true,
            //           backgroundColor: Colors.transparent,
            //           builder: (BuildContext context) =>
            //               AvatarSelectionModal());

            //       if (newAvatar != null && newAvatar.isNotEmpty) {
            //         setState(() => _avatar = newAvatar);
            //       }
            //     },
            //     child: Avatar(_avatar)),
          ])),
      RoundedInputField(
          key: Key('inputEmail'),
          icon: Icons.email,
          hintText: 'Email',
          onChanged: (result) => _email = result,
          keyboardType: TextInputType.emailAddress,
          isReadOnly: _isUpdatingAccount,
          textEditingController: emailTextController),
      RoundedInputField(
          key: Key('inputPhone'),
          icon: Icons.phone,
          hintText: 'Phone Number (optional)',
          onChanged: (result) => _phoneNumber = result,
          keyboardType: TextInputType.phone,
          textEditingController: phoneNumberTextController),
      RoundedInputField(
          key: Key('inputPassword'),
          icon: Icons.lock,
          hintText: 'Password',
          isTextObscured: true,
          onChanged: (result) => _password = result),
      RoundedInputField(
          key: Key('inputConfirm'),
          icon: Icons.lock,
          hintText: 'Confirm Password',
          isTextObscured: true,
          onChanged: (result) => _confirmPassword = result),
      if (!_isUpdatingAccount)
        FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false);
            },
            child: Text('Have an account? Sign in instead',
                style:
                    theme.textTheme.bodyText1.copyWith(color: Colors.white))),
      SizedBox(height: 30),
      RoundedButton(
          key: Key('newAccount'),
          label: _isLoading == true
              ? '$secondaryVerb Account...'
              : '$mainVerb Account',
          onPressed: () async {
            if (_isLoading) {
              return;
            }
            // validate fields aren't empty
            if (_name == null ||
                    _name.isEmpty ||
                    _email == null ||
                    _email.isEmpty
                // _phoneNumber == null ||
                // _phoneNumber.isEmpty ||
                ) {
              CommonDialogs.showInformationalDialog(
                  context, '$mainVerb Account', 'Please fill in all fields.');
              return;
            }

            if (!_isUpdatingAccount &&
                (_password == null ||
                    _password.isEmpty ||
                    _confirmPassword == null ||
                    _confirmPassword.isEmpty)) {
              CommonDialogs.showInformationalDialog(
                  context, '$mainVerb Account', 'Please enter a password.');
              return;
            }

            // validate email address format
            if (!ValidatorService.isEmailValid(_email)) {
              CommonDialogs.showInformationalDialog(context,
                  '$mainVerb Account', 'Please use a valid email address.');
              return;
            }

            if (_phoneNumber != null &&
                _phoneNumber.isNotEmpty && // validate phone number format
                !ValidatorService.isPhoneNumberValid(_phoneNumber)) {
              CommonDialogs.showInformationalDialog(context,
                  '$mainVerb Account', 'Please use a valid phone number.');
              return;
            }

            if (_password != _confirmPassword) {
              CommonDialogs.showInformationalDialog(context,
                  '$mainVerb Account', 'Please ensure your passwords match.');
              return;
            }

            _setLoadingState(true);

            try {
              var result;

              if (_isUpdatingAccount) {
                await AuthService.update(_email, _password, _name, _phoneNumber,
                    _avatar, _themeName);
                themeProvider.setTheme(_themeName);
                result = 'OK';
              } else {
                result = await AuthService.register(
                    _email, _password, _name, _phoneNumber, _avatar);
              }

              await CommonDialogs.showInformationalDialog(
                  context, '$mainVerb Account', result);
              print("_isUpdatingAccount $_isUpdatingAccount");
              if (_isUpdatingAccount) {
                Navigator.pop(context, true);
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VerifyAccountScreen(_email)));
              }
            } catch (ex) {
              CommonDialogs.showInformationalDialog(
                  context, '$mainVerb Account', ex.toString());
            }

            _setLoadingState(false);
          }),
      RoundedButton(label: 'Back', onPressed: () => Navigator.of(context).pop())
    ]);
  }

  void _setLoadingState(bool isLoading) {
    setState(() => _isLoading = isLoading);
  }
}