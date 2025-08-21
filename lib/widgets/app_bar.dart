import 'package:flutter/material.dart';
import 'package:voldt/core/theme/app_pallete.dart';

class VoldtAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool showBack;
  final VoidCallback? onLogout;

  const VoldtAppBar({
    super.key,
    this.showBack = true,
    this.onLogout,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBack,
      centerTitle: true,
      title: const Text(
        'voldt',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppPallete.white,
        ),
      ),
      backgroundColor: AppPallete.woltBlue,
      actions: [
        if (onLogout != null)
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: onLogout,
          ),
      ],
    );
  }
}
