part of 'gov_agencies_bloc.dart';

abstract class GovAgenciesEvent extends Equatable {
  const GovAgenciesEvent();

  @override
  List<Object?> get props => [];
}


class FetchGovAgenciesEvent extends GovAgenciesEvent {}
