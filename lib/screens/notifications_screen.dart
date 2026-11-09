import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final IconData icon;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.icon = Icons.notifications_outlined,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Can be empty or contain notifications
  final List<AppNotificationItem> _notifications = [
    AppNotificationItem(
      id: 'notif-1',
      title: 'Selamat Datang di Apex Sport',
      message:
          'Nikmati kemudahan reservasi lapangan berstandar kompetisi di Karawang dengan garansi refund 80%.',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      icon: Icons.celebration_outlined,
    ),
    AppNotificationItem(
      id: 'notif-2',
      title: 'Saldo Pengembalian Dana Aktif',
      message:
          'Saldo dompet refund Anda siap digunakan untuk memotong biaya sewa lapangan selanjutnya.',
      time: DateTime.now().subtract(const Duration(hours: 6)),
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  void _clearNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Notifikasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _clearNotifications,
              child: const Text(
                'Bersihkan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSubtitle,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 64,
                      color: AppColors.tabInactiveText,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'belum ada notifikasi untuk hari ini',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: AppColors.dividerColor, height: 16),
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Icon(
                          item.icon,
                          size: 20,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.message,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSubtitle,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
