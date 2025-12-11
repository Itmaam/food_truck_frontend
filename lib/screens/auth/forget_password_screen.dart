import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/layouts/auth_layout.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

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
                  lang.resetPassword,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            FormBuilderTextField(
              name: 'email',
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                hintText: lang.email,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.email(),
                FormBuilderValidators.required(),
              ]),
            ),
            const SizedBox(height: AppSpacing.medium),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                child: Text(
                  _errorMessage!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ),
            if (_successMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                child: Text(
                  _successMessage!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.green),
                ),
              ),
            SizedBox(
              width: double.infinity, // This makes the button full width
              child: ElevatedButton(
                onPressed: _isLoading ? null : _requestPasswordReset,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Sets minimum height
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          lang.resetPassword,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(color: Colors.white),
                        ),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            TextButton(
              onPressed: () => context.push('/auth/login'),
              child: Text(
                lang.cancel,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPasswordReset() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });

      try {
        final email = _formKey.currentState!.fields['email']!.value as String;
        await AppApi.passwordResetApi.requestOtp(email);

        setState(() {
          _successMessage =
              'Password reset email sent! Please check your email for the OTP code.';
        });

        // Wait a moment to show the success message, then navigate
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          context.push('/auth/verify-otp?email=$email');
        }
      } catch (e) {
        setState(() {
          _errorMessage =
              'Failed to send reset email. Please check your email address and try again.';
        });
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
