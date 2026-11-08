import 'package:flutter/material.dart';
import '../models/refund_account.dart';
import '../services/favorite_service.dart';
import '../theme/app_colors.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  RefundAccountType _accountType = RefundAccountType.bankTransfer;
  String _providerName = 'Bank BCA';
  String _accountNumber = '5210 9821 4410';
  String _accountHolder = 'Muhamad Rafy Ramadhan';

  void _showEditBankSheet() {
    RefundAccountType sheetType = _accountType;
    String selectedProvider = _providerName;
    final numberController = TextEditingController(text: _accountNumber);
    final holderController = TextEditingController(text: _accountHolder);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final isBank = sheetType == RefundAccountType.bankTransfer;
            final providerOptions = isBank
                ? RefundProvider.bankList.map((p) => p.name).toList()
                : RefundProvider.eWalletList.map((p) => p.name).toList();

            if (!providerOptions.contains(selectedProvider)) {
              selectedProvider = providerOptions.first;
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ubah Rekening / E-Wallet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Segmented Type Selector (Bank vs E-Wallet)
                  Container(
                    height: 42,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setSheetState(() {
                                sheetType = RefundAccountType.bankTransfer;
                                selectedProvider = RefundProvider.bankList.first.name;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isBank ? AppColors.primaryGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Bank Transfer (17 Bank)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isBank ? Colors.white : AppColors.textSubtitle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setSheetState(() {
                                sheetType = RefundAccountType.eWallet;
                                selectedProvider = RefundProvider.eWalletList.first.name;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !isBank ? AppColors.primaryGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'E-Wallet (7 Dompet)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: !isBank ? Colors.white : AppColors.textSubtitle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Provider Dropdown
                  Text(
                    isBank ? 'NAMA BANK TUJUAN' : 'LAYANAN E-WALLET',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedProvider,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDark),
                        items: providerOptions.map((name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setSheetState(() {
                              selectedProvider = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Account / Phone Number
                  Text(
                    isBank ? 'NOMOR REKENING' : 'NOMOR HP / AKUN E-WALLET',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                      decoration: InputDecoration(
                        hintText: isBank ? 'Contoh: 521098214410' : 'Contoh: 081289123456',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Account Holder Name
                  Text(
                    isBank ? 'NAMA PEMILIK REKENING' : 'NAMA AKUN TERDAFTAR',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: holderController,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                      decoration: InputDecoration(
                        hintText: isBank
                            ? 'Nama lengkap sesuai buku tabungan'
                            : 'Nama akun sesuai profil e-wallet',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (numberController.text.trim().isEmpty ||
                            holderController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lengkapi nomor akun dan nama pemilik'),
                              backgroundColor: AppColors.statusCancelled,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _accountType = sheetType;
                          _providerName = selectedProvider;
                          _accountNumber = numberController.text.trim();
                          _accountHolder = holderController.text.trim();
                        });

                        Navigator.of(sheetCtx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Akun refund ($_providerName) berhasil diperbarui',
                            ),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan Akun Refund',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showChangePasswordSheet() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ganti Kata Sandi',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _buildPasswordField(
                    label: 'KATA SANDI SAAT INI',
                    controller: oldPasswordController,
                    obscureText: obscureOld,
                    onToggleObscure: () {
                      setSheetState(() {
                        obscureOld = !obscureOld;
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  _buildPasswordField(
                    label: 'KATA SANDI BARU',
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    onToggleObscure: () {
                      setSheetState(() {
                        obscureNew = !obscureNew;
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  _buildPasswordField(
                    label: 'KONFIRMASI KATA SANDI BARU',
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    onToggleObscure: () {
                      setSheetState(() {
                        obscureConfirm = !obscureConfirm;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (oldPasswordController.text.isEmpty ||
                            newPasswordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Semua kolom kata sandi wajib diisi'),
                              backgroundColor: AppColors.statusCancelled,
                            ),
                          );
                          return;
                        }

                        if (newPasswordController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kata sandi baru minimal 6 karakter'),
                              backgroundColor: AppColors.statusCancelled,
                            ),
                          );
                          return;
                        }

                        if (newPasswordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Konfirmasi kata sandi baru tidak cocok'),
                              backgroundColor: AppColors.statusCancelled,
                            ),
                          );
                          return;
                        }

                        Navigator.of(sheetCtx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kata sandi berhasil diperbarui'),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Perbarui Kata Sandi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textLabel,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textLabel,
                  size: 20,
                ),
                onPressed: onToggleObscure,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Kebijakan Pembatalan & Refund',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Aturan Pembatalan D-1:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            SizedBox(height: 6),
            Text(
              '1. Pembatalan sewa lapangan hanya dapat dilakukan maksimal H-1 (24 jam) sebelum jam bermain dimulai.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSubtitle, height: 1.4),
            ),
            SizedBox(height: 8),
            Text(
              '2. Setiap pembatalan dikenakan penalti 20% sebagai kompensasi penahanan jadwal bagi mitra pengelola lapangan.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSubtitle, height: 1.4),
            ),
            SizedBox(height: 8),
            Text(
              '3. Sisa 80% dari total biaya sewa akan dikembalikan (refund) secara transfer ke rekening bank penyewa terdaftar dalam 1x24 jam kerja.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSubtitle, height: 1.4),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Saya Mengerti'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Keluar dari Akun',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari sesi aplikasi?',
          style: TextStyle(fontSize: 13, color: AppColors.textSubtitle),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSubtitle)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusCancelled,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Profil Penyewa',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Rafy Ramadhan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: AppColors.primaryGreen,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '0812-8912-3456 • Karawang',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSubtitle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'rafy.ramadhan@example.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Rekening / E-Wallet Pencairan Refund
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AKUN PENGEMBALIAN DANA (REFUND)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLabel,
                    letterSpacing: 0.6,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _accountType == RefundAccountType.bankTransfer
                        ? AppColors.primaryGreenLight
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _accountType == RefundAccountType.bankTransfer
                        ? 'BANK TRANSFER'
                        : 'E-WALLET',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _accountType == RefundAccountType.bankTransfer
                          ? AppColors.primaryGreen
                          : const Color(0xFF2563EB),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Icon(
                    _accountType == RefundAccountType.bankTransfer
                        ? Icons.account_balance_outlined
                        : Icons.account_balance_wallet_outlined,
                    color: AppColors.textDark,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_providerName • $_accountNumber',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'a.n. $_accountHolder',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSubtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showEditBankSheet,
                    child: const Text('Ubah', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Pengaturan & Legal
            const Text(
              'MENU & LAYANAN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textLabel,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    ValueListenableBuilder<Set<String>>(
                      valueListenable: FavoriteService.instance.favoriteIdsNotifier,
                      builder: (context, favIds, _) {
                        return _buildMenuItem(
                          icon: Icons.bookmark_outline_rounded,
                          title: 'Lapangan Favorit Tersimpan',
                          trailingBadge: '${favIds.length} Venue',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const FavoritesScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const Divider(color: AppColors.dividerColor, height: 1),
                    _buildMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Ganti Kata Sandi',
                      onTap: _showChangePasswordSheet,
                    ),
                    const Divider(color: AppColors.dividerColor, height: 1),
                    _buildMenuItem(
                      icon: Icons.policy_outlined,
                      title: 'Kebijakan Pembatalan D-1 & S&K',
                      onTap: () => _showPolicyDialog(context),
                    ),
                    const Divider(color: AppColors.dividerColor, height: 1),
                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Bantuan & Layanan Pelanggan',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hubungi admin WhatsApp: +62 812-8912-3456')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => _showLogoutDialog(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.statusCancelled,
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout_rounded, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Keluar dari Akun',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailingBadge,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20, color: AppColors.textSubtitle),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingBadge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                trailingBadge,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.textSubtitle,
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
