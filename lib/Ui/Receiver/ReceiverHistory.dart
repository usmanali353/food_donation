import 'package:flutter/material.dart';
import 'package:food_donation/Ui/Receiver/FulfilledRequests.dart';
import 'package:food_donation/Ui/Receiver/ReceivedDonations.dart';
import 'package:get/get.dart';
import '../../Controllers/ReceiverController.dart';
import '../../Utils/Constants.dart';

class ReceiverHistory extends StatelessWidget {
  final  receiverController = Get.put(ReceiverController());
  String? userId;

  ReceiverHistory({this.userId});

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
                      child: Text("Received Donations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
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
            ReceivedDonations(userId: userId,),
            FulFilledRequests(userId: userId,)
          ]),
        )
    );
  }
}
