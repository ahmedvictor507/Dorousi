import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/app_theme.dart';

/// Reusable text form field for all auth screens.
/// Styled with the Dourousi design system: 16px radius, filled background.
class AuthTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool enabled;
  final int maxLines;

  const AuthTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          enabled: widget.enabled,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.primaryBlue, size: 22)
                : null,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () => setState(() => _obscureText = !_obscureText),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        key: ValueKey(_obscureText),
                        color: AppColors.textTertiary,
                        size: 22,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

/// Primary action button used across auth screens.
/// Emerald green with loading state support.
class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emeraldGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.emeraldGreen.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

/// Outlined secondary button for auth screens.
class AuthSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AuthSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline text link (e.g., "Don't have an account? Sign up")
class AuthLinkRow extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onTap;

  const AuthLinkRow({
    super.key,
    required this.message,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}
