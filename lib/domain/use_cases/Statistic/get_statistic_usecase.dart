import 'package:dartz/dartz.dart';
import 'package:untitled/data/models/statistics/statistics_model.dart';
import 'package:untitled/domain/repository/statistics/base_statistics_repository.dart';
import '../../../../core/error/failure.dart';

class GetStatisticUseCase  {
  final BaseStatisticsRepository repository;

  GetStatisticUseCase(this.repository);

  Future<Either<Failure, StatisticsModel>> call() {
    return repository.getStatistic();
  }
}
