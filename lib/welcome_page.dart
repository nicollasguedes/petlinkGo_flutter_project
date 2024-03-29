import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_project/user_profile_form.dart';
import 'package:flutter_project/widget/navigarion_drawer.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isReady = true;
  late String _userName;

  Future<void> getUserName() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    dynamic data = doc.data();

    setState(() {
      _userName = data['name'];
      isReady = false;
    });
  }

  int hexColor(String color) {
    //adding prefix
    String newColor = '0xff' + color;
    //removing # sign
    newColor = newColor.replaceAll('#', '');
    //converting it to the integer
    int finalColor = int.parse(newColor);
    return finalColor;
  }

  @override
  Widget build(BuildContext context) {
    getUserName();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          drawer: NavigationDrawerWidget('welcome'),
          appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Color(hexColor('#A6CCC2')),
              title: ListTile(
                leading: Text(
                  'PetLinkGo',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(hexColor('#0E5442'))),
                ),
              )),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
                child: Container(
              height: MediaQuery.of(context).size.height - 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(hexColor('#D3E7E2'))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: isReady
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: "Oi $_userName",
                                  style: TextStyle(
                                      color: Color(hexColor('#0E5442')),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '\nO que deseja fazer hoje?',
                                        style: TextStyle(
                                          color: Color(hexColor('#0E5442')),
                                          fontWeight: FontWeight.normal,
                                        )),
                                    // can add more TextSpans here...
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Material(
                                    color: Color(hexColor('#D3E7E2')),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileForm(""),
                                          ));
                                        },
                                        splashColor: Color(hexColor('#D3E7E2')),
                                        child: Opacity(
                                          opacity: 0.7,
                                          child: Image.asset(
                                            'assets/profilePicPetlink.png',
                                            height: 130,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildButton(
                                        labelPrefix: 'Procurar',
                                        labelSufix: 'Pets',
                                        labelIcon: Icon(Icons.pets),
                                        navegation: () {
                                          Navigator.of(context)
                                              .pushNamed('feed');
                                        }),
                                    buildButton(
                                        labelPrefix: 'Seu',
                                        labelSufix: 'Perfil',
                                        labelIcon: Icon(Icons.person_rounded),
                                        navegation: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileForm(""),
                                          ));
                                        }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildButton(
                                        labelPrefix: 'Fazer',
                                        labelSufix: 'LogOut',
                                        labelIcon: Icon(Icons.logout_rounded),
                                        navegation: () async {
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/', (route) => false);
                                        }),
                                    buildButton(
                                        labelPrefix: 'Entre em',
                                        labelSufix: 'Contato',
                                        labelIcon: Icon(Icons.email_rounded),
                                        navegation: () {
                                          Navigator.of(context).pushNamed('');
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
              ),
            )),
          )),
    );
  }

  Widget buildButton({
    required String labelPrefix,
    required String labelSufix,
    required Icon labelIcon,
    required void Function() navegation,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Color(hexColor('#6FA698')),
        child: InkWell(
          splashColor: Color(hexColor('#D3E7E2')).withOpacity(0.3),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            height: 130,
            width: 150,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, top: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    labelIcon.icon,
                    color: Color(hexColor('#D3E7E2')),
                    size: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$labelPrefix\n$labelSufix',
                    style: TextStyle(
                      color: Color(hexColor('#D3E7E2')),
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          onTap: navegation,
        ),
      ),
    );
  }
}
