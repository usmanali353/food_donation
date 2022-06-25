import 'package:another_flushbar/flushbar.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:shimmer/shimmer.dart';

import 'Constants.dart';

class Utils {
  static String getImageUploadingUrl(){
    return "https://api.imgbb.com/1/upload?key=bc9cf8e368f01463806a8df032019c54";
  }
  static bool validateStructure(String value){
    RegExp regExp = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{6,}$');
    return regExp.hasMatch(value);
  }
  static bool validateEmail(String value){
    RegExp regExp=  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regExp.hasMatch(value);
  }
  static dynamic myEncode(dynamic item){
    if(item is DateTime)
      return item.toIso8601String();
  }
  static void showSuccess(BuildContext context,String message){
    Flushbar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
      message: message,
    ).show(context);
  }
  static void showError(BuildContext context,String message){
    Flushbar(
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      message: message,
    ).show(context);

  }

  static Future<List<XFile>?> pickImages()async{
        return await ImagePicker().pickMultiImage(imageQuality: 25);
  }

  static Future<XFile?> pickSingleImage()async{
    return await ImagePicker().pickImage(source:ImageSource.gallery,imageQuality: 25);
  }

 static Future<bool> isInternetAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (await InternetConnectionChecker().hasConnection) {
        // Mobile data detected & internet connection confirmed.
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      if (await InternetConnectionChecker().hasConnection) {
        // Wifi detected & internet connection confirmed.
        return true;
      } else {
        // Wifi detected but no internet connection found.
        return false;
      }
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      return false;
    }
  }

 static String getCategoryName(int? categoryId){
    if(categoryId!=null){
     if(categoryId==1){
       return "Cooked Food";
     }else if(categoryId ==2){
       return "Fruits";
     }else if(categoryId == 3){
       return "Vegetables";
     }else if(categoryId == 4){
       return "Sweets";
     }else if(categoryId == 5){
       return "Chocolates";
     }else if(categoryId == 6){
       return "Cakes";
     }else if(categoryId == 7){
       return "Biscuits";
     }else if(categoryId == 8){
       return "Milk";
     }else if(categoryId == 9){
       return "Grains";
     }else if(categoryId == 10){
       return "Mix Items";
     }else if(categoryId == 11){
       return "Others";
     }
    }
     return "";
  }
  static String getDeliveryTypeName(int? deliveryTypeId){
    if(deliveryTypeId!=null){
      if(deliveryTypeId==1){
        return "Pick Up";
      }else if(deliveryTypeId ==2){
        return "Drop Off";
      }
    }
    return "";
  }
  static String getFormattedDate(String unformattedDate){
    DateTime date=DateFormat("yyyy-MM-dd").parse(unformattedDate.toString().substring(0,unformattedDate.indexOf("T")));
     return date.day.toString().padLeft(2,"0")+"-"+date.month.toString().padLeft(2,"0")+"-"+date.year.toString();
  }

  static String getRoleName(int? roleId){
    print("Role Id "+roleId.toString());
    if(roleId!=null){
      return roleId==1?"Donor":roleId==2?"Receiver":"";
    }
    return "";
  }

  static Widget getDonationListShimmer(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: Get.size.width,
          // height: 180,
          child: Row(
            children: [
              Container(
                height: 185,
                width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                    border: Border.all(color: Color1, width: 2),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("Assets/cherries.jpg")
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
                          //color: Color2,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
                        ),
                        child:  AvatarStack(
                          borderColor: Color2,
                          height: 30,
                          avatars: [
                            for (var n = 0; n < 5; n++)
                              NetworkImage('https://i.pravatar.cc/150?img=$n'),
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
                          child: Text("Home", style: TextStyle(
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
                                //color: Color6,
                                border: Border.all(color: Color1, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:   Center(
                                child: Container(
                                  //width: 60,
                                  color: Color6,
                                  child: Text("Food Charity Service", style: TextStyle(
                                      color: Color6, fontSize: 15, fontWeight: FontWeight.bold
                                  ),
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
                                //color: Color6,
                                border: Border.all(color: Color1, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:   Center(
                                child: Container(
                                  color: Color6,
                                  child: Text("Food Charity Service", style: TextStyle(
                                      color: Color6, fontSize: 15, fontWeight: FontWeight.bold
                                  ),
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
                              child:   Center(
                                child:  Container(
                                  color: Color6,
                                  child: Text("Food Charity Service", style: TextStyle(
                                      color: Color6, fontSize: 15, fontWeight: FontWeight.bold
                                  ),
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
                                child: Container(
                                  color: Color6,
                                  child: Text("Food Charity Service", style: TextStyle(
                                      color: Color6, fontSize: 15, fontWeight: FontWeight.bold
                                  ),
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
    );
  }
  static Widget getRequestListShimmer(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: Get.size.width,
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
                          child: Text("Home", style: TextStyle(
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
                                child: Container(
                                  //width: 60,
                                  color: Color6,
                                  child: Text("Food Charity Service", style: TextStyle(
                                      color: Color6, fontSize: 15, fontWeight: FontWeight.bold
                                  ),
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
                                child: Container(
                                  //width: 60,
                                  color: Color6,
                                  child: Text("Food Charity Service", style: TextStyle(
                                      color: Color6, fontSize: 15, fontWeight: FontWeight.bold
                                  ),
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:   Center(
                                child: Container(
                                  //width: 60,
                                  color: Color6,
                                  child: Text("Food Charity Service", style: TextStyle(
                                      color: Color6, fontSize: 15, fontWeight: FontWeight.bold
                                  ),
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
                                child: Container(
                                  //width: 60,
                                  color: Color6,
                                  child: Text("Food Charity Service", style: TextStyle(
                                      color: Color6, fontSize: 15, fontWeight: FontWeight.bold
                                  ),
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
    );
  }
  static Widget getDashboardShimmer(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.width,
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
                                      color: Color6,
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
                width: Get.width,
                height: 130,
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
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
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
                                  child: Text("0", style: TextStyle(
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
                      SizedBox(width: 5,),
                      Expanded(
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Color2, width: 2)
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
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
                                  child: Text("0", style: TextStyle(
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
                    ],
                  ),
                ),
              ),
              Container(
                width: Get.width,
                height: 130,
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
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
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
                                  child: Text("0", style: TextStyle(
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
                    ],
                  ),
                ),
              ),
              Container(
                width: Get.width,
                height: 130,
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
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
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
                                  child: Text("0", style: TextStyle(
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
                    ],
                  ),
                ),
              ),
              Container(
                width: Get.width,
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    children: [
                      Expanded(
                        child:Card(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Color2, width: 2)
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
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
                                  child: Text("0", style: TextStyle(
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
                      SizedBox(width: 5,),
                      Expanded(
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Color2, width: 2)
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
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
                                  child: Text("0", style: TextStyle(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  static Widget getUsersListShimmer(){
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: Get.width,
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
                        //width: Get.width,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Color2,
                            border: Border.all(color: Color1, width: 2)
                        ),
                        child:   Center(
                          child: Text("Happy Life Org.", style: TextStyle(
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
                                child: Card(
                                  child: Container(
                                    width: 100,
                                    child: Text("happylife@gmail.com", style: TextStyle(
                                        color: Color2, fontSize: 16, fontWeight: FontWeight.bold
                                    ),
                                    ),
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
                            child: Center(child: FaIcon(FontAwesomeIcons.phoneFlip, color: Color2, size: 18,)),
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
                                child: Card(
                                  child: Container(
                                    width: 100,
                                    child: Text("090078601", style: TextStyle(
                                        color: Color2, fontSize: 16, fontWeight: FontWeight.bold
                                    ),
                                    ),
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
      );
  }
}