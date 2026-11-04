import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_toggle_tab.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterView extends StatefulWidget {
  final ValueChanged<int>? onTabChanged;
  final VoidCallback? onSubmit;

  const RegisterView({
    super.key,
    this.onTabChanged,
    this.onSubmit,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
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
                    'Daftar Akun Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Lengkapi data identitas penyewa',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSubtitle,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Segmented Control Tab (Masuk / Daftar)
                  AuthToggleTab(
                    selectedIndex: 1, // Daftar is selected
                    onTabChanged: (index) {
                      if (widget.onTabChanged != null) {
                        widget.onTabChanged!(index);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  CustomTextField(
                    label: 'NAMA LENGKAP',
                    controller: _nameController,
                    hintText: 'Masukkan Nama Lengkap',
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    label: 'NOMOR WHATSAPP',
                    controller: _whatsappController,
                    hintText: 'Masukkan Nomor WhatsApp',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    label: 'ALAMAT EMAIL',
                    controller: _emailController,
                    hintText: 'Masukkan Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Disclaimer
                  const Text(
                    'Saya menyetujui aturan pembatalan 20% & S&K',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.termsText,
                    ),
                  ),

                  const Spacer(),
                  const SizedBox(height: 28),

                  // Action Button
                  PrimaryButton(
                    text: 'Daftar Sekarang',
                    onPressed: widget.onSubmit ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pendaftaran berhasil diproses!'),
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
