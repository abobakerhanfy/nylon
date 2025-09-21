import 'package:nylon/features/one_product/domain/repositories/one_product_repository.dart';
import 'package:nylon/features/one_product/data/data_sources/one_product_data_source.dart';



/// OneProductRepositoryImpl is the concrete implementation of the OneProductRepository
/// interface.
/// This class implements the methods defined in OneProductRepository to interact
/// with data. It acts as a bridge between the domain layer
/// (use cases) and the data layer (data sources).
class OneProductRepositoryImpl implements OneProductRepository {
      
   final OneProductDataSource  oneProductDataSource;
   OneProductRepositoryImpl(this.oneProductDataSource);
}