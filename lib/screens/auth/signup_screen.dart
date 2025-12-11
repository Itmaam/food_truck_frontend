// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/auth/auth.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/layouts/auth_layout.dart';
import 'package:food_truck_finder_user_app/screens/auth/widgets/signin_with_google.dart';
import 'package:food_truck_finder_user_app/screens/auth/widgets/terms_and_privacy_banner.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  void _handleSuccessfulLogin() {
    // Check if there's a redirect parameter
    final uri = GoRouterState.of(context).uri;
    final redirectPath = uri.queryParameters['redirect'];

    if (redirectPath != null && redirectPath.isNotEmpty) {
      // Redirect to the intended destination
      context.push(redirectPath);
    } else {
      // Default redirect to home
      context.push('/home');
    }
  }

  Future<void> _submitSignup() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;

      if (formData['password'] != formData['confirm_password']) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('')));
        return;
      }

      try {
        bool done = await UserAuthManager.signUp(
          name: formData['name'],
          email: formData['email'],
          password: formData['password'],
          passwordConfirmation: formData['confirm_password'],
        );

        if (done) {
          // Success - handle token and user data
          // Save token to secure storage
          // Navigate to intended destination or home screen
          await UserAuthManager.login(formData['email'], formData['password']);
          await UserAuthManager.checkUser();
          _handleSuccessfulLogin();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToLoad)));
        }
      } catch (e) {
        // print(s);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToLoad)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return AuthLayout(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  lang.signup,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            FormBuilderTextField(
              name: 'name',
              decoration: InputDecoration(prefixIcon: Icon(Icons.person_2_outlined), hintText: lang.name),
            ),
            const SizedBox(height: AppSpacing.large),
            FormBuilderTextField(
              name: 'email',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
              decoration: InputDecoration(prefixIcon: Icon(Icons.email_outlined), hintText: lang.email),
            ),
            const SizedBox(height: AppSpacing.medium),
            FormBuilderTextField(
              name: 'password', // Changed from 'email' to 'password'
              obscureText: true,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(8),
              ]),
              decoration: InputDecoration(prefixIcon: Icon(Icons.password), hintText: lang.password),
            ),
            const SizedBox(height: AppSpacing.medium),
            FormBuilderTextField(
              name: 'confirm_password',
              obscureText: true,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(8),
              ]),
              decoration: InputDecoration(prefixIcon: Icon(Icons.password), hintText: lang.confirmPassword),
            ),

            const SizedBox(height: AppSpacing.medium),
            const TermsAndPrivacyBanner(),
            const SizedBox(height: AppSpacing.medium),
            SizedBox(
              width: double.infinity, // This makes the button full width
              child: ElevatedButton(
                onPressed: () => _submitSignup(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Sets minimum height
                ),
                child: Text(lang.signup, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white)),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            // 3rd party login
            Column(
              children: [
                SigninWithGoogle(
                  onClick: () async {
                    try {
                      bool success = await AppApi.user.signInWithGoogle();
                      if (success) {
                        _handleSuccessfulLogin();
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Google Sign-In failed. Please try again.')));
                      }
                    } catch (e) {
                      // ScaffoldMessenger.of(
                      //   context,
                      // ).showSnackBar(SnackBar(content: Text('Google Sign-In error: ${e.toString()}')));
                    }
                  },
                  label: lang.loginWithGoogle,
                ),
                const SizedBox(height: AppSpacing.medium),
                if (Platform.isIOS)
                  SignInWithAppleButton(
                    text: lang.signinwithapple,
                    onPressed: () async {
                      try {
                        bool success = await AppApi.user.signInWithApple();
                        if (success) {
                          _handleSuccessfulLogin();
                        } else {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(S.of(context).failedToLoad)));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToLoad)));
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            RichText(
              text: TextSpan(
                text: lang.haveAccount,
                style: Theme.of(context).textTheme.labelLarge,
                children: <InlineSpan>[
                  TextSpan(
                    text: lang.login,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).primaryColor),
                    recognizer: TapGestureRecognizer()..onTap = () => context.push('/auth/login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
