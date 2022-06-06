
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/sliding_entrances/slide_in_left.dart';
import 'package:flutter_animator/widgets/sliding_entrances/slide_in_right.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Controllers/AccountController.dart';
import 'package:food_donation/Ui/Auth/RegisterScreen.dart';
import 'package:food_donation/Utils/LoadingScreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen.dart';
import '../../Utils/Constants.dart';

class SplashScreen extends StatelessWidget {
  final  accountController = Get.put(AccountController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => !accountController.isLoadingRegister.value?Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 50,),
              Container(
                width: 200,
                height: 200,
                child: Center(child: Image.asset(
                  "Assets/charitylogo1.png",
                  fit: BoxFit.fill,
                ),
                ),
              ),
              SizedBox(height: 100,),
              Container(
                width: 390,
                height: 110,
                decoration: BoxDecoration(
                  //color: Color2,
                  //borderRadius: BorderRadius.circular(50),
                  //border: Border.all(width:2, color: Color2)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5,),
                    SlideInLeft(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color2,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                              border: Border.all(width:2, color: Color1)
                          ),
                          child: Center(child: FaIcon(FontAwesomeIcons.solidUser, size: 40, color: Color1)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    SlideInRight(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color2,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), topRight: Radius.circular(30)),
                              border: Border.all(width:2, color: Color1)
                          ),
                          child: Center(child: FaIcon(FontAwesomeIcons.userPlus, size: 40, color: Color1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 5,),
              Container(
                width: 390,
                height: 110,
                decoration: BoxDecoration(
                  //color: Color2,
                  //borderRadius: BorderRadius.circular(50),
                  //border: Border.all(width:2, color: Color2)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5,),
                    SlideInLeft(
                      child: InkWell(
                        onTap: (){
                          accountController.googleSignIn(context);
                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=> RequestsList()));
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color2,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                              border: Border.all(width:2, color: Color1)
                          ),
                          child: Center(child: FaIcon(FontAwesomeIcons.google, size: 40, color: Color1)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    SlideInRight(
                      child: InkWell(
                        onTap: ()async{
                          Get.changeThemeMode(Get.isDarkMode?ThemeMode.light:ThemeMode.dark);
                          SharedPreferences prefs= await SharedPreferences.getInstance();
                          if(prefs.getBool("isDark")==null){
                            prefs.setBool("isDark", true);
                            accountController.isDarkTheme.value=true;
                          }else{
                            prefs.setBool("isDark", !prefs.getBool("isDark")!);
                            accountController.isDarkTheme.value=!prefs.getBool("isDark")!;
                          }
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color2,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                              border: Border.all(width:2, color: Color1)
                          ),
                          child: Center(child: FaIcon(FontAwesomeIcons.adjust, size: 40, color: Color1)),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: 350,
              //   height: 80,
              //   decoration: BoxDecoration(
              //     //color: Color2,
              //       borderRadius: BorderRadius.circular(50),
              //       border: Border.all(width:2, color: Color2)
              //   ),
              //   child:  Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: Container(
              //       height: 40,
              //       width: 40,
              //       decoration: BoxDecoration(
              //           //color: Color6,
              //           borderRadius: BorderRadius.circular(50),
              //           border: Border.all(width:2, color: Color2)
              //       ),
              //     ),
              //   )
              // ),



              // Container(
              //   width: 350,
              //   height: 80,
              //   decoration: BoxDecoration(
              //     color: Color2,
              //     borderRadius: BorderRadius.circular(50),
              //     border: Border.all(width:2, color: Color1)
              //   ),
              //   child: Center(
              //     child: Text(
              //       "SignUp",
              //       style: TextStyle(
              //           color: Color1,
              //           fontSize: 30,
              //           fontWeight: FontWeight.bold
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 130,),
            ],
          ),
        ),
      ),
    ):LoadingScreen());
  }
}
