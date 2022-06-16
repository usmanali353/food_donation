import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Ui/Receiver/ReceiverHistory.dart';
import 'package:food_donation/Ui/Receiver/ReceiverRequestList.dart';
import 'package:food_donation/Ui/Receiver/UnReceivedDonations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                  height: 180,
                  color: Color2,
                  child: Center(child: Image.asset(
                    "Assets/hope_source3.png",
                    fit: BoxFit.fill,
                  ),
                  ),
                ),
                //Divider(color: Color1,thickness: 1.0),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Column(
                    children: [
                      // ListTile(
                      //   onTap: (){
                      //     Get.to(()=>ProfileScreen());
                      //   },
                      //   title: Text("Profile",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                      //   leading: FaIcon(FontAwesomeIcons.person, color: Color3,),
                      // ),
                      InkWell(
                        onTap: (){
                          Get.to(()=>ProfileScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              //color: Color1,
                              //border: Border.all(color: Color1, width: 1),
                              //borderRadius: BorderRadius.circular(4)
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color1,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Color2, width: 2)
                                      ),
                                      child: Center(child: FaIcon(FontAwesomeIcons.idCard, color: Color2,)),
                                    )),
                                SizedBox(width: 5,),
                                Expanded(
                                    flex: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Color1, width: 2)
                                      ),
                                      child: Center(
                                        child: Text("Profile", style: TextStyle(
                                            color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),

                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Divider(color: Color3,thickness: 1.0),
                      // ListTile(
                      //   onTap: (){
                      //     Get.to(()=>FoodRequestListForDonor());
                      //   },
                      //   title: Text("Request Received",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                      //   leading: FaIcon(FontAwesomeIcons.solidClock, color: Color3,),
                      // ),
                      //Divider(color: Color3,thickness: 1.0),
                      // ListTile(
                      //   onTap: (){
                      //     Get.to(()=>ReceiverHistory(userId:FirebaseAuth.instance.currentUser?.uid));
                      //   },
                      //   title: Text("History",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                      //   leading: FaIcon(FontAwesomeIcons.clockRotateLeft, color: Color3,),
                      // ),
                      InkWell(
                        onTap: (){
                          Get.to(()=>ReceiverHistory(userId:FirebaseAuth.instance.currentUser?.uid));

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              //color: Color1,
                              //border: Border.all(color: Color1, width: 1),
                              //borderRadius: BorderRadius.circular(4)
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color1,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Color2, width: 2)
                                      ),
                                      child: Center(child: FaIcon(FontAwesomeIcons.clockRotateLeft, color: Color2,)),
                                    )),
                                SizedBox(width: 5,),
                                Expanded(
                                    flex: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Color1, width: 2)
                                      ),
                                      child: Center(
                                        child: Text("History", style: TextStyle(
                                            color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),

                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Divider(color: Color3,thickness: 1.0),
                      InkWell(
                        onTap: ()async{
                          Get.find<AccountController>().logOut();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              //color: Color1,
                              //border: Border.all(color: Color1, width: 1),
                              //borderRadius: BorderRadius.circular(4)
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color1,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Color2, width: 2)
                                      ),
                                      child: Center(child: FaIcon(FontAwesomeIcons.rightFromBracket, color: Color2,)),
                                    )),
                                SizedBox(width: 5,),
                                Expanded(
                                    flex: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Color1, width: 2)
                                      ),
                                      child: Center(
                                        child: Text("Sign Out", style: TextStyle(
                                            color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),

                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ListTile(
                      //   onTap: ()async{
                      //     Get.find<AccountController>().logOut();
                      //   },
                      //   title: Text("Log Out",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                      //   leading: FaIcon(FontAwesomeIcons.rightFromBracket, color: Color3,),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
          appBar: AppBar(
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
                  icon: FaIcon(FontAwesomeIcons.circleHalfStroke, color: Color6))
            ],
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
