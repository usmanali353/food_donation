import 'dart:developer';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Controllers/ReceiverController.dart';
import 'package:food_donation/Ui/DetailPages/DonationDetails.dart';
import 'package:food_donation/Utils/StatefulWrapper.dart';
import 'package:get/get.dart';

import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';

class UnReceivedDonations extends GetView<ReceiverController> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    
     return StatefulWrapper(onInit:(){
       controller.getUnReceivedDonations(context);
     }, child: Scaffold(
       floatingActionButton: FloatingActionButton(
         backgroundColor: Color2,
         onPressed: () {
           if(controller.donations.length>0) {
             controller.filterByDistance(context);
           }else{
             Utils.showError(context,"No Donations to Filter");
           }
         },
         child: FaIcon(FontAwesomeIcons.filter),
       ),
       body: RefreshIndicator(
           key: _refreshIndicatorKey,
           onRefresh: () async{
             return await controller.getUnReceivedDonations(context);
           },
           child: Obx(() => Column(
             children: [
               Padding(
                 padding: const EdgeInsets.all(3.0),
                 child: Container(
                     width: MediaQuery.of(context).size.width,
                     height: 50,
                     //color: Colors.white12,
                     child: controller.buildChips(context)
                 ),
               ),
               Expanded(
                 child: ListView.builder(itemCount:!controller.fetchingPendingDonations.value?controller.filteredList.length:5, itemBuilder: (context, index){
                   return !controller.fetchingPendingDonations.value? Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: InkWell(
                       onTap: (){
                         //log(controller.filteredList[index].id);
                         Get.to(()=>DonationDetailsScreen(index,"Receiver",donationId: controller.filteredList[index].id,));
                       },
                       child: Container(
                         width: MediaQuery.of(context).size.width,
                         // height: 180,
                         child: Row(
                           children: [
                             Container(
                               height: 185,
                               width: 130,

                               decoration: BoxDecoration(
                                   color: Colors.black54,
                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                                   border: Border.all(color: Color1, width: 2),
                                   image: DecorationImage(
                                       fit: BoxFit.cover,
                                       image: NetworkImage(controller.filteredList[index].images[0])
                                   )
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 crossAxisAlignment: CrossAxisAlignment.end,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(4.0),
                                     child: Container(
                                       width: 150,
                                       height: 40,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
                                       ),
                                       child:  AvatarStack(
                                         borderColor: Color1,
                                         borderWidth: 2.5,
                                         height: 50,
                                         avatars: [
                                           for (var n = 1; n < controller.filteredList[index].images.length; n++)
                                             NetworkImage(controller.filteredList[index].images[n])
                                         ],
                                       ),
                                     ),
                                   )
                                 ],
                               ),
                             ),
                             SizedBox(width: 5,),
                             Expanded(
                               child: Container(
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Container(
                                       //width: MediaQuery.of(context).size.width,
                                       height: 35,
                                       decoration: BoxDecoration(
                                           color: Color2,
                                           border: Border.all(color: Color1, width: 2)
                                       ),
                                       child:   Center(
                                         child: Text(controller.filteredList[index].name, style: TextStyle(
                                             color: Color6, fontSize: 25, fontWeight: FontWeight.bold
                                         ),
                                         ),
                                       ),
                                     ),
                                     SizedBox(height: 4,),
                                     Row(
                                       children: [
                                         Container(
                                           width: 35,
                                           height: 35,
                                           decoration: BoxDecoration(
                                             color: Color1,
                                             borderRadius: BorderRadius.circular(8),
                                             border: Border.all(color: Color2, width: 2),
                                           ),
                                           child: Center(child: FaIcon(FontAwesomeIcons.sitemap, color: Color2, size: 18,)),
                                         ),
                                         SizedBox(width: 4,),
                                         Expanded(
                                           child: Container(
                                             height: 35,
                                             decoration: BoxDecoration(
                                               //color: Color2,
                                               border: Border.all(color: Color1, width: 2),
                                               borderRadius: BorderRadius.circular(8),
                                             ),
                                             child:   Center(
                                               child: Text(Utils.getCategoryName(controller.filteredList[index].category), style: TextStyle(
                                                   color: Color2, fontSize: 18, fontWeight: FontWeight.bold
                                               ),
                                               ),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                     SizedBox(height: 2,),
                                     Row(
                                       children: [
                                         Container(
                                           width: 35,
                                           height: 35,
                                           decoration: BoxDecoration(
                                             color: Color1,
                                             borderRadius: BorderRadius.circular(8),
                                             border: Border.all(color: Color2, width: 2),
                                           ),
                                           child: Center(child: FaIcon(FontAwesomeIcons.users, color: Color2, size: 18,)),
                                         ),
                                         SizedBox(width: 4,),
                                         Expanded(
                                           child: Container(
                                             height: 35,
                                             decoration: BoxDecoration(
                                               //color: Color2,
                                               border: Border.all(color: Color1, width: 2),
                                               borderRadius: BorderRadius.circular(8),
                                             ),
                                             child:   Center(
                                               child: Text(controller.filteredList[index].personsQuantity.toString(), style: TextStyle(
                                                   color: Color2, fontSize: 17, fontWeight: FontWeight.bold
                                               ),
                                               ),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                     SizedBox(height: 2,),
                                     Row(
                                       children: [
                                         Container(
                                           width: 35,
                                           height: 35,
                                           decoration: BoxDecoration(
                                             color: Color1,
                                             borderRadius: BorderRadius.circular(8),
                                             border: Border.all(color: Color2, width: 2),
                                           ),
                                           child: Center(child: FaIcon(FontAwesomeIcons.hourglassStart, color: Color2, size: 18,)),
                                         ),
                                         SizedBox(width: 4,),
                                         Expanded(
                                           child: Container(
                                             height: 35,
                                             decoration: BoxDecoration(
                                               //color: Color2,
                                               border: Border.all(color: Color1, width: 2),
                                               borderRadius: BorderRadius.circular(8),
                                             ),
                                             child: Center(
                                               child: Text(controller.filteredList[index].availableUpTo, style: TextStyle(
                                                   color: Color2, fontSize: 17, fontWeight: FontWeight.bold
                                               ),
                                               ),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                     SizedBox(height: 2,),
                                     Row(
                                       children: [
                                         Container(
                                           width: 35,
                                           height: 35,
                                           decoration: BoxDecoration(
                                             color: Color1,
                                             borderRadius: BorderRadius.circular(8),
                                             border: Border.all(color: Color2, width: 2),
                                           ),
                                           child: Center(child: FaIcon(FontAwesomeIcons.truck, color: Color2, size: 18,)),
                                         ),
                                         SizedBox(width: 4,),
                                         Expanded(
                                           child: Container(
                                             height: 35,
                                             decoration: BoxDecoration(
                                               //color: Color2,
                                               border: Border.all(color: Color1, width: 2),
                                               borderRadius: BorderRadius.circular(8),
                                             ),
                                             child:   Center(
                                               child: Text(Utils.getDeliveryTypeName(controller.filteredList[index].deliveryType), style: TextStyle(
                                                   color: Color2, fontSize: 17, fontWeight: FontWeight.bold
                                               ),
                                               ),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),

                                   ],
                                 ),
                               ),
                             ),

                           ],
                         ),
                       ),
                     ),
                   ):Utils.getDonationListShimmer();
                 }),
               ),
             ],
           ))
       ),
     ));
  }
}
