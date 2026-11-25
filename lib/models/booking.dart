import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum BookingStatus {
  pendingVerification,
  confirmed,
  completed,
  cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pendingVerification:
        return 'Menunggu Verifikasi';
      case BookingStatus.confirmed:
        return 'Dikonfirmasi';
      case BookingStatus.completed:
        return 'Selesai';
      case BookingStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pendingVerification:
        return AppColors.statusPending;
      case BookingStatus.confirmed:
        return AppColors.statusConfirmed;
      case BookingStatus.completed:
        return AppColors.statusCompleted;
      case BookingStatus.cancelled:
        return AppColors.statusCancelled;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case BookingStatus.pendingVerification:
        return AppColors.statusPendingBg;
      case BookingStatus.confirmed:
        return AppColors.statusConfirmedBg;
      case BookingStatus.completed:
        return AppColors.statusCompletedBg;
      case BookingStatus.cancelled:
        return AppColors.statusCancelledBg;
    }
  }
}

class Booking {
  final String id;
  final String code;
  final String fieldId;
  final String fieldName;
  final String sportType;
  final String courtName;
  final DateTime bookingDate;
  final List<String> timeSlots;
  final String userName;
  final String userWhatsApp;
  final String userEmail;
  final int totalPrice;
  final String paymentMethod;
  BookingStatus status;
  final DateTime createdAt;
  final String? paymentProofName;
  final int? refundAmount;
  final int? penaltyAmount;

  Booking({
    required this.id,
    required this.code,
    required this.fieldId,
    required this.fieldName,
    required this.sportType,
    required this.courtName,
    required this.bookingDate,
    required this.timeSlots,
    required this.userName,
    required this.userWhatsApp,
    required this.userEmail,
    required this.totalPrice,
    required this.paymentMethod,
    this.status = BookingStatus.pendingVerification,
    required this.createdAt,
    this.paymentProofName,
    this.refundAmount,
    this.penaltyAmount,
  });

  String get formattedSlots => timeSlots.join(', ');

  int get durationHours => timeSlots.length;
}
