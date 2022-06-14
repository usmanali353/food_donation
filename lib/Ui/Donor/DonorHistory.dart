import 'package:flutter/material.dart';
import 'package:food_donation/Controllers/DonorController.dart';
import 'package:food_donation/Ui/Donor/DonationsReceivedByRecievers.dart';
import 'package:get/get.dart';
import '../../Utils/Constants.dart';
import 'FulfilledRequestsOfDonor.dart';

class DonorHistory extends StatelessWidget {
  final  donorController = Get.put(DonorController());
  String? userId;

  DonorHistory(this.userId);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: !Get.isDarkMode?Color6:Color6
            ),

            title: Text("History", style: TextStyle(color: Color6, fontWeight: FontWeight.bold, fontSize: 30),),
            centerTitle: true,
            backgroundColor: Color2,
            elevation: 8,
            bottom: TabBar(

                labelColor: Color2,
                unselectedLabelColor: Color6,
                indicatorPadding: EdgeInsets.only(left: 10, right: 10),
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
                      child: Text("Donations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Fulfilled Requests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    ),
                  ),

                ]),
          ),
          body: TabBarView(children: [
            DonationsReceivedByReceivers(userId: userId,),
            FulfilledRequestsOfDonor(userId: userId,)
          ]),
        )
    );
  }
}
