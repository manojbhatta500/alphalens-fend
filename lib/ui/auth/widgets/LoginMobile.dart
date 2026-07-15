import 'package:alphalens_fend/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alphalens_fend/blocs/login/login_cubit.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Handle local credentials check before API dispatch
  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showFeedback('🛑 Username and password fields cannot be empty.', Colors.amber[800]!);
      return;
    }

    // dispatch login to cubit
    context.read<LoginCubit>().login(
      username: username,
      password: password,
    );
  }

  void _showFeedback(String message, Color statusColor) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white),
        ),
        backgroundColor: statusColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          _showFeedback('✨ Identity verified.', Colors.green);
          _usernameController.clear();
          _passwordController.clear();

          await Future.delayed(const Duration(seconds: 1));
          
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        }

        if (state is LoginFailure) {
          _showFeedback('🛑 ${state.error}', Colors.red[700]!);
        }
      },
      child: Container(
        color: isDark ? const Color(0xFF0B1222) : const Color(0xFFF1F5F9),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Stack(
            children: [
              // ================= MAIN SCROLLABLE CONTENT =================
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 36), // Extra spacing to clear top-right theme toggler
                              
                              // ================= TOP SECTION: IDENTITY & BRANDING =================
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'α', 
                                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w300)
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Welcome Back',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Sign back into your research console to monitor open ML evaluation pipelines, analyze updated historical growth datasets, and scale system simulations.",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 40),

                              // ================= BOTTOM SECTION: INTERACTIVE INPUT FORM =================
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDark ? theme.colorScheme.surfaceContainerLow : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: theme.colorScheme.outline.withOpacity(0.08),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Account Sign In',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold, 
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Wrap(
                                        alignment: WrapAlignment.start,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            "Don't have an account? ", 
                                            style: TextStyle(
                                              color: isDark ? Colors.grey[400] : Colors.grey[600], 
                                              fontSize: 13,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                                            child: const Text(
                                              'Create One', 
                                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 24),

                                      _buildTextField('Username', _usernameController, Icons.person_outline_rounded, false),
                                      const SizedBox(height: 16),
                                      _buildTextField('Password', _passwordController, Icons.lock_outline_rounded, true),
                                      const SizedBox(height: 28),

                                      // Submit Form State Builder
                                      BlocBuilder<LoginCubit, LoginState>(
                                        builder: (context, state) {
                                          final isLoading = state is LoginLoading;
                                          return ElevatedButton(
                                            onPressed: isLoading ? null : _handleLogin,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              elevation: 0,
                                            ),
                                            child: isLoading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                                  )
                                                : const Text(
                                                    'SIGN IN TO TERMINAL', 
                                                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                                                  ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ================= CORNER THEME TOGGLE BUTTON =================
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, letterSpacing: 1),
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}

