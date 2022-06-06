import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Ui/Receiver/ReceiverHistory.dart';
import 'package:food_donation/Ui/Receiver/ReceiverRequestList.dart';
import 'package:food_donation/Ui/Receiver/UnReceivedDonations.dart';
import 'package:get/get.dart';
import '../../Controllers/AccountController.dart';
import '../../Controllers/ReceiverController.dart';
import '../../Utils/Constants.dart';
import '../Auth/ProfileScreen.dart';

class ReceiverHome extends StatelessWidget {
  final  receiverController = Get.put(ReceiverController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 2,
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  child: Center(child: Image.asset(
                    "Assets/charitylogo1.png",
                    fit: BoxFit.fill,
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: (){
                          Get.to(()=>ProfileScreen());
                        },
                        title: Text("Profile",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                        leading: FaIcon(FontAwesomeIcons.person, color: Color3,),
                      ),
                      //Divider(color: Color3,thickness: 1.0),
                      // ListTile(
                      //   onTap: (){
                      //     Get.to(()=>FoodRequestListForDonor());
                      //   },
                      //   title: Text("Request Received",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                      //   leading: FaIcon(FontAwesomeIcons.solidClock, color: Color3,),
                      // ),
                      Divider(color: Color3,thickness: 1.0),
                      ListTile(
                        onTap: (){
                          Get.to(()=>ReceiverHistory());
                        },
                        title: Text("History",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                        leading: FaIcon(FontAwesomeIcons.history, color: Color3,),
                      ),
                      Divider(color: Color3,thickness: 1.0),
                      ListTile(
                        onTap: ()async{
                          Get.find<AccountController>().logOut();
                        },
                        title: Text("Log Out",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                        leading: FaIcon(FontAwesomeIcons.signOutAlt, color: Color3,),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: !Get.isDarkMode?Color6:Color6
            ),

            title: Text("Home", style: TextStyle(color: Color6, fontWeight: FontWeight.bold, fontSize: 30),),
            centerTitle: true,
            backgroundColor: Color2,
            elevation: 8,
            bottom: TabBar(
              labelColor: Color2,
                unselectedLabelColor: Color6,
                //indicatorPadding: EdgeInsets.only(left: 10, right: 10),
                indicator: ShapeDecoration(
                    color: Color1,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Color2,
                        )
                    )
                ),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Unreceived Donations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    ),
                  ),
                  Tab(
                    child: Text("Pending Requests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                  ),

                ]),
          ),
          body: TabBarView(children: [
            UnReceivedDonations(),
            ReceiverRequestList()
          ]),
        )
    );
  }
}
