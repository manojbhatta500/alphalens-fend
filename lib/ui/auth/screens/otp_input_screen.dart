import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alphalens_fend/blocs/otp/otp_cubit.dart';
import 'package:alphalens_fend/blocs/theme/theme_cubit.dart';

class OtpInputScreen extends StatefulWidget {
  final String email;

  const OtpInputScreen({
    super.key, 
    required this.email,
  });

  @override
  State<OtpInputScreen> createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  // Timer settings
  Timer? _countdownTimer;
  int _secondsRemaining = 300; // 5 minutes standard countdown window

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _countdownTimer?.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _formatTimerText() {
    final int minutes = _secondsRemaining ~/ 60;
    final int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _executeTokenSubmission(String resolvedEmail) {
    if (_secondsRemaining == 0) {
      _showFeedback('⏰ Code expired. Please cancel and request a New Code.', Colors.red[700]!);
      return;
    }

    final otpCode = _controllers.map((c) => c.text).join();
    
    if (otpCode.length < 6) {
      _showFeedback('🛑 Please input all 6 verification digits.', Colors.amber[800]!);
      return;
    }

    context.read<OtpCubit>().verifyOtpToken(
          email: resolvedEmail,
          otp: otpCode,
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Direct Web Route Argument fallback extraction check to handle hot reloads perfectly
    final dynamic routingArg = ModalRoute.of(context)?.settings.arguments;
    final String activeEmail = (routingArg is String && routingArg.isNotEmpty) 
        ? routingArg 
        : (widget.email.isNotEmpty ? widget.email : "your registered email");

    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpFailed) {
          _showFeedback(state.message, Colors.red[700]!);
        }
        if (state is OtpSuccess) {
          _showFeedback('✨ Terminal Account Verified.', Colors.green);
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      builder: (context, state) {
        final isLoading = state is OtpLoading;
        final isExpired = _secondsRemaining == 0;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B1222) : const Color(0xFFF1F5F9),
          body: SafeArea(
            child: Stack(
              children: [
                // ================= UNIFIED RESPONSIVE CONTAINER =================
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWeb = constraints.maxWidth > 700;
                    
                    return Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOutCubic,
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: isWeb ? 540 : 400,
                            ),
                            decoration: BoxDecoration(
                              color: isDark 
                                  ? (isWeb ? theme.colorScheme.surfaceContainerLow : Colors.transparent) 
                                  : (isWeb ? Colors.white : Colors.transparent),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: isWeb && !isDark
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, spreadRadius: 4)]
                                  : [],
                              border: isWeb
                                  ? Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.08))
                                  : null,
                            ),
                            padding: EdgeInsets.all(isWeb ? 48.0 : 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.shield_outlined, color: Colors.blue, size: 26),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                Text(
                                  'Security Verification',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                Text(
                                  'We have transmitted a 6-digit one-time authorization token to "$activeEmail". Enter it below to activate your system terminal node.',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // ================= 5-MINUTE TICKING COUNTDOWN CLOCK =================
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.hourglass_top_rounded, 
                                      size: 16, 
                                      color: isExpired ? Colors.redAccent : Colors.blue
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isExpired ? "Token Expired" : "Code expires in: ${_formatTimerText()}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: isExpired ? Colors.redAccent : (isDark ? Colors.grey[300] : Colors.grey[700]),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // ================= 6-INPUT DIGIT PANEL MATRIX =================
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    6, 
                                    (index) => _buildOtpSlot(index, isWeb, theme, isDark, isLoading || isExpired, activeEmail)
                                  ),
                                ),
                                const SizedBox(height: 36),

                                // Dynamic Submit Action Button Block managed by state
                                isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 14.0),
                                        child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
                                      )
                                    : ElevatedButton(
                                        onPressed: isExpired ? null : () => _executeTokenSubmission(activeEmail),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          isExpired ? 'TOKEN EXPIRED' : 'VERIFY ACCOUNT NOW', 
                                          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                                        ),
                                      ),
                                const SizedBox(height: 24),

                                // Cancel process link back to root/landing screen
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: isLoading ? null : () {
                                        _countdownTimer?.cancel();
                                        Navigator.pushReplacementNamed(context, '/');
                                      },
                                      child: const Text(
                                        'Cancel & Return Home', 
                                        style: TextStyle(
                                          color: Colors.redAccent, 
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // ================= GLOBAL PERSISTENT THEME TOGGLE BUTTON =================
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpSlot(int index, bool isWeb, ThemeData theme, bool isDark, bool isDisabled, String resolvedEmail) {
    final boxWidth = isWeb ? 62.0 : 48.0;

    return SizedBox(
      width: boxWidth,
      height: boxWidth + 4,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent && 
              event.logicalKey == LogicalKeyboardKey.backspace && 
              _controllers[index].text.isEmpty && 
              index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          autofocus: index == 0,
          enabled: !isDisabled,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isWeb ? 22 : 18, 
            fontWeight: FontWeight.bold, 
            color: isDark ? Colors.white : Colors.black87
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!, 
                width: 1.5
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2.2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey[200]!, 
                width: 1.5
              ),
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF131C2E) : Colors.white,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
            if (value.isNotEmpty && index == 5) {
              _executeTokenSubmission(resolvedEmail);
            }
          },
        ),
      ),
    );
  }
}