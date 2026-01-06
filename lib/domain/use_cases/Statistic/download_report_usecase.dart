
import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repository/statistics/base_statistics_repository.dart';

class DownloadReportUseCase {
  final BaseStatisticsRepository repository;
  DownloadReportUseCase(this.repository);

  Future<Either<Failure, void>> call(String type) {
    return repository.downloadReport(type);
  }
}