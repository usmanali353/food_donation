import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Ui/Receiver/RequestFood.dart';
import 'package:food_donation/Utils/StatefulWrapper.dart';
import 'package:get/get.dart';
import '../../Controllers/ReceiverController.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';
import '../DetailPages/FoodRequestDetailPage.dart';

class ReceiverRequestList extends GetView<ReceiverController> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {

    return StatefulWrapper(onInit:(){
      print("onInit");
      controller.getFoodRequests(context);
    }, child: Scaffold(
       floatingActionButton: FloatingActionButton(
         backgroundColor: Color2,
         onPressed: () {
           Get.to(()=>RequestFood());
         },
         child: Icon(Icons.add,color: Color6,),
       ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async
          {
            return await controller.getFoodRequests(context);
          },
          child: Obx(() => ListView.builder(itemCount:controller.foodRequests.length==0?5:controller.foodRequests.length, itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Get.to(()=>FoodRequestDetailPage("Receiver",index));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 180,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(

                              ),
                              Container(
                                //width: MediaQuery.of(context).size.width,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Color2,
                                    border: Border.all(color: Color1, width: 2)
                                ),
                                child:   Center(
                                  child: Text(controller.foodRequests[index].name, style: TextStyle(
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
                                      child:  Center(
                                        child: Text(Utils.getCategoryName(controller.foodRequests[index].category), style: TextStyle(
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
                                        child: Text(controller.foodRequests[index].personsQuantity.toString(), style: TextStyle(
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
                                    child: Center(child: FaIcon(FontAwesomeIcons.calendar, color: Color2, size: 18,)),
                                  ),
                                  SizedBox(width: 4,),
                                  Expanded(
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        //color: Color2,
                                          border: Border.all(color: Color1, width: 2),
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child:   Center(
                                        child: Text(Utils.getFormattedDate(controller.foodRequests[index].createdOn), style: TextStyle(
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
                                        child: Text(Utils.getDeliveryTypeName(controller.foodRequests[index].deliveryType), style: TextStyle(
                                            color: Color2, fontSize: 17, fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2,),
                              // Row(
                              //   children: [
                              //     Container(
                              //       width: 35,
                              //       height: 35,
                              //       decoration: BoxDecoration(
                              //         color: Color1,
                              //         borderRadius: BorderRadius.circular(8),
                              //         border: Border.all(color: Color2, width: 2),
                              //       ),
                              //       child: Center(child: FaIcon(FontAwesomeIcons.mapMarkerAlt, color: Color2, size: 18,)),
                              //     ),
                              //     SizedBox(width: 4,),
                              //     Expanded(
                              //       child: Container(
                              //         height: 35,
                              //         decoration: BoxDecoration(
                              //           //color: Color2,
                              //           border: Border.all(color: Color1, width: 2),
                              //           borderRadius: BorderRadius.circular(8),
                              //         ),
                              //         child:   Center(
                              //           child: Text(Utils.getDeliveryTypeName(controller.foodRequests[index].deliveryType), style: TextStyle(
                              //               color: Color2, fontSize: 17, fontWeight: FontWeight.bold
                              //           ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
                                    child: Center(child: FaIcon(FontAwesomeIcons.mapLocation, color: Color2, size: 18,)),
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
                                        child: Text(controller.foodRequests[index].address, style: TextStyle(
                                            color: Color2, fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2,),
                              // Row(
                              //   children: [
                              //     Container(
                              //       width: 35,
                              //       height: 35,
                              //       decoration: BoxDecoration(
                              //         color: Color1,
                              //         borderRadius: BorderRadius.circular(8),
                              //         border: Border.all(color: Color2, width: 2),
                              //       ),
                              //       child: Center(child: FaIcon(FontAwesomeIcons.phone, color: Color2, size: 18,)),
                              //     ),
                              //     SizedBox(width: 4,),
                              //     Expanded(
                              //       child: Container(
                              //         height: 35,
                              //         decoration: BoxDecoration(
                              //           //color: Color2,
                              //           border: Border.all(color: Color1, width: 2),
                              //           borderRadius: BorderRadius.circular(8),
                              //         ),
                              //         child:   Center(
                              //           child: Text(Utils.getDeliveryTypeName(controller.foodRequests[index].deliveryType), style: TextStyle(
                              //               color: Color2, fontSize: 17, fontWeight: FontWeight.bold
                              //           ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }),)
      ),
    )) ;
  }
}
