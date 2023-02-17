import 'package:flutter/material.dart';
import 'package:organizze_moderator/auth_screens/register_screen.dart';

import '../widgets/myBoxDecoration.dart';
import 'login_screen.dart';


class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: MyBoxDecoration(),
            title: Text(
              'Organizze Moderador',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              //INDICADOR DE POSIÇÃO
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  text: "Login",
                  icon: Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  text: "Registrar-me",
                  icon: Icon(
                    Icons.switch_account,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
            color: Colors.white,
            ),
            child: TabBarView(
              children: [
                LoginTabPage()  ,
                RegistrationTabPage(),
              ],
            ),
          ),




        ));
  }
}
