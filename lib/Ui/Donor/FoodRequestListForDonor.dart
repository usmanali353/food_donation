import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Controllers/DonorController.dart';
import 'package:food_donation/Utils/StatefulWrapper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';
import '../DetailPages/FoodRequestDetailPage.dart';

class FoodRequestListForDonor extends GetView<DonorController> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: (){
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color6),
          backgroundColor: !Get.isDarkMode?Color2:Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          title: Text("Food Requests", style: TextStyle(
              color: Color6, fontWeight: FontWeight.bold, fontSize: 25
          ),

          ),
          actions: [
            IconButton(onPressed: (){
              Geolocator.getCurrentPosition().then((position){
                print(Geolocator.distanceBetween(position.latitude, position.longitude, 32.5691129320724, 74.0745348483324));
              });
            }, icon: Icon(Icons.filter))
          ],
        ),

        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async
          {
            return await controller.getFoodRequests(context);
          },
          child: Obx(() => ListView.builder(itemCount:controller.foodRequests.length, itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Get.to(()=>FoodRequestDetailPage("Donor",index,donationId: controller.foodRequests[index].id,));
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
      ),
    );
  }
}
