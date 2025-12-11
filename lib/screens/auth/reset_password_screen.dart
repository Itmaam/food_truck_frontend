import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/layouts/auth_layout.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String token;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  String? _errorMessage;

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
                  lang.setNewPasswordTitle,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            FormBuilderTextField(
              name: 'password',
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password),
                hintText: lang.newPasswordHint,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(8),
              ]),
            ),
            const SizedBox(height: AppSpacing.medium),
            FormBuilderTextField(
              name: 'confirm_password',
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password),
                hintText: lang.confirmPasswordHint,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                (val) {
                  if (val != _formKey.currentState?.fields['password']?.value) {
                    return lang.passwordMismatchError;
                  }
                  return null;
                },
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          lang.resetPasswordButton,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(color: Colors.white),
                        ),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            TextButton(
              onPressed: _isLoading ? null : () => context.push('/auth/login'),
              child: Text(
                lang.cancelButton,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final password =
            _formKey.currentState!.fields['password']!.value as String;
        final passwordConfirm =
            _formKey.currentState!.fields['confirm_password']!.value as String;
        await AppApi.passwordResetApi.resetPassword(
          widget.token,
          password,
          passwordConfirm,
        );

        if (mounted) {
          context.push('/auth/login');
        }
      } catch (e) {
        setState(() {
          _errorMessage = S.of(context).genericErrorMessage;
        });
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
