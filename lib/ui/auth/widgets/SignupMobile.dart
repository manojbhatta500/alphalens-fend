import 'package:alphalens_fend/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/signup/signup_cubit.dart';




class SignupMobile extends StatefulWidget {
  const SignupMobile({super.key});

  @override
  State<SignupMobile> createState() => _SignupMobileState();
}

class _SignupMobileState extends State<SignupMobile> {
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

    return Container(
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
                            const SizedBox(height: 36), // Extra spacing to clear the top-right toggle button
                            
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
                                  'Join AlphaLens',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 3,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Deploy specialized AI nodes, run custom predictive model iterations, and evaluate macro ecosystem interactions through our high-performance workbench computing modules.",
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
                                      'Create Account',
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
                                          'Already have an account? ', 
                                          style: TextStyle(
                                            color: isDark ? Colors.grey[400] : Colors.grey[600], 
                                            fontSize: 13,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                                          child: const Text(
                                            'Sign In', 
                                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 24),

                                    _buildTextField('Username', _usernameController, Icons.person_outline_rounded, false),
                                    const SizedBox(height: 16),
                                    _buildTextField('Email Address', _emailController, Icons.mail_outline_rounded, false),
                                    const SizedBox(height: 16),
                                    _buildTextField('Password', _passwordController, Icons.lock_outline_rounded, true),
                                    const SizedBox(height: 16),
                                    _buildTextField('Confirm Password', _confirmPasswordController, Icons.lock_outline_rounded, true),
                                    const SizedBox(height: 28),

                                    // Submit Form Action dynamic status rendering block
                                    BlocConsumer<SignupCubit, SignupState>(
                                      listener: (context, state) {
                                        if (state is SignupFailure) {
                                          _showFeedback(state.errorMessage, Colors.redAccent);
                                        }
                                        if (state is SignupSuccess) {
                                          _showFeedback(state.message, Colors.green[700]!);
                                          
                                          _usernameController.clear();
                                          _emailController.clear();
                                          _passwordController.clear();
                                          _confirmPasswordController.clear();

                                          Navigator.pushReplacementNamed(context, '/login');
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
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            'REGISTER ACCOUNT', 
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