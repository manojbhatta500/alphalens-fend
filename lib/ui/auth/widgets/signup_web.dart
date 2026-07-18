import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/signup/signup_cubit.dart';

class SignupWeb extends StatefulWidget {
  const SignupWeb({super.key});

  @override
  State<SignupWeb> createState() => _SignupWebState();
}

class _SignupWebState extends State<SignupWeb> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Core Validation Handler Execution Block calling your decoupled Cubit
  void _handleRegistration() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // 1. Check for completely empty fields
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showFeedback('🛑 All input credentials fields are required.', Colors.amber[800]!);
      return;
    }

    // 2. Simple regex string verification check for standard email shape
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showFeedback('🛑 Please provide a valid email address form.', Colors.redAccent);
      return;
    }

    // 3. Match checking mechanism for password parity match
    if (password != confirmPassword) {
      _showFeedback('🛑 Passwords do not match. Verify your entries.', Colors.redAccent);
      return;
    }

    // 4. Fire your modular state machine to process remote network verification pipelines
    context.read<SignupCubit>().registerNewUser(
          username: username,
          email: email,
          password: password,
        );
  }

  // Centralized Snackbar Scaffold Utility
  void _showFeedback(String message, Color statusColor) {
    ScaffoldMessenger.of(context).clearSnackBars(); // Wipe out any lingering active messages immediately
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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
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
                  'Join AlphaLens',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w300,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Text(
                    "Deploy specialized AI nodes, run custom predictive model iterations, and evaluate macro ecosystem interactions through our high-performance workbench computing modules.",
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

        // ================= RIGHT SIDE: INTERACTIVE SIGNUP INPUT FORM =================
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(64.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create Account',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Already have an account? ', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13)),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text('Sign In', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
                          )
                        ],
                      ),
                      const SizedBox(height: 32),

                      _buildTextField('Username', _usernameController, Icons.person_outline_rounded, false),
                      const SizedBox(height: 16),
                      _buildTextField('Email Address', _emailController, Icons.mail_outline_rounded, false),
                      const SizedBox(height: 16),
                      _buildTextField('Password', _passwordController, Icons.lock_outline_rounded, true),
                      const SizedBox(height: 16),
                      _buildTextField('Confirm Password', _confirmPasswordController, Icons.lock_outline_rounded, true),
                      const SizedBox(height: 32),

                      // Submit Form Action linked safely via the stream manager layout block
                      BlocConsumer<SignupCubit, SignupState>(
                        listener: (context, state) {
                          if (state is SignupFailure) {
                            // Automatically catches and pops up your FastAPI/Pydantic validation messages
                            _showFeedback(state.errorMessage, Colors.redAccent);
                          }
                          if (state is SignupSuccess) {
                            _showFeedback("Now verify your email via Otp", Colors.green[700]!);

                            final String userEmail = _emailController.text.trim();
                            
                            // Wipe the view elements cleanly on a confirmed backend write
                            _usernameController.clear();
                            _emailController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();

                            // Redirect to your named login terminal view
                            // Navigator.pushReplacementNamed(context, '/login');
                            Navigator.pushReplacementNamed(
                            context, 
                            '/otp-verify',
                            arguments: userEmail, 
                          );
                          }
                        },
                        builder: (context, state) {
                          if (state is SignupLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
                            );
                          }

                          return ElevatedButton(
                            onPressed: _handleRegistration,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text('REGISTER ACCOUNT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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