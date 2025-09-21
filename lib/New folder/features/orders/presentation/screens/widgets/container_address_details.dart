import 'package:flutter/material.dart';
import 'package:nylon/core/theme/colors_app.dart';

class AddressDetails extends StatelessWidget {
  final String phone;
  final String address;
  final String city;
  const AddressDetails({
    super.key,
     required this.phone, 
     required this.address,
      required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
             
              children: [
              Icon(Icons.location_on_outlined,color: Colors.grey[500],size: 28,),
              const SizedBox(width: 4,),
              Expanded(

                child: Text(city,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.colorTextBlckNew,fontSize: 16,fontWeight: FontWeight.normal
                ),maxLines: 1,overflow: TextOverflow.ellipsis,),
              ),
             Expanded(
                     
              child: Text(phone,style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 15,color: Colors.grey
              
              ),maxLines: 1,overflow: TextOverflow.ellipsis,))
             
            ],),
            const SizedBox(height: 8,),
            Container(
              child:  Text(address,style: Theme.of(context).textTheme.bodySmall?.copyWith(
               color: AppColors.colorTextBlckNew,fontWeight: FontWeight.normal
                      ),maxLines: 2,overflow: TextOverflow.ellipsis,),
            
            ),
            
          
          
          ],
        ),
      ),
    );
  }
}