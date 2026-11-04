import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_toggle_tab.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_checkbox.dart';
import '../widgets/primary_button.dart';

class LoginView extends StatefulWidget {
  final ValueChanged<int>? onTabChanged;
  final VoidCallback? onSubmit;

  const LoginView({
    super.key,
    this.onTabChanged,
    this.onSubmit,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 40,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Subtitle
                  const Text(
                    'Masuk ke Akun',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Gunakan akun penyewa terdaftar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSubtitle,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Segmented Control Tab (Masuk / Daftar)
                  AuthToggleTab(
                    selectedIndex: 0, // Masuk is selected
                    onTabChanged: (index) {
                      if (widget.onTabChanged != null) {
                        widget.onTabChanged!(index);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  CustomTextField(
                    label: 'EMAIL / WHATSAPP',
                    controller: _identifierController,
                    hintText: 'Masukkan Email',
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    label: 'KATA SANDI',
                    controller: _passwordController,
                    hintText: 'Masukkan Kata Sandi',
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember Me Checkbox
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomCheckbox(
                            value: _rememberMe,
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _rememberMe = !_rememberMe;
                              });
                            },
                            child: const Text(
                              'Ingat Sesi Saya',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColors.termsText,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Forgot Password Link
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menu Lupa Sandi'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Text(
                          'Lupa Sandi?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                  const SizedBox(height: 28),

                  // Action Button
                  PrimaryButton(
                    text: 'Masuk ke Katalog Venue',
                    onPressed: widget.onSubmit ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Berhasil masuk ke katalog venue!'),
                              backgroundColor: AppColors.primaryGreen,
                            ),
                          );
                        },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
