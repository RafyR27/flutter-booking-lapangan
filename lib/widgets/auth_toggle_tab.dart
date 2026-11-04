import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AuthToggleTab extends StatelessWidget {
  final int selectedIndex; // 0 for Masuk, 1 for Daftar
  final ValueChanged<int> onTabChanged;

  const AuthToggleTab({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // "Masuk" Tab
          Expanded(
            child: _buildTabItem(
              title: 'Masuk',
              isSelected: selectedIndex == 0,
              onTap: () => onTabChanged(0),
            ),
          ),
          // "Daftar" Tab
          Expanded(
            child: _buildTabItem(
              title: 'Daftar',
              isSelected: selectedIndex == 1,
              onTap: () => onTabChanged(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.tabInactiveText,
          ),
        ),
      ),
    );
  }
}

