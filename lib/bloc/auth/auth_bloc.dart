
import 'package:fira/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  final FiraAuthService  _authService;

   AuthenticationBloc(this._authService) : super(AuthState.checkLogin)   {

    on<AuthEvent>((event, emit) async {
      if (event == AuthEvent.login){
        UserCredential? user = await _authService.signInWithGoogle();
        if( user!= null){
          debugPrint("logged in as : ${user.user!.displayName}");
          emit(AuthState.loggedIn);
        }else{
          emit(AuthState.loggedOut);
        }
      }else if(event == AuthEvent.logout){
        await _authService.signOut();
        emit(AuthState.loggedOut);
      }else if(event == AuthEvent.checkLogin){
        User? user= await _authService.currentUser();
        if(user!=null){
          emit(AuthState.loggedIn);
        }else{
          emit(AuthState.loggedOut);
        }
      }
    });
  }

}

enum AuthState{loggedIn, loggedOut,checkLogin}
enum AuthEvent{login,logout,checkLogin}