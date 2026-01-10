part of 'gov_agencies_bloc.dart';

abstract class GovAgenciesState extends Equatable {
  const GovAgenciesState();

  @override
  List<Object?> get props => [];
}

class GovAgenciesInitial extends GovAgenciesState {}

class GovAgenciesLoading extends GovAgenciesState {}

class GovAgenciesLoaded extends GovAgenciesState {
  final List<Datum> agencies;
  const GovAgenciesLoaded(this.agencies);

  @override
  List<Object?> get props => [agencies];
}

class GovAgenciesError extends GovAgenciesState {
  final String message;
  const GovAgenciesError(this.message);

  @override
  List<Object?> get props => [message];
}