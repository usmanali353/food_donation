import 'package:flutter/material.dart';
import 'package:food_donation/IRepositories/IAdminRepository.dart';
import 'package:food_donation/Utils/Utils.dart';
import 'package:get/get.dart';
import '../IRepositories/IAccountRepository.dart';
import '../Models/Counts.dart';
import '../Utils/Locator.dart';

class AdminController extends GetxController{
  Rx<dynamic> counts=Counts().obs;
  var usersList=[].obs;
  Rx<bool> isDashboardLoading=false.obs;
  Rx<bool> userListLoading=false.obs;
  late IAdminRepository adminRepository;
  late IAccountRepository accountRepository;
   @override
  void onInit() {
     adminRepository=locator<IAdminRepository>();
     accountRepository=locator<IAccountRepository>();
    super.onInit();
  }
  void getDashboardCount(BuildContext context){
     Utils.isInternetAvailable().then((isConnected){
       if(isConnected){
         isDashboardLoading.value=true;
         adminRepository.getDashboardCounts(context).then((dashboardCounts){
           counts.value=dashboardCounts;
           isDashboardLoading.value=false;
         }).catchError((error){
           isDashboardLoading.value=false;
           Utils.showError(context, error.toString());
         });
       }else{
         Utils.showError(context,"Your Device is not connected to Network");
       }
     });

  }
  Future getUsersByRole(BuildContext context,int roleId)async{
    userListLoading.value=true;
    usersList.clear();
   await accountRepository.getUsersByRole(context, roleId).then((users){
      userListLoading.value=false;
      usersList.assignAll(users);
    }).catchError((error){
      userListLoading.value=false;
      Utils.showError(context,error.toString());
    });
  }
}