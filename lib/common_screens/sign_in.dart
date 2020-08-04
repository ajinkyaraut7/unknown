import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thejointapp/services/auth.dart';

import 'loading.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  
  final AuthService _auth = AuthService();
  bool loading = false;
  String _password, _email;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            height: 8 * MediaQuery.of(context).size.height / 9,
                            color: Color(0xff001242),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16
                                ),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: new InputDecoration(
                                    hintText: 'Enter Email',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Email cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    setState(() {
                                      _email = emailController.text.trim();
                                    });
                                    print(_email);
                                  },
                                ),
                              ),
                              SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16
                                ),
                                child: TextFormField(
                                  obscureText: obsecureText,
                                  controller: passwordController,
                                  decoration: new InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obsecureText? Icons.visibility : Icons.visibility_off
                                      ),
                                      onPressed: showPassword,
                                    ),
                                    hintText: 'Enter Password',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val.length < 6) {
                                      return "Password cannot be less than 6 characters";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  onChanged: (value) {
                                    setState(() {
                                      _password = passwordController.text;
                                    });
                                    print(_password);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 9,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Positioned(
                    top: (8 * MediaQuery.of(context).size.height / 9) - 40,
                    left: MediaQuery.of(context).size.width / 2 - 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            print(loading);
                            dynamic result = await _auth.googleSignIn();
                            if (result == null) {
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: CircleAvatar(
                            //google signin button
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png'),
                          ),
                        ),
                        CircleAvatar(
                          //facebook signin button
                          radius: 40,
                          backgroundColor: Color(0xff001242),
                          backgroundImage: NetworkImage(
                              'https://cdn4.iconfinder.com/data/icons/social-messaging-ui-color-shapes-2-free/128/social-facebook-circle-512.png'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }


  //Method to toggle obsecure text
  void showPassword(){
    setState(() {
      obsecureText = !obsecureText;
    });
  }


}
