import 'package:nylon/features/one_product/domain/repositories/one_product_repository.dart';



/// use case is a class responsible for encapsulating a specific piece of business logic or 
/// a particular operation that your application needs to perform.
/// It acts as a bridge between the presentation
/// layer and the data layer.
class OneProductUseCase {
	  
   final OneProductRepository oneProductRepository;
   OneProductUseCase(this.oneProductRepository);
}