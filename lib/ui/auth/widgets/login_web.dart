import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alphalens_fend/blocs/login/login_cubit.dart';


class LoginWeb extends StatefulWidget {
  const LoginWeb({super.key});

  @override
  State<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
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
      listener: (context, state) async {  // add async here
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
      child: Row(
        children: [
          // ================= LEFT SIDE: IDENTITY & FOCUS PANEL =================
          Expanded(
            flex: 5,
            child: Container(
              color: isDark ? const Color(0xFF0B1222) : const Color(0xFFF1F5F9),
              padding: const EdgeInsets.all(64.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('α', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300)),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Text(
                      "Sign back into your research console to monitor open ML evaluation pipelines, analyze updated historical growth datasets, and scale system simulations.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= RIGHT SIDE: INTERACTIVE LOGIN INPUT FORM =================
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(64.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Account Sign In',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text("Don't have an account? ", style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13)),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                            child: const Text('Create One', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
                          )
                        ],
                      ),
                      const SizedBox(height: 32),

                      _buildTextField('Username', _usernameController, Icons.person_outline_rounded, false),
                      const SizedBox(height: 16),
                      _buildTextField('Password', _passwordController, Icons.lock_outline_rounded, true),
                      const SizedBox(height: 32),

                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          final isLoading = state is LoginLoading;
                          return ElevatedButton(
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('SIGN IN TO TERMINAL', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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