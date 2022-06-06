import 'package:food_donation/IRepositories/IReceiverRepository.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../IRepositories/IAccountRepository.dart';
import '../IRepositories/IDonorRepository.dart';
import '../Repositories/AccountRepository.dart';
import '../Repositories/DonorRepository.dart';
import '../Repositories/ReceiverRepository.dart';

GetIt locator = GetIt.I;

void SetupLocator(){
  locator.registerLazySingleton(() => GoogleSignIn());
  locator.registerLazySingleton<IAccountRepository>(() =>AccountRepository());
  locator.registerLazySingleton<IReceiverRepository>(() =>ReceiverRepository());
  locator.registerLazySingleton<IDonorRepository>(() =>DonorRepository());
}