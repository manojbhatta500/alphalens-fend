part of 'otp_cubit.dart';

@immutable
sealed class OtpState {}

final class OtpInitial extends OtpState {}


final class OtpLoading extends OtpState {}


final class OtpSuccess extends OtpState {
  final String message ;
  OtpSuccess({this.message = 'OTP verified successfully.'});
}

final class OtpFailed extends OtpState {
  final String message ;

  OtpFailed({required this.message});

}
