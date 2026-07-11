part of 'extract_entity_cubit.dart';

@immutable
sealed class ExtractEntityState {}

final class ExtractEntityInitial extends ExtractEntityState {}
final class ExtractEntityLoading extends ExtractEntityState {}
final class ExtractEntitySuccess extends ExtractEntityState {
  final ExtarctEntityModel extractEntityModel;

  ExtractEntitySuccess(this.extractEntityModel);
}
final class ExtractEntityError extends ExtractEntityState {
  final String message;

  ExtractEntityError(this.message);
}
