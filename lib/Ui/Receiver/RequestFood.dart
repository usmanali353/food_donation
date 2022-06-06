import 'package:flutter/material.dart';
import 'package:food_donation/Controllers/ReceiverController.dart';
import 'package:food_donation/Utils/LoadingScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../Utils/Constants.dart';
import '../../Utils/PickLocation.dart';
import '../../Utils/Utils.dart';


class RequestFood extends GetView<ReceiverController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() => !controller.addingFoodRequest.value? Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color6
        ),
        backgroundColor: Color2,
        centerTitle: true,
        title: Text("Add Request", style: TextStyle(
            color: Color6,
            fontWeight: FontWeight.bold,
            fontSize: 25
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:16,right:16,bottom: 16, top: 16),
              child: DropdownButtonFormField<dynamic>(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Category'
                ),

                value: controller.selectedCategory,
                onChanged: (value) {
                  controller.selectedCategory=value;
                  controller.selectedCategoryId= controller.categories.indexOf(controller.selectedCategory!) +1;
                },
                items:controller.categories.map((value) {
                  return  DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: <Widget>[
                        Text(
                          value,
                          style:  TextStyle(fontSize: 15, color: Color2, fontWeight: FontWeight.bold),
                        ),
                        //user.icon,
                        //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: Color2, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                controller: controller.descriptionTextEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: Color2, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                controller: controller.personsQuantityTextEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'No of Persons',
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:16,right:16,bottom: 16),
              child: DropdownButtonFormField<dynamic>(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Delivery Type'
                ),

                value: controller.selectedDeliveryType,
                onChanged: (value) {
                  controller.selectedDeliveryType=value;
                  controller.selectedDeliveryTypeId= controller.deliveryTypes.indexOf(controller.selectedDeliveryType!) +1;
                },
                items:controller.deliveryTypes.map((value) {
                  return  DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: <Widget>[
                        Text(
                          value,
                          style: TextStyle(color: Color2, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        //user.icon,
                        //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: Color2, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.streetAddress,
                controller: controller.addressTextEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
                onTap: ()async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                  if(!serviceEnabled){
                    Utils.showError(context,"Please Enable Location Services");
                    return;
                  }

                  Geolocator.checkPermission().then((permission){
                    if(permission == LocationPermission.denied){
                      Geolocator.requestPermission().then((permission){
                        if(permission!= LocationPermission.denied){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PickLocation(),),).then((address){
                            controller.address=address;
                            controller.addressTextEditingController.text=address.address;
                          });

                        }
                      });
                      return;
                    }else if(permission == LocationPermission.deniedForever){
                      Utils.showError(context,"You have to give location permission from setting of your device");
                      return;
                    }

                  });

                  Navigator.push(context, MaterialPageRoute(builder: (context) => PickLocation(),),).then((address){
                    controller.address=address;
                    controller.addressTextEditingController.text=address.address;
                  });
                },
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Color2, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Color2)),
                onPressed: () {
                  controller.requestFood(context);
                },
                child: Text(
                  'Request Food',
                  style: TextStyle(color: Color6, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    ):LoadingScreen()) ;
  }
}
