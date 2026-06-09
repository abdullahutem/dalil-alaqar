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

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _resetEmailController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  // Animation controllers
  late AnimationController _logoAnimationController;
  late AnimationController _formAnimationController;
  late AnimationController _pulseAnimationController;

  // Logo animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _pulseAnimation;

  // Form animations
  late Animation<double> _formFadeAnimation;
  late Animation<Offset> _formSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _setupFocusListeners();
  }

  void _initAnimations() {
    // Logo entrance animation
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScaleAnimation = CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    );

    _logoRotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Continuous pulse animation for logo
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimationController.repeat(reverse: true);

    // Form entrance animation
    _formAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _formFadeAnimation = CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeIn,
    );

    _formSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _formAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animations with staggered delay
    _logoAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _formAnimationController.forward();
    });
  }

  void _setupFocusListeners() {
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
    _logoAnimationController.dispose();
    _formAnimationController.dispose();
    _pulseAnimationController.dispose();
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

    context.read<AuthCubit>().login(phoneNumber: email, password: password);
  }

  bool _isValidEmail(String v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);

  void _showSnackBar(BuildContext context, String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color ?? Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildAnimatedHeader(localizations, isDark),
          FadeTransition(
            opacity: _formFadeAnimation,
            child: SlideTransition(
              position: _formSlideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeText(localizations, isDark, isRTL),
                    const SizedBox(height: 28),
                    _buildLoginForm(context, localizations, isRTL, isDark),
                  ],
                ),
              ),
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
        Expanded(flex: 5, child: _buildAnimatedSidePanel(localizations)),
        Expanded(
          flex: 5,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(48),
              child: FadeTransition(
                opacity: _formFadeAnimation,
                child: SlideTransition(
                  position: _formSlideAnimation,
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
          ),
        ),
      ],
    );
  }

  // ─── Animated Header (Mobile) ────────────────────────────────────────────────

  Widget _buildAnimatedHeader(AppLocalizations localizations, bool isDark) {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
                AppColors.primary.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              _buildAnimatedLogo(size: 100),
              const SizedBox(height: 20),
              _buildAppName(localizations),
              const SizedBox(height: 8),
              _buildAppSlogan(localizations),
            ],
          ),
        );
      },
    );
  }

  // ─── Animated Side Panel (Tablet) ────────────────────────────────────────────

  Widget _buildAnimatedSidePanel(AppLocalizations localizations) {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
                AppColors.primary.withValues(alpha: 0.85),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              ..._buildDecorativeCircles(),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAnimatedLogo(size: 180),
                    const SizedBox(height: 32),
                    _buildAppName(localizations, fontSize: 36),
                    const SizedBox(height: 12),
                    _buildAppSlogan(localizations, fontSize: 18),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildDecorativeCircles() {
    return [
      Positioned(
        top: -50,
        left: -50,
        child: AnimatedBuilder(
          animation: _pulseAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value * 0.8,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            );
          },
        ),
      ),
      Positioned(
        bottom: 100,
        right: -80,
        child: AnimatedBuilder(
          animation: _pulseAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value * 0.6,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            );
          },
        ),
      ),
      Positioned(
        top: 200,
        right: 50,
        child: AnimatedBuilder(
          animation: _pulseAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value * 0.5,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  // ─── Animated Logo ───────────────────────────────────────────────────────────

  Widget _buildAnimatedLogo({required double size}) {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.rotate(
            angle: _logoRotationAnimation.value,
            child: AnimatedBuilder(
              animation: _pulseAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.25),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(size * 0.18),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.real_estate_agent_rounded,
                          size: size * 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ─── App Name & Slogan ───────────────────────────────────────────────────────

  Widget _buildAppName(AppLocalizations localizations, {double fontSize = 26}) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, Color(0xFFE0F7FA)],
      ).createShader(bounds),
      child: Text(
        localizations.translate('app_name'),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAppSlogan(
    AppLocalizations localizations, {
    double fontSize = 15,
  }) {
    return Text(
      localizations.translate('app_slogan'),
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white.withValues(alpha: 0.85),
        letterSpacing: 0.5,
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          localizations.translate('login_subtitle'),
          style: TextStyle(
            fontSize: 12,
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
        _buildAnimatedField(delay: 0, child: _buildEmailField(isRTL, isDark)),
        const SizedBox(height: 18),
        _buildAnimatedField(
          delay: 100,
          child: _buildPasswordField(isRTL, isDark),
        ),
        const SizedBox(height: 32),
        _buildAnimatedField(
          delay: 200,
          child: _buildLoginButton(context, localizations, isRTL),
        ),
      ],
    );
  }

  Widget _buildAnimatedField({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
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
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                _isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                key: ValueKey(_isPasswordVisible),
                size: 20,
                color: _isPasswordFocused ? AppColors.primary : Colors.grey,
              ),
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
    final borderColor = focused
        ? AppColors.primary
        : (isDark ? Colors.white24 : const Color(0xFFE0E0E0));

    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: focused ? AppColors.primary : inactiveColor,
        fontSize: 14,
        fontWeight: focused ? FontWeight.w500 : FontWeight.normal,
      ),
      hintStyle: TextStyle(
        color: inactiveColor.withValues(alpha: 0.6),
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: focused ? AppColors.primary : inactiveColor,
        size: 20,
      ),
      suffixIcon: suffix,
      filled: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor, width: focused ? 1.5 : 0.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? Colors.white24 : const Color(0xFFE0E0E0),
          width: 0.8,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
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
          height: 52,
          child: _AnimatedLoginButton(
            isLoading: isLoading,
            onPressed: isLoading ? null : () => _handleLogin(context),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedRotation(
                        turns: isRTL ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          color: AppColors.white,
                          Icons.arrow_forward_rounded,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        localizations.translate('login_button'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// ─── Animated Login Button ─────────────────────────────────────────────────────

class _AnimatedLoginButton extends StatefulWidget {
  const _AnimatedLoginButton({
    required this.onPressed,
    required this.child,
    required this.isLoading,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;

  @override
  State<_AnimatedLoginButton> createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<_AnimatedLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: Center(child: widget.child),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Field wrapper with animated border ──────────────────────────────────────

class _FieldWrapper extends StatelessWidget {
  const _FieldWrapper({required this.focused, required this.child});

  final bool focused;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}
