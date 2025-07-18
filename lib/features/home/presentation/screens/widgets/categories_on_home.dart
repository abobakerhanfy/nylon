import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/languages/function_string.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/category/presentation/controller/controller_category.dart';
import 'package:nylon/features/home/data/models/category_menu.dart';

// ignore: must_be_immutable
class CategoriesOnHome extends StatelessWidget {
 final List<SliderHome>?  products;
 String? nameAr ;
 String? nameEn ;

  

   CategoriesOnHome({super.key, required this.products,this.nameAr,this.nameEn, });

 final ControllerCategory _controller = Get.put(ControllerCategory());
  @override
  Widget build(BuildContext context) {
 
   return 
   products!.isNotEmpty?
  
   Column(
    
     children: [
    if(nameAr !=null || nameEn != null)
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 4),
        child:   Row(
          children: [
            Text(translate(nameAr ?? '',nameEn ?? '',)!,
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                color: AppColors.textColorHome,
              ),textAlign: TextAlign.start,),
               const Spacer(),
          ],
        ),
        
        
      
      ),
       SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, i) => const SizedBox(width: 12),
            itemCount: products!.length,
            itemBuilder: (context, i) {
              
              return CategoriesContainer(
                onTap: () {
                  print( products![i].categoryId);
                  
                 
                 Get.toNamed(NamePages.pOneCategory,arguments:products![i] );
                  // _controller.getOneCategory(idCategory: '112');

                } ,
              
                label: translate(products![i].title,products![i].title)!,
                image: products![i].thumb!,
              );
            },
          ),
        ),
     ],
   ):const SizedBox();
  }
  
}



class CategoriesContainer extends StatelessWidget {
  final  Function() onTap;
  final String label;
  final String image;
  // final BoxConstraints boxSize;

  const CategoriesContainer({super.key, required this.onTap,required this.label, required this.image });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            CachedNetworkImage(
              imageUrl: image,
             imageBuilder: (context, imageProvider)=> CircleAvatar(
                radius:MediaQuery.of(context).size.width*0.11,
                backgroundImage: imageProvider
              ),
              placeholder: (context,url)=>CircleAvatar(
              radius:MediaQuery.of(context).size.width*0.11,
                child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor,))),
              errorWidget: (context, url, error) => CircleAvatar(
                  radius:MediaQuery.of(context).size.width*0.11,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error,color: Colors.red[900],),
                      
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('نعتذر تحميل الصوره !!',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black45,fontSize: 10,fontWeight: FontWeight.normal
                          ),textAlign: TextAlign.center,maxLines: 2,),
                        )
                
                      ],
                    ),
              )),
            
            Text(label,style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black,
            ),maxLines: 1,overflow: TextOverflow.ellipsis,)
          ],
        ),
      ),
    );
  }
}

