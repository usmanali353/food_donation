import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Controllers/AccountController.dart';
import 'package:food_donation/Controllers/DonorController.dart';
import 'package:food_donation/Ui/DetailPages/DonationDetails.dart';
import 'package:food_donation/Ui/Donor/DonorHistory.dart';
import 'package:food_donation/Ui/Donor/FoodRequestListForDonor.dart';
import 'package:get/get.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';
import '../Auth/ProfileScreen.dart';
import 'AddDonation.dart';

class DonorHome extends StatelessWidget {
  final  donorController = Get.put(DonorController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    if(donorController.donations.length==0) {
      donorController.getDonations(context);
    }
    return Scaffold(
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
                       Divider(color: Color3,thickness: 1.0),
                       ListTile(
                         onTap: (){
                           Get.to(()=>FoodRequestListForDonor());
                         },
                         title: Text("Request Received",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                         leading: FaIcon(FontAwesomeIcons.solidClock, color: Color3,),
                       ),
                       Divider(color: Color3,thickness: 1.0),
                       ListTile(
                         onTap: (){
                           Get.to(()=>DonorHistory());
                         },
                         title: Text("History",style: TextStyle(color: Color2,fontSize: 20,fontWeight: FontWeight.bold),),
                         leading: FaIcon(FontAwesomeIcons.history, color: Color3,),
                       ),
                       Divider(color: Color3,thickness: 1.0),
                       ListTile(
                         onTap: (){
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
        iconTheme: IconThemeData(color: Color6),
        title: Text("Home",style: TextStyle(color: Color6,fontSize: 30,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor:Color2,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color2,
        onPressed: () {
          Get.to(()=>AddDonation());
        },
        child: Icon(Icons.add,color: Color6, size: 25,),
      ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async{
            return await donorController.getDonations(context);
          },
          child: Obx(() => ListView.builder(itemCount:!donorController.fetchingPendingDonations.value?donorController.donations.length:5, itemBuilder: (context, index){
            return !donorController.fetchingPendingDonations.value? Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Get.to(()=>DonationDetailsScreen(index,"Donor"));
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
                                image: NetworkImage(donorController.donations[index].images[0])
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
                                    for (var n = 1; n < donorController.donations[index].images.length; n++)
                                         NetworkImage(donorController.donations[index].images[n])
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
                                  child: Text(donorController.donations[index].name, style: TextStyle(
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
                                        child: Text(Utils.getCategoryName(donorController.donations[index].category), style: TextStyle(
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
                                        child: Text(donorController.donations[index].personsQuantity.toString(), style: TextStyle(
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
                                        child: Text(donorController.donations[index].availableUpTo, style: TextStyle(
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
                                        child: Text(Utils.getDeliveryTypeName(donorController.donations[index].deliveryType), style: TextStyle(
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
          }))
      ),
    );
  }

}


