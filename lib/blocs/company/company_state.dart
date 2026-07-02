part of 'company_cubit.dart';

@immutable
sealed class CompanyState {}

final class CompanyInitial extends CompanyState {}

final class CompanyLoading extends CompanyState {}

final class CompanyLoaded extends CompanyState {
  final CompanyModel company; // 👈 Strongly typed!

  CompanyLoaded({required this.company});
}

final class CompanyError extends CompanyState {
  final String message;

  CompanyError({required this.message});
}
