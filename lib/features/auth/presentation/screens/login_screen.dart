import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/localization/locale_cubit.dart';
import 'package:dalil_alaqar/core/routes/app_routes.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/breakpoints.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isPhoneFocused = false;
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      setState(() {
        _isPhoneFocused = _phoneFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phoneNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<LocaleCubit>().isArabic
                ? 'الرجاء إدخال رقم الهاتف وكلمة المرور'
                : 'Please enter phone number and password',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AuthCubit>().login(
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  void _handleContinueAsGuest(BuildContext context) {
    context.read<AuthCubit>().continueAsGuest();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isRTL = context.read<LocaleCubit>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= Breakpoints.tablet;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthGuest) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Directionality(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.darkBackground,
                        AppColors.darkSurface,
                        AppColors.darkBackground,
                      ]
                    : [
                        AppColors.lightBackground,
                        AppColors.grey.withValues(alpha: 0.05),
                        AppColors.lightBackground,
                      ],
              ),
            ),
            child: SafeArea(
              child: isTablet
                  ? _buildTabletLayout(context, localizations, isRTL, isDark)
                  : _buildMobileLayout(context, localizations, isRTL, isDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(isDark, size: 120),
            const SizedBox(height: 48),
            _buildWelcomeText(context, localizations, isDark),
            const SizedBox(height: 56),
            _buildLoginForm(context, localizations, isRTL, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return Row(
      children: [
        // Left Side - Branding
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.primaryDark.withValues(alpha: 0.08),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(isDark, size: 180),
                  const SizedBox(height: 32),
                  Text(
                    localizations.translate('app_name'),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations.translate('app_slogan'),
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Right Side - Login Form
        Expanded(
          flex: 5,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeText(context, localizations, isDark),
                    const SizedBox(height: 48),
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

  Widget _buildLogo(bool isDark, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo-p-h.png',
          width: size * 0.6,
          height: size * 0.6,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.hotel_rounded,
              size: size * 0.5,
              color: AppColors.black,
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeText(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Column(
      children: [
        Text(
          localizations.translate('login_welcome'),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          localizations.translate('login_subtitle'),
          style: TextStyle(
            fontSize: 16,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPhoneField(localizations, isRTL, isDark),
        const SizedBox(height: 20),
        _buildPasswordField(localizations, isRTL, isDark),
        const SizedBox(height: 40),
        _buildLoginButton(context, localizations, isRTL, isDark),
        const SizedBox(height: 16),
        _buildGuestButton(context, localizations, isRTL, isDark),
      ],
    );
  }

  Widget _buildPhoneField(
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        boxShadow: _isPhoneFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: _phoneController,
        focusNode: _phoneFocusNode,
        keyboardType: TextInputType.phone,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
        decoration: InputDecoration(
          labelText: isRTL ? 'رقم الهاتف' : 'Phone Number',
          hintText: isRTL ? 'أدخل رقم هاتفك' : 'Enter your phone number',
          labelStyle: TextStyle(
            color: _isPhoneFocused
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
          ),
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary.withValues(alpha: 0.5)
                : AppColors.lightTextSecondary.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: _isPhoneFocused
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
          ),
          filled: true,
          fillColor: isDark
              ? AppColors.darkSurface.withValues(alpha: 0.6)
              : AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        boxShadow: _isPasswordFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: !_isPasswordVisible,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
        decoration: InputDecoration(
          labelText: isRTL ? 'كلمة المرور' : 'Password',
          hintText: isRTL ? 'أدخل كلمة المرور' : 'Enter your password',
          labelStyle: TextStyle(
            color: _isPasswordFocused
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
          ),
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary.withValues(alpha: 0.5)
                : AppColors.lightTextSecondary.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: _isPasswordFocused
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: _isPasswordFocused
                  ? AppColors.primary
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          filled: true,
          fillColor: isDark
              ? AppColors.darkSurface.withValues(alpha: 0.6)
              : AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : () => _handleLogin(context),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizations.translate('login_button'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            isRTL
                                ? Icons.arrow_back_rounded
                                : Icons.arrow_forward_rounded,
                            color: AppColors.black,
                            size: 24,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuestButton(
    BuildContext context,
    AppLocalizations localizations,
    bool isRTL,
    bool isDark,
  ) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : () => _handleContinueAsGuest(context),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isRTL ? 'الدخول كزائر' : 'Continue as Guest',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
