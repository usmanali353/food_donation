import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Controllers/ReceiverController.dart';
import 'package:food_donation/Ui/DetailPages/PaidDonationsDetails.dart';
import 'package:get/get.dart';
import '../../Utils/Constants.dart';
import '../../Utils/StatefulWrapper.dart';
import '../../Utils/Utils.dart';

class PaidDonationListReceiver extends GetView<ReceiverController>{


  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {

    return StatefulWrapper(onInit:(){
      controller.getPricedDonation(context);
    }, child: Scaffold(
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () {
            return  controller.getPricedDonation(context);
          },
          child:  Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Obx(() => Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    //color: Colors.white12,
                    child: controller.buildChipsForPaidDonation(context)
                ),)
              ),
             Obx(() => Expanded(
               child: ListView.builder(itemCount:!controller.fetchingPricedDonation.value?controller.filteredPaidDonations.length:5, itemBuilder: (context, index){
                 return !controller.fetchingPricedDonation.value? Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: InkWell(
                     onTap: (){
                       Get.to(()=>PaidDonationsDetails(index,"Receiver"));
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
                                     image: NetworkImage(controller.filteredPaidDonations[index].singleImage)
                                 )
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
                                       child: Text(controller.filteredPaidDonations[index].name, style: TextStyle(
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
                                         child: Center(child: FaIcon(FontAwesomeIcons.boxesStacked, color: Color2, size: 18,)),
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
                                             child: Text(controller.filteredPaidDonations[index].description, style: TextStyle(
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
                                             child: Text(controller.filteredPaidDonations[index].personsQuantity.toString(), style: TextStyle(
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
                                             child: Text(controller.filteredPaidDonations[index].availableUpTo, style: TextStyle(
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
                                         child: Center(child: FaIcon(FontAwesomeIcons.moneyBill, color: Color2, size: 18,)),
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
                                             child: Text(controller.filteredPaidDonations[index].price.toString(), style: TextStyle(
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
             ))
            ],

          ))
      ),
    );
  }
}