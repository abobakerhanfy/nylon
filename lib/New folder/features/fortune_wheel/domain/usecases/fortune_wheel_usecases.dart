import 'package:nylon/features/fortune_wheel/domain/repositories/fortune_wheel_repository.dart';



/// use case is a class responsible for encapsulating a specific piece of business logic or 
/// a particular operation that your application needs to perform.
/// It acts as a bridge between the presentation
/// layer and the data layer.
class FortuneWheelUseCase {
	  
   final FortuneWheelRepository fortuneWheelRepository;
   FortuneWheelUseCase(this.fortuneWheelRepository);
}