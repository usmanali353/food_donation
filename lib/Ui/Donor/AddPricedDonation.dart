import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_donation/Utils/LoadingScreen.dart';
import 'package:food_donation/Utils/PickLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/DonorController.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';

class AddPricedDonation extends GetView<DonorController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() => !controller.isDonating.value? Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color6
        ),
        backgroundColor: Color2,
        centerTitle: true,
        title: Text("Sell Item", style: TextStyle(
            color: Color6,
            fontWeight: FontWeight.bold,
            fontSize: 25
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:16,right:16,bottom: 16,top: 16),
              child: DropdownButtonFormField<dynamic>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Category',

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
                keyboardType: TextInputType.text,
                controller: controller.descriptionTextEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
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
                  labelText: 'Quantity',
                ),

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
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: Color2, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.datetime,
                controller: controller.expiryDateTextEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expiry Date',
                ),
                onTap: ()async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDatePicker(
                      context: context,
                      initialDate: controller.selectedDate.value,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365))
                  ).then((date){
                    controller.selectedDate.value = date!;
                    controller.expiryDateTextEditingController.text=DateFormat("dd-MM-yyyy").format(date);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: Color2, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                controller: controller.priceTextEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                ),

              ),
            ),
            ElevatedButton(
                onPressed: (){
                  Utils.pickSingleImage().then((images){
                    if(images!=null){
                        controller.selectedImage.value=images;
                    }
                  });
                },
                child: Text("Pick Image", style: TextStyle(color: Color6, fontWeight: FontWeight.bold, fontSize: 15),)
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Visibility(
                visible: controller.selectedImage.value.path!="",
                child: Container(
                    height: 90,
                    child: Image.file(File(controller.selectedImage.value.path),)
                ),
              ),
            ),
            Container(
              height: 50,
              width: 270,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  controller.donatePricedFood(context);
                },
                child: Text(
                  'Sell',
                  style: TextStyle(color: Color6, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    ):LoadingScreen());
  }

}
