import 'package:nylon/features/fortune_wheel/domain/repositories/fortune_wheel_repository.dart';
import 'package:nylon/features/fortune_wheel/data/data_sources/fortune_wheel_data_source.dart';



/// FortuneWheelRepositoryImpl is the concrete implementation of the FortuneWheelRepository
/// interface.
/// This class implements the methods defined in FortuneWheelRepository to interact
/// with data. It acts as a bridge between the domain layer
/// (use cases) and the data layer (data sources).
class FortuneWheelRepositoryImpl implements FortuneWheelRepository {
      
   final FortuneWheelDataSource  fortuneWheelDataSource;
   FortuneWheelRepositoryImpl(this.fortuneWheelDataSource);
}