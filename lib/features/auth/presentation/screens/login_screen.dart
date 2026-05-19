import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/localization/locale_cubit.dart';
import 'package:dalil_alaqar/core/routes/app_routes.dart';
import 'package:dalil_alaqar/core/utils/breakpoints.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _resetEmailController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() => _isEmailFocused = _emailFocusNode.hasFocus);
    });
    _passwordFocusNode.addListener(() {
      setState(() => _isPasswordFocused = _passwordFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _resetEmailController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // ─── Actions ────────────────────────────────────────────────────────────────

  void _handleLogin(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final isArabic = context.read<LocaleCubit>().isArabic;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(
        context,
        isArabic
            ? 'الرجاء إدخال البريد الإلكتروني وكلمة المرور'
            : 'Please enter your email and password',
      );
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar(
        context,
        isArabic
            ? 'الرجاء إدخال بريد إلكتروني صحيح'
            : 'Please enter a valid email address',
      );
      return;
    }

    context.read<AuthCubit>().login(
      phoneNumber: email, // replace key name if your cubit uses `email`
      password: password,
    );
  }

  void _handleContinueAsGuest(BuildContext context) {
    context.read<AuthCubit>().continueAsGuest();
  }

  void _handleForgotPassword(BuildContext context) {
    final isArabic = context.read<LocaleCubit>().isArabic;
    _resetEmailController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ResetPasswordSheet(
        controller: _resetEmailController,
        isArabic: isArabic,
        onSend: (email) {
          Navigator.pop(context);
          // TODO: wire up to your reset cubit / use-case
          _showSnackBar(
            context,
            isArabic
                ? 'تم إرسال رابط إعادة التعيين إلى بريدك'
                : 'Reset link sent — check your inbox',
            color: AppColors.primary,
          );
        },
      ),
    );
  }

  bool _isValidEmail(String v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);

  void _showSnackBar(BuildContext context, String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color ?? Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isRTL = context.read<LocaleCubit>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width >= Breakpoints.tablet;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthGuest) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.main);
        } else if (state is AuthFailure) {
          print(state.message);
          _showSnackBar(context, state.message);
        }
      },
      child: Directionality(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF5F7F8),
          body: SafeArea(
            child: isTablet
                ? _buildTabletLayout(context, localizations, isRTL, isDark)
                : _buildMobileLayout(context, localizations, isRTL, isDark),
          ),
        ),
      ),
    );
  }

  // ─── Mobile layout ───────────────────────────────────────────────────────────

  Widget _buildMobileLayout(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(localizations, isDark),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildWelcomeText(localizations, isDark, isRTL),
                const SizedBox(height: 28),
                _buildLoginForm(context, localizations, isRTL, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tablet layout ───────────────────────────────────────────────────────────

  Widget _buildTabletLayout(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            color: AppColors.primary,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(size: 160),
                  const SizedBox(height: 24),
                  Text(
                    localizations.translate('app_name'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.translate('app_slogan'),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeText(localizations, isDark, isRTL),
                    const SizedBox(height: 32),
                    _buildLoginForm(context, localizations, isRTL, isDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Header band (mobile only) ───────────────────────────────────────────────

  Widget _buildHeader(AppLocalizations localizations, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          _buildLogo(size: 80),
          const SizedBox(height: 16),
          Text(
            localizations.translate('app_name'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            localizations.translate('app_slogan'),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.white.withOpacity(0.80),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Logo ────────────────────────────────────────────────────────────────────

  Widget _buildLogo({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: Colors.white.withOpacity(0.30), width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.15),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.apartment_rounded,
            size: size * 0.5,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  // ─── Welcome text ────────────────────────────────────────────────────────────

  Widget _buildWelcomeText(
    AppLocalizations localizations,
    bool isDark,
    bool isRTL,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('login_welcome'),
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          localizations.translate('login_subtitle'),
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white60 : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  // ─── Form ────────────────────────────────────────────────────────────────────

  Widget _buildLoginForm(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildEmailField(isRTL, isDark),
        const SizedBox(height: 16),
        _buildPasswordField(isRTL, isDark),
        const SizedBox(height: 8),
        _buildForgotPassword(context, isRTL),
        const SizedBox(height: 28),
        _buildLoginButton(context, localizations, isRTL),
        const SizedBox(height: 14),
        _buildDivider(isRTL),
        const SizedBox(height: 14),
        _buildGuestButton(context, isRTL),
        const SizedBox(height: 28),
        _buildSignUpRow(context, isRTL, isDark),
      ],
    );
  }

  // ─── Email field ─────────────────────────────────────────────────────────────

  Widget _buildEmailField(bool isRTL, bool isDark) {
    return _FieldWrapper(
      focused: _isEmailFocused,
      child: TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : const Color(0xFF1A1A2E),
        ),
        decoration: _fieldDecoration(
          label: isRTL ? 'البريد الإلكتروني' : 'Email address',
          hint: isRTL ? 'أدخل بريدك الإلكتروني' : 'you@example.com',
          icon: Icons.mail_outline_rounded,
          focused: _isEmailFocused,
          isDark: isDark,
        ),
      ),
    );
  }

  // ─── Password field ──────────────────────────────────────────────────────────

  Widget _buildPasswordField(bool isRTL, bool isDark) {
    return _FieldWrapper(
      focused: _isPasswordFocused,
      child: TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: !_isPasswordVisible,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : const Color(0xFF1A1A2E),
        ),
        decoration: _fieldDecoration(
          label: isRTL ? 'كلمة المرور' : 'Password',
          hint: isRTL ? 'أدخل كلمة المرور' : 'Enter your password',
          icon: Icons.lock_outline_rounded,
          focused: _isPasswordFocused,
          isDark: isDark,
          suffix: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: _isPasswordFocused ? AppColors.primary : Colors.grey,
            ),
            onPressed: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required IconData icon,
    required bool focused,
    required bool isDark,
    Widget? suffix,
  }) {
    final inactiveColor = isDark ? Colors.white38 : const Color(0xFF9CA3AF);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: focused ? AppColors.primary : inactiveColor,
        fontSize: 14,
      ),
      hintStyle: TextStyle(color: inactiveColor, fontSize: 14),
      prefixIcon: Icon(
        icon,
        color: focused ? AppColors.primary : inactiveColor,
        size: 20,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  // ─── Forgot password ─────────────────────────────────────────────────────────

  Widget _buildForgotPassword(BuildContext context, bool isRTL) {
    return Align(
      alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
      child: TextButton(
        onPressed: () => _handleForgotPassword(context),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        ),
        child: Text(
          isRTL ? 'نسيت كلمة المرور؟' : 'Forgot password?',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // ─── Login button ────────────────────────────────────────────────────────────

  Widget _buildLoginButton(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
  ) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _handleLogin(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizations.translate('login_button'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        isRTL
                            ? Icons.arrow_back_rounded
                            : Icons.arrow_forward_rounded,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  // ─── Divider ─────────────────────────────────────────────────────────────────

  Widget _buildDivider(bool isRTL) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            isRTL ? 'أو' : 'or',
            style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  // ─── Guest button ────────────────────────────────────────────────────────────

  Widget _buildGuestButton(BuildContext context, bool isRTL) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          height: 56,
          child: OutlinedButton(
            onPressed: isLoading ? null : () => _handleContinueAsGuest(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_outline_rounded, size: 20),
                const SizedBox(width: 10),
                Text(
                  isRTL ? 'الدخول كزائر' : 'Continue as guest',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Sign-up row ─────────────────────────────────────────────────────────────

  Widget _buildSignUpRow(BuildContext context, bool isRTL, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isRTL ? 'ليس لديك حساب؟ ' : "Don't have an account? ",
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white60 : const Color(0xFF6B7280),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.register),
          child: Text(
            // Replace with your register route string
            isRTL ? 'إنشاء حساب' : 'Create Account',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Field wrapper with animated shadow ──────────────────────────────────────

class _FieldWrapper extends StatelessWidget {
  const _FieldWrapper({required this.focused, required this.child});

  final bool focused;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: const Color(0xFF038086).withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: child,
    );
  }
}

// ─── Reset password bottom sheet ─────────────────────────────────────────────

class _ResetPasswordSheet extends StatefulWidget {
  const _ResetPasswordSheet({
    required this.controller,
    required this.isArabic,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isArabic;
  final void Function(String email) onSend;

  @override
  State<_ResetPasswordSheet> createState() => _ResetPasswordSheetState();
}

class _ResetPasswordSheetState extends State<_ResetPasswordSheet> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                widget.isArabic
                    ? 'إعادة تعيين كلمة المرور'
                    : 'Reset your password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isArabic
                    ? 'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين'
                    : 'Enter your email and we\'ll send you a reset link.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: widget.controller,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
                decoration: InputDecoration(
                  labelText: widget.isArabic
                      ? 'البريد الإلكتروني'
                      : 'Email address',
                  hintText: 'you@example.com',
                  prefixIcon: const Icon(
                    Icons.mail_outline_rounded,
                    color: Color(0xFF038086),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2A2A3E)
                      : const Color(0xFFF9FAFB),
                  labelStyle: const TextStyle(
                    color: Color(0xFF038086),
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF038086),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.isArabic ? 'إلغاء' : 'Cancel',
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          widget.onSend(widget.controller.text.trim()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF038086),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.isArabic ? 'إرسال الرابط' : 'Send link',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
