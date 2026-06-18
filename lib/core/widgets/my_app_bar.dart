import 'package:flutter/material.dart';
import '/theme/app_theme.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.onSearchChanged,
    this.onLoginTap,
    this.onSearchTap,
    this.isReadOnly = false,
    this.hintText = 'Search games...',
  });

  final ValueChanged<String> onSearchChanged;

  final VoidCallback? onLoginTap;
  final String hintText;
  final VoidCallback? onSearchTap;
  final bool isReadOnly;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: TextField(
          readOnly: isReadOnly,
          onTap: isReadOnly ? onSearchTap : null ,
          autofocus: !isReadOnly,
          onChanged: onSearchChanged,
          cursorColor: AppColors.textSecondary,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search, color:(AppColors.textSecondary)),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.myDarkerBackground),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onLoginTap,
          tooltip: 'Login',
          icon: const Icon(Icons.login),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}