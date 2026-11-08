import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/booking.dart';
import '../models/field.dart';
import '../services/booking_service.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import 'ticket_pass_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Field field;
  final String selectedCourt;
  final DateTime selectedDate;
  final List<String> selectedSlots;
  final int totalPrice;

  const CheckoutScreen({
    super.key,
    required this.field,
    required this.selectedCourt,
    required this.selectedDate,
    required this.selectedSlots,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'BCA';
  String? _uploadedReceiptName;
  File? _receiptImageFile;
  final ImagePicker _picker = ImagePicker();
  bool _agreedToTerms = true;
  bool _isSubmitting = false;

  final String _userName = 'Rafy Ramadhan';
  final String _userWhatsApp = '081289123456';
  final String _userEmail = 'rafy.ramadhan@example.com';

  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin ke clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _receiptImageFile = File(picked.path);
          _uploadedReceiptName = picked.name;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Foto bukti transfer dipilih: ${picked.name}'),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil gambar: $e'),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Bukti Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
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
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.primaryGreen,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Ambil Foto Langsung (Kamera)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: const Text(
                    'Foto langsung struk ATM atau bukti transfer',
                    style: TextStyle(fontSize: 12, color: AppColors.textSubtitle),
                  ),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                const Divider(color: AppColors.dividerColor, height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: AppColors.primaryGreen,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Pilih dari Galeri Foto',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: const Text(
                    'Pilih screenshot m-Banking atau file gambar',
                    style: TextStyle(fontSize: 12, color: AppColors.textSubtitle),
                  ),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitBooking() async {
    if (_uploadedReceiptName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap unggah foto bukti pembayaran terlebih dahulu'),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui syarat & ketentuan pembatalan'),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate network latency (consistent with real API call)
    await Future.delayed(const Duration(milliseconds: 600));

    final bookingCode = 'APX-${AppDateFormatter.formatCodeDate(widget.selectedDate)}-${(DateTime.now().millisecondsSinceEpoch % 9000 + 1000)}';
    final newBooking = Booking(
      id: 'bk-${DateTime.now().millisecondsSinceEpoch}',
      code: bookingCode,
      fieldId: widget.field.id,
      fieldName: widget.field.name,
      sportType: widget.field.sportType,
      courtName: widget.selectedCourt,
      bookingDate: widget.selectedDate,
      timeSlots: widget.selectedSlots,
      userName: _userName,
      userWhatsApp: _userWhatsApp,
      userEmail: _userEmail,
      totalPrice: widget.totalPrice,
      paymentMethod: _selectedPaymentMethod == 'QRIS'
          ? 'QRIS Dinamis'
          : 'Transfer Bank $_selectedPaymentMethod',
      status: BookingStatus.pendingVerification,
      createdAt: DateTime.now(),
      paymentProofName: _uploadedReceiptName,
    );

    BookingService.instance.addBooking(newBooking);

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TicketPassScreen(booking: newBooking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = AppDateFormatter.formatFull(widget.selectedDate);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Konfirmasi Pembayaran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rincian Pesanan
            const Text(
              'RINGKASAN PESANAN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textLabel,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreenLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.field.sportType.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.field.name,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.dividerColor, height: 1),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Lapangan', widget.selectedCourt),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Tanggal Main', formattedDate),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Jam Slot', widget.selectedSlots.join(', ')),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Durasi', '${widget.selectedSlots.length} Jam'),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.dividerColor, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Tagihan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        _formatRupiah(widget.totalPrice),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Identitas Pemesan
            const Text(
              'DATA PEMESAN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textLabel,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _buildContactRow(Icons.person_outline_rounded, 'Nama', _userName),
                  const Divider(color: AppColors.dividerColor, height: 16),
                  _buildContactRow(Icons.phone_outlined, 'WhatsApp', _userWhatsApp),
                  const Divider(color: AppColors.dividerColor, height: 16),
                  _buildContactRow(Icons.mail_outline_rounded, 'Email', _userEmail),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pilihan Metode Pembayaran
            const Text(
              'METODE PEMBAYARAN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textLabel,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildPaymentOption('BCA', 'Bank BCA'),
                const SizedBox(width: 8),
                _buildPaymentOption('Mandiri', 'Bank Mandiri'),
                const SizedBox(width: 8),
                _buildPaymentOption('QRIS', 'QRIS'),
              ],
            ),

            const SizedBox(height: 14),

            // Rekening Tujuan
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedPaymentMethod == 'QRIS'
                        ? 'QRIS Kemenpora Karawang'
                        : 'Rekening Transfer Resmi ($_selectedPaymentMethod)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedPaymentMethod != 'QRIS') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedPaymentMethod == 'BCA'
                              ? '8940 1204 8819'
                              : '173 00 9821 4410',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: AppColors.textDark,
                          ),
                        ),
                        InkWell(
                          onTap: () => _copyToClipboard(
                            _selectedPaymentMethod == 'BCA'
                                ? '894012048819'
                                : '1730098214410',
                            'Nomor Rekening',
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: const Text(
                              'Salin Rekening',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Atas Nama: PT Apex Solusi Olahraga',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ] else ...[
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.qr_code_2_rounded, size: 48, color: AppColors.textDark),
                            SizedBox(height: 4),
                            Text(
                              'Pindai QRIS via BCA / GoPay / OVO / Dana',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Upload Bukti Pembayaran (Proposal Requirement)
            const Text(
              'UNGGAH BUKTI PEMBAYARAN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textLabel,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Format file: JPG, PNG maksimal 5 MB untuk diverifikasi admin',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSubtitle,
              ),
            ),
            const SizedBox(height: 10),

            if (_uploadedReceiptName == null)
              InkWell(
                onTap: _showImageSourcePicker,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.cardBorder,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 26,
                            color: AppColors.primaryGreen,
                          ),
                          SizedBox(width: 14),
                          Icon(
                            Icons.photo_library_outlined,
                            size: 26,
                            color: AppColors.primaryGreen,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ambil Foto Kamera / Pilih dari Galeri',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Ketuk di sini untuk memilih foto struk transfer',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreenLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primaryGreen),
                ),
                child: Row(
                  children: [
                    if (_receiptImageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _receiptImageFile!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: AppColors.primaryGreen,
                          size: 30,
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _uploadedReceiptName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Siap diverifikasi admin web',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: _showImageSourcePicker,
                            child: const Text(
                              'Ganti Foto Bukti',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSubtitle),
                      onPressed: () {
                        setState(() {
                          _uploadedReceiptName = null;
                          _receiptImageFile = null;
                        });
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // S&K Pembatalan Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _agreedToTerms,
                    activeColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _agreedToTerms = val ?? true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Saya menyetujui aturan pembatalan maksimal H-1 (penalti 20% & pengembalian 80% ke rekening penyewa).',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.termsText,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE5E7EB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Kirim Bukti & Selesaikan Pemesanan',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String id, String label) {
    final isSelected = _selectedPaymentMethod == id;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = id;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreenLight : AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.cardBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primaryGreen : AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSubtitle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSubtitle),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: AppColors.textSubtitle),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
