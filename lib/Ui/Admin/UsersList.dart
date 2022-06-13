import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Controllers/AdminController.dart';
import 'package:food_donation/Utils/StatefulWrapper.dart';
import 'package:get/get.dart';

import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';

class UsersList extends GetView<AdminController>{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: (){
        controller.getUsersByRole(context, roleId);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Users", style: TextStyle(
              color: Color6,
              fontWeight: FontWeight.bold,
              fontSize: 25
          ),),
          centerTitle: true,
          backgroundColor: Color2,
        ),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: ()async{
              return await controller.getUsersByRole(context, roleId);
            },
            child: Obx(() => ListView.builder(itemCount:!controller.userListLoading.value?controller.usersList.length:5, itemBuilder: (context, index){
              return !controller.userListLoading.value? Card(
                elevation: 8,
                color: Color6,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 100,
                  child: Row(
                    children: [
                      Container(
                        height: 125,
                        width: 125,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color1, width: 2),
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage("Assets/charitylogo.png")
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
                                  child: Text(controller.usersList[index].name, style: TextStyle(
                                      color: Color6, fontSize: 20, fontWeight: FontWeight.bold
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
                                    child: Center(child: FaIcon(FontAwesomeIcons.at, color: Color2, size: 18,)),
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
                                        child: Text(controller.usersList[index].email, style: TextStyle(
                                            color: Color2, fontSize: 16, fontWeight: FontWeight.bold
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
                                    child: Center(child: FaIcon(FontAwesomeIcons.phoneAlt, color: Color2, size: 18,)),
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
                                        child: Text(controller.usersList[index].phone, style: TextStyle(
                                            color: Color2, fontSize: 16, fontWeight: FontWeight.bold
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
              ):Utils.getUsersListShimmer();
            }),)
        ),
      ),
    );

  }
  int roleId;
  UsersList({this.roleId=0});
}

