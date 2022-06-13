import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/IRepositories/IAccountRepository.dart';
import 'package:food_donation/Models/userData.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Ui/Auth/SplashScreen.dart';
import '../Utils/Constants.dart';
import '../Utils/Locator.dart';
import '../Utils/Utils.dart';

class AccountController extends GetxController{

 late TextEditingController emailTextEditingController,passwordTextEditingController,nameTextEditingController,phoneTextEditingController;
 late IAccountRepository accountRepository;
 List<String> roles= ["Donor","Receiver"];
 String? selectedRole;
 Rx<bool> isLoadingRegister=false.obs,isDarkTheme=Get.isDarkMode.obs;

 var userData=UserData().obs;
@override
void onInit() {

  emailTextEditingController=TextEditingController();
  passwordTextEditingController=TextEditingController();
  nameTextEditingController=TextEditingController();
  phoneTextEditingController=TextEditingController();
    accountRepository=locator<IAccountRepository>();
  SharedPreferences.getInstance().then((prefs){

     Get.changeThemeMode(prefs.getBool("isDark")!=null&&prefs.getBool("isDark")!?ThemeMode.dark:ThemeMode.light);
    isDarkTheme.value=prefs.getBool("isDark")!=null?prefs.getBool("isDark")!:false;
     print("theme_preference "+isDarkTheme.value.toString());
  });
    super.onInit();
  }

  void registerInFirebase(BuildContext context){
  Utils.isInternetAvailable().then((isConnected){
     if(isConnected){
       if(FirebaseAuth.instance.currentUser==null) {
         if (nameTextEditingController.text.isEmpty) {
           Utils.showError(context, "Name is Required");
         } else if (phoneTextEditingController.text.isEmpty ||
             !GetUtils.isPhoneNumber(phoneTextEditingController.text)) {
           Utils.showError(context, "Valid Length Phone Number is Required");
         } else if (emailTextEditingController.text.isEmpty) {
           Utils.showError(context, "Email Address is Required");
         } else if (!GetUtils.isEmail(emailTextEditingController.text)) {
           Utils.showError(context, "Email Address is not Valid");
         } else if (passwordTextEditingController.text.isEmpty ||
             passwordTextEditingController.text.length < 6) {
           Utils.showError(
               context, "atleast 6 characters Password is required");
         } else if (!Utils.validateStructure(passwordTextEditingController.text)) {
           Utils.showError(context,
               "Password must contain atleast one lower case,Upper case and special characters");
         } else {
           isLoadingRegister.value=true;
           accountRepository.registerInFirebase(context, UserData(
               phone: phoneTextEditingController.text,
               email: emailTextEditingController.text,
               name: nameTextEditingController.text,
               password: passwordTextEditingController.text,
               role: selectedRole != null
                   ? roles.indexOf(selectedRole!) + 1
                   : 1)).then((value) {
             final currentUser = FirebaseAuth.instance.currentUser;
             if(currentUser!=null){
               accountRepository.registerInDatabase(context,UserData(
                 userId: currentUser.uid,
                   phone: phoneTextEditingController.text,
                   email: emailTextEditingController.text,
                   name: nameTextEditingController.text,
                   password: passwordTextEditingController.text,
                   role: selectedRole != null
                       ? roles.indexOf(selectedRole!) + 1
                       : 1)).then((value){
                 isLoadingRegister.value=false;
                 emailTextEditingController.text = "";
                 passwordTextEditingController.text = "";
                 nameTextEditingController.text = "";
                 phoneTextEditingController.text = "";
                 selectedRole = null;
                       }).catchError((error){
                 Utils.showError(context, error.toString());
                 isLoadingRegister.value=false;
               });
             }


           }).catchError((error){
             Utils.showError(context, error.toString());
             isLoadingRegister.value=false;
           });
         }
       }else{
         if(FirebaseAuth.instance.currentUser?.phoneNumber==null&&phoneTextEditingController.text.isEmpty){
           Utils.showError(context,"Phone Number is Required");
         }else if(selectedRole==null){
           Utils.showError(context,"Please Select Role");
         }else{
           accountRepository.registerInDatabase(context,UserData(userId:FirebaseAuth.instance.currentUser?.uid,phone:FirebaseAuth.instance.currentUser?.phoneNumber!=null?FirebaseAuth.instance.currentUser?.phoneNumber:phoneTextEditingController.text,email: FirebaseAuth.instance.currentUser?.email,name: FirebaseAuth.instance.currentUser?.displayName,role: selectedRole!=null?roles.indexOf(selectedRole!)+1:1)).then((value){
             emailTextEditingController.text="";
             passwordTextEditingController.text="";
             nameTextEditingController.text="";
             phoneTextEditingController.text="";
             selectedRole=null;
           });
         }
       }



     }else{
       Utils.showError(context,"Your Device is not Connected to Network");
     }
  });

  }

   void signIn(BuildContext context){
     Utils.isInternetAvailable().then((isConnected){
        if(isConnected){
          if(emailTextEditingController.text.isEmpty){
            Utils.showError(context,"Email Address is Required");
          }else if(!GetUtils.isEmail(emailTextEditingController.text)){
            Utils.showError(context,"Email Address is not Valid");
          }else if(passwordTextEditingController.text.isEmpty||passwordTextEditingController.text.length<6){
            Utils.showError(context,"atleast 6 characters Password is required");
          }else if(!Utils.validateStructure(passwordTextEditingController.text)){
            Utils.showError(context, "Password must contain atleast one lower case,Upper case and special characters");
          }else {
            isLoadingRegister.value=true;
            accountRepository.signIn(context, emailTextEditingController.text, passwordTextEditingController.text).then((value){
              if(FirebaseAuth.instance.currentUser!=null){
                accountRepository.getUserInfo(context, FirebaseAuth.instance.currentUser!.uid).then((value){
                  isLoadingRegister.value=false;
                  emailTextEditingController.text="";
                  passwordTextEditingController.text="";
                }).catchError((error){
                  Utils.showError(context, error.toString());
                  isLoadingRegister.value=false;
                });
              }
            }).catchError((error){
              Utils.showError(context, error.toString());
              isLoadingRegister.value=false;
            });

          }
        }else{
          Utils.showError(context,"Your Device is not Connected to Network");
        }
     });

  }

  void resetPassword(BuildContext context){
  Utils.isInternetAvailable().then((isConnected){
    if(isConnected){
      if(emailTextEditingController.text.isEmpty){
        Utils.showError(context,"Email Address is Required");
      }else if(!GetUtils.isEmail(emailTextEditingController.text)){
        Utils.showError(context,"Email Address is not Valid");
      }else{
        accountRepository.resetPassword(context, emailTextEditingController.text).then((value){
          emailTextEditingController.text="";
        }).catchError((error){
          Utils.showError(context, error.toString());
          isLoadingRegister.value=false;
        });

      }
    }else{
      Utils.showError(context,"Your Device is not Connected to Network");
    }
  });

  }

  void googleSignIn(BuildContext context){
    Utils.isInternetAvailable().then((isConnected){
      if(isConnected){

        accountRepository.signInWithGoogle(context).then((value){
          if(FirebaseAuth.instance.currentUser!=null){
            isLoadingRegister.value=true;
             accountRepository.getUserInfo(context, FirebaseAuth.instance.currentUser!.uid).then((value){
               isLoadingRegister.value=false;
             }).catchError((error){
               Utils.showError(context, error.toString());
               isLoadingRegister.value=false;
             });
          }
        }).catchError((error){
          Utils.showError(context, error.toString());
          isLoadingRegister.value=false;
        });
      }else{
        Utils.showError(context,"Your Device is not Connected to Network");
      }
    });
  }
  void getUserInfo()async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  userData.value = UserData.userFromJson(prefs.getString("user_data")!);
  log(userData.value.toJson().toString());
     // SharedPreferences.getInstance().then((prefs){
     //   userData.value = UserData.userFromJson(prefs.getString("user_data")!);
     // });
   }
   void logOut()async{
    await accountRepository.logOut();
   }


}