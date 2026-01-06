

import 'package:dartz/dartz.dart';
import 'package:untitled/core/error/failure.dart';
import 'package:untitled/data/dataSource/Statistic/statistic_reomte_data_source.dart';
import 'package:untitled/data/models/statistics/statistics_model.dart';
import 'package:untitled/domain/repository/statistics/base_statistics_repository.dart';

import '../../../core/error/exceptions.dart';

class StatisticRepository extends BaseStatisticsRepository {
  final BaseStatisticRemoteDataSource remote;
  StatisticRepository(this.remote);

  @override
  Future<Either<Failure, StatisticsModel>> getStatistic() async {
    try {
      final result = await remote.getStatistic();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }

  @override
  Future<Either<Failure, void>> downloadReport(String type) async {
    try {
      await remote.downloadReport(type);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }
}