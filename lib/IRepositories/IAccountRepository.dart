import 'package:flutter/material.dart';
import 'package:food_donation/Models/userData.dart';

abstract class IAccountRepository{
  Future signIn(BuildContext context,String email,String password);
  Future registerInFirebase(BuildContext context,UserData user);
  Future resetPassword(BuildContext context,String email);
  Future signInWithGoogle(BuildContext context);
  Future registerInDatabase(BuildContext context,UserData user);
  Future getUserInfo(BuildContext context,String userId);
  Future logOut();
  Future getUserInfoById(BuildContext context,String userId);
  Future<List<UserData>> getUsersByRole(BuildContext context,int roleId);
  Future blockUser(String userId,bool isBlocked);
}