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
import 'package:go_router/go_router.dart';
import 'dart:io' show Platform;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool _isLoading = false;

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
                  lang.login,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            FormBuilderTextField(
              name: 'email',
              decoration: InputDecoration(prefixIcon: const Icon(Icons.email_outlined), hintText: lang.email),
            ),
            const SizedBox(height: AppSpacing.medium),
            FormBuilderTextField(
              name: 'password',
              obscureText: true,
              decoration: InputDecoration(prefixIcon: const Icon(Icons.password), hintText: lang.password),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () => context.push('/auth/forget-password'),
                  child: Text(lang.forgotPassword, style: const TextStyle(decoration: TextDecoration.underline)),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    setState(() => _isLoading = true);

                    final formData = _formKey.currentState!.value;
                    final res = await UserAuthManager.login(formData['email'], formData['password']);

                    setState(() => _isLoading = false);

                    if (res.succeeded) {
                      _handleSuccessfulLogin();
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(res.errorMessage ?? lang.genericError)));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          lang.login,
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
                        ),
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToLoad)));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToLoad)));
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
            const SizedBox(height: AppSpacing.xs),
            const TermsAndPrivacyBanner(),
            const SizedBox(height: AppSpacing.xs),

            const SizedBox(height: AppSpacing.medium),
            RichText(
              text: TextSpan(
                text: lang.dontHaveAccount,
                style: Theme.of(context).textTheme.labelLarge,
                children: <InlineSpan>[
                  TextSpan(
                    text: lang.signup,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).primaryColor),
                    recognizer: TapGestureRecognizer()..onTap = () => context.push('/auth/signup'),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.push('/home'),
              child: Text(lang.continueAsGuest, style: const TextStyle(decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }
}
