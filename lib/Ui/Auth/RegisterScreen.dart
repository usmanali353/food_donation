import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/Controllers/AccountController.dart';
import 'package:food_donation/Utils/LoadingScreen.dart';
import 'package:get/get.dart';

import '../../Utils/Constants.dart';

class RegisterScreen extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoadingRegister.value?LoadingScreen():Scaffold(
        body: Container(
          //color: Color6,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Color2,size:30),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      //color: Color2,
                      image: DecorationImage(fit: BoxFit.fill, image: AssetImage("Assets/charitylogo1.png",)),
                    ),
                  ),
                  // Container(
                  //   color: Color6,
                  //   height: MediaQuery.of(context).size.height / 3,
                  //   width: MediaQuery.of(context).size.width / 3,
                  //   child:  Center(child: Image.asset(
                  //     "assets/charitylogo.png",
                  //     fit: BoxFit.fill,
                  //   ),
                  //   ),
                  // ),
                  Text(
                    "Create An Account",
                    style: TextStyle(
                        color: Color2,
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                    ),
                  ),
                  Text(
                    "Create Account To Start Donating",
                    style: TextStyle(
                        color: Color3,
                        fontWeight: FontWeight.w400,
                        fontSize: 18
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Visibility(
                            visible: FirebaseAuth.instance.currentUser==null||(FirebaseAuth.instance.currentUser!=null&&FirebaseAuth.instance.currentUser?.displayName==null),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: controller.nameTextEditingController,
                                keyboardType: TextInputType.name,
                                //controller: name,
                                style: TextStyle(color: Color2,fontWeight: FontWeight.bold),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color1, width: 3.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color1, width: 2.0)
                                  ),
                                  labelText: "Name",
                                  labelStyle: TextStyle(color: Color2, fontWeight: FontWeight.bold),

                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: FirebaseAuth.instance.currentUser==null||(FirebaseAuth.instance.currentUser!=null&&FirebaseAuth.instance.currentUser?.email==null),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: controller.emailTextEditingController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Color2,fontWeight: FontWeight.bold),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color1, width: 3.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color1, width: 2.0)
                                  ),
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Color2, fontWeight: FontWeight.bold),

                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: FirebaseAuth.instance.currentUser==null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: controller.passwordTextEditingController,
                                keyboardType: TextInputType.visiblePassword,
                                //controller: name,
                                style: TextStyle(color: Color2,fontWeight: FontWeight.bold),
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color1, width: 3.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color1, width: 2.0)
                                  ),
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Color2, fontWeight: FontWeight.bold),

                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: FirebaseAuth.instance.currentUser==null||(FirebaseAuth.instance.currentUser!=null&&FirebaseAuth.instance.currentUser?.phoneNumber==null),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: controller.phoneTextEditingController,
                                keyboardType: TextInputType.phone,
                                //controller: name,
                                style: TextStyle(color: Color2,fontWeight: FontWeight.bold),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color1, width: 3.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color1, width: 2.0)
                                  ),
                                  labelText: "Contact",
                                  labelStyle: TextStyle(color: Color2, fontWeight: FontWeight.bold),

                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Roles",
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: Color2),
                                enabledBorder: OutlineInputBorder(

                                ),
                                focusedBorder:  OutlineInputBorder(
                                  borderSide: BorderSide(width:2, color:
                                  Color1),
                                ),
                              ),
                              validator: (value) => value == null
                                  ? 'Please fill this field' : null,
                              value: controller.selectedRole,
                              onChanged: (value) {
                                controller.selectedRole=value;
                              },
                              items: controller.roles.map((value) {
                                return  DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        value,
                                        style:  TextStyle(color: Color2,fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      controller.registerInFirebase(context);
                    },
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Color2,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 2, color: Color1)
                      ),
                      child: Center(
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                              color: Color1,
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            )
        )
    )) ;
  }
}
