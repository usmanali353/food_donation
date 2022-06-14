import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Utils/StatefulWrapper.dart';
import 'package:get/get.dart';
import '../../Controllers/AdminController.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';
import '../DetailPages/FoodRequestDetailPage.dart';

class RequestsListForAdmin  extends GetView<AdminController> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  int type;

  RequestsListForAdmin(this.type);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit:(){
          controller.getRequestsByType(context,type);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(type==0?"Pending Requests":"Concluded Requests"),
            centerTitle: true,
            backgroundColor: Color2,
          ),
          body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async
              {
                return await controller.getRequestsByType(context,type);
              },
              child: Obx(() => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        //color: Colors.white12,
                        child: controller.buildChips(context,"Food Requests")
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(itemCount:!controller.foodRequestsLoading.value?controller.filteredList.length:5, itemBuilder: (context, index){
                      return !controller.foodRequestsLoading.value? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            log("type: "+type.toString());
                            if(type==1){
                              Get.to(()=>FoodRequestDetailPage("Admin",index,donationId: controller.filteredList[index].id,isHistory: true,));
                            }else{
                              Get.to(()=>FoodRequestDetailPage("Admin",index,donationId: controller.filteredList[index].id,));
                            }
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
                                                child:  Center(
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
                                                  child: Text(Utils.getFormattedDate(controller.filteredList[index].createdOn), style: TextStyle(
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
                                        //           child: Text(Utils.getDeliveryTypeName(controller.filteredList[index].deliveryType), style: TextStyle(
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
                                                  child: Text(controller.filteredList[index].address, style: TextStyle(
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
                                        //           child: Text(Utils.getDeliveryTypeName(controller.filteredList[index].deliveryType), style: TextStyle(
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
                      ):Utils.getRequestListShimmer();
                    }),
                  ),
                ],
              ),)
          ),
        ),
    );
  }
}
