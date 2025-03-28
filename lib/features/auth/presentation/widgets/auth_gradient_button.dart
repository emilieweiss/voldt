import 'package:flutter/material.dart';
import 'package:voldt/core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;

  const AuthGradientButton({
    super.key,
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppPallete.woltBlue,
            AppPallete.woltMediumBlue,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(395, 50),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppPallete.white,
          ),
        ),
      ),
    );
  }
}
