import 'package:dartz/dartz.dart';
import 'package:untitled/data/models/statistics/statistics_model.dart';
import '../../../core/error/failure.dart';


abstract class BaseStatisticsRepository {
  Future<Either<Failure, StatisticsModel>> getStatistic();
  Future<Either<Failure, void>> downloadReport(String type);
}
