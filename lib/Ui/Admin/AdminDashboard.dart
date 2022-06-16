import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Controllers/AccountController.dart';
import 'package:food_donation/Ui/Admin/DonationListAdmin.dart';
import 'package:food_donation/Ui/Admin/RequestsListForAdmin.dart';
import 'package:food_donation/Ui/Admin/UsersList.dart';
import 'package:food_donation/Utils/StatefulWrapper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/AdminController.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';

class AdminDashboard extends StatelessWidget{
  final adminController = Get.put(AdminController());
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: (){
        adminController.getDashboardCount(context);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Dashboard", style: TextStyle(
                color: Color6,
                fontWeight: FontWeight.bold,
                fontSize: 25
            ),),
            centerTitle: true,
            backgroundColor: Color2,
            actions: [
              IconButton(
                  onPressed: ()async{
                    Get.changeThemeMode(Get.isDarkMode?ThemeMode.light:ThemeMode.dark);
                    SharedPreferences prefs= await SharedPreferences.getInstance();
                    if(prefs.getBool("isDark")==null){
                      prefs.setBool("isDark", true);
                      Get.find<AccountController>().isDarkTheme.value=true;
                    }else{
                      prefs.setBool("isDark", !prefs.getBool("isDark")!);
                      Get.find<AccountController>().isDarkTheme.value=!prefs.getBool("isDark")!;
                    }
                  },
                  icon: FaIcon(FontAwesomeIcons.circleHalfStroke, color: Color6)),
              IconButton(
                onPressed: (){
                  Get.find<AccountController>().logOut();
                }, icon: FaIcon(FontAwesomeIcons.rightFromBracket),
              )
            ],
          ),
          body: Obx(() => !adminController.isDashboardLoading.value?Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 160,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color2, width: 2)
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            //color: Color2,
                                            child:  Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: Color2.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(150)
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        color: Color2.withOpacity(0.5),
                                                        borderRadius: BorderRadius.circular(150)
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          height: 80,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            color: Color6,
                                                            borderRadius: BorderRadius.circular(150),
                                                            image: DecorationImage(
                                                                fit: BoxFit.cover,
                                                                image: AssetImage("Assets/iiblogo.png",)
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("IIB Technologies", style: TextStyle(
                                                  color: Color2,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22
                                              ),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("as ", style: TextStyle(
                                                      color: Color3,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                  ),),
                                                  Text("Super Admin", style: TextStyle(
                                                      color: Color2,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                  ),),

                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                Get.to(()=>UsersList(roleId: 1,));
                              },
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color2, width: 2)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Color2,
                                        child: Center(
                                          child: Text("Donors", style: TextStyle(
                                              color: Color6,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17
                                          ),),
                                        ),
                                      ),
                                      SizedBox(height: 25,),
                                      Center(
                                        child: Text(adminController.counts.value.numberOfDonors.toString(), style: TextStyle(
                                            color: Color2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                Get.to(()=>UsersList(roleId: 2,));
                              },
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color2, width: 2)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Color2,
                                        child: Center(
                                          child: Text("Organizations", style: TextStyle(
                                              color: Color6,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17
                                          ),),
                                        ),
                                      ),
                                      SizedBox(height: 25,),
                                      Center(
                                        child: Text(adminController.counts.value.numberOfReceivers.toString(), style: TextStyle(
                                            color: Color2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                Get.to(()=>RequestsListForAdmin(0));
                              },
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color2, width: 2)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Color2,
                                        child: Center(
                                          child: Text("Pending Requests", style: TextStyle(
                                              color: Color6,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17
                                          ),),
                                        ),
                                      ),
                                      SizedBox(height: 25,),
                                      Center(
                                        child: Text(adminController.counts.value.pendingRequests.toString(), style: TextStyle(
                                            color: Color2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                Get.to(()=>RequestsListForAdmin(1));
                              },
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color2, width: 2)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Color2,
                                        child: Center(
                                          child: Text("Concluded Requests", style: TextStyle(
                                              color: Color6,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17
                                          ),),
                                        ),
                                      ),
                                      SizedBox(height: 25,),
                                      Center(
                                        child: Text(adminController.counts.value.fulfilledRequests.toString(), style: TextStyle(
                                            color: Color2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Expanded(
                            child:InkWell(
                              onTap: (){
                                Get.to(()=>DonationListAdmin(0));
                              },
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color2, width: 2)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Color2,
                                        child: Center(
                                          child: Text("Pending Donations", style: TextStyle(
                                              color: Color6,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17
                                          ),),
                                        ),
                                      ),
                                      SizedBox(height: 25,),
                                      Center(
                                        child: Text(adminController.counts.value.pendingDonations.toString(), style: TextStyle(
                                            color: Color2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                Get.to(()=>DonationListAdmin(1));
                              },
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color2, width: 2)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Color2,
                                        child: Center(
                                          child: Text("Concluded Donations", style: TextStyle(
                                              color: Color6,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17
                                          ),),
                                        ),
                                      ),
                                      SizedBox(height: 25,),
                                      Center(
                                        child: Text(adminController.counts.value.fulfilledDonations.toString(), style: TextStyle(
                                            color: Color2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ):Utils.getDashboardShimmer())
      ),
    );

  }

}
