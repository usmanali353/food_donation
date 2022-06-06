import 'package:flutter/material.dart';
import 'package:food_donation/Controllers/AccountController.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends GetView<AccountController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  width: 100,
                  height: 100,
                  /*decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50.0)),*/
                  child: Image.asset('Assets/charitylogo1.png')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Food Donation",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: controller.emailTextEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.resetPassword(context);
                    },
                    child: Text(
                      'Send Reset Link',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
