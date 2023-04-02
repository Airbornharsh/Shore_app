import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/snackBar.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/HomeScreen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLogin = true;
  var isConfirmCode = false;
  var isLoading = false;
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = TextEditingController();
  final _confirmCodeController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  late String verificationId;

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _phoneNumberController.dispose();
    _emailIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmCodeController.dispose();
    super.dispose();
  }

  // void changeConfirmCode(bool data) {
  //   setState(() {
  //     isConfirmCode = data;
  //   });
  // }

  void changeRoute(String routeName, BuildContext context) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  bool get isCodeValidation {
    if (_confirmCodeController.text.isEmpty) {
      snackBar(context, "Please Enter Code");
      return false;
    } else if (_confirmCodeController.text.length > 6) {
      snackBar(context, "Please Enter Valid Code");
      return false;
    } else {
      return true;
    }
  }

  bool get isLoginValidation {
    if (_authController.text.isEmpty) {
      snackBar(context, "Please Enter Email / Number / UserName");
      return false;
    } else if (_passwordController.text.isEmpty) {
      snackBar(context, "Please Enter Password");
      return false;
    } else {
      return true;
    }
  }

  bool get isRegisterValidation {
    if (_nameController.text.isEmpty) {
      snackBar(context, "Please Enter Name");
      return false;
    } else if (_userNameController.text.isEmpty) {
      snackBar(context, "Please Enter UserName");
      return false;
    } else if (_phoneNumberController.text.isEmpty) {
      snackBar(context, "Please Enter Phone Number");
      return false;
    } else if (_emailIdController.text.isEmpty) {
      snackBar(context, "Please Enter Email Id");
      return false;
    } else if (_passwordController.text.isEmpty) {
      snackBar(context, "Please Enter Password");
      return false;
    } else if (_confirmPasswordController.text.isEmpty) {
      snackBar(context, "Please Enter Confirm Password");
      return false;
    } else if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      snackBar(context, "Password and Confirm Password Not Match");
      return false;
    } else {
      return true;
    }
  }

  void changeLogin(bool data) {
    setState(() {
      isLogin = data;
    });
  }

  void changeLoading(bool data) {
    setState(() {
      isLoading = data;
    });
  }

  void changeConfirmCode(bool data) {
    setState(() {
      isConfirmCode = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    var login = Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Email / Number / UserName",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _authController,
            keyboardType: TextInputType.text,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Password",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextButton(
            onPressed: () async {
              changeLoading(true);

              if (!isLoginValidation) {
                changeLoading(false);
                return;
              }

              String loginRes =
                  await Provider.of<SignUser>(context, listen: false)
                      .signIn(_authController.text, _passwordController.text);

              if (loginRes == "Done") {
                var snackBar = SnackBar(
                  content: const Text('Logged In'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {},
                  ),
                );
                Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
              } else {
                var snackBar = SnackBar(
                  content: Text(loginRes),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // _authController.clear();
                // _passwordController.clear();
              }
              changeLoading(false);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 0, 190, 184))),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white),
            )),
        const SizedBox(
          height: 7,
        ),
        GestureDetector(
          onTap: () {
            changeLogin(false);
          },
          child: Text(
            "Create an New Account",
            style: TextStyle(
                fontSize: 14, color: const Color.fromARGB(255, 0, 190, 184)),
          ),
        ),
      ],
    );

    var register = Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Name",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _nameController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "User Name",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _userNameController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Phone Number",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Email Id",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            keyboardType: TextInputType.emailAddress,
            controller: _emailIdController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Password",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Confirm Password",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _confirmPasswordController,
            keyboardType: TextInputType.visiblePassword,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextButton(
            onPressed: () async {
              changeLoading(true);

              if (!isRegisterValidation) {
                changeLoading(false);
                return;
              }
              try {
                auth.verifyPhoneNumber(
                    phoneNumber: "+91${_phoneNumberController.text}",
                    verificationCompleted:
                        (PhoneAuthCredential credential) async {
                      print("Completed: ${credential}}");
                      changeLoading(false);
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      print("Failed: $e");
                      changeLoading(false);
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      setState(() {
                        this.verificationId = verificationId;
                      });
                      changeConfirmCode(true);
                      changeLoading(false);
                      print("Code Sent: $verificationId and $resendToken");
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      print("Timeout: $verificationId");
                      changeLoading(false);
                    });
              } catch (e) {
                print(e);
                changeLoading(false);
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 0, 190, 184))),
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white),
            )),
        const SizedBox(
          height: 7,
        ),
        GestureDetector(
          onTap: () {
            changeLogin(true);
          },
          child: Text(
            "Login Instead",
            style: TextStyle(
                fontSize: 14, color: const Color.fromARGB(255, 0, 190, 184)),
          ),
        )
      ],
    );

    var verify = Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Code",
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _confirmCodeController,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextButton(
            onPressed: () async {
              changeLoading(true);

              if (!isCodeValidation) {
                return;
              }

              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: this.verificationId,
                    smsCode: _confirmCodeController.text.trim());

                // if (credential.accessToken == null) {
                //   snackBar(context, "Invalid Code");
                //   setState(() {
                //     isLoading = false;
                //   });
                //   return;
                // }

                print("step 1");

                // Sign the user in (or link) with the credential
                final authCredential =
                    await auth.signInWithCredential(credential);

                print("step 2");

                if (authCredential.user == null) {
                  snackBar(context, "Invalid Code");
                  changeLoading(false);

                  return;
                }

                String Res = await Provider.of<SignUser>(context, listen: false)
                    .signUp(
                        _nameController.text,
                        _userNameController.text,
                        int.parse(_phoneNumberController.text),
                        _emailIdController.text,
                        _passwordController.text,
                        _confirmPasswordController.text);

                if (Res == "Done") {
                  changeLogin(true);
                  changeConfirmCode(false);
                } else {
                  var snackBar = SnackBar(content: Text(Res));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  changeLoading(false);

                  _nameController.clear();
                  _userNameController.clear();
                  _phoneNumberController.clear();
                  _emailIdController.clear();
                  _passwordController.clear();
                  _confirmPasswordController.clear();
                }
              } catch (e) {
                print(e);
                snackBar(context, "Invalid Code");
              } finally {
                changeLoading(false);
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 0, 190, 184))),
            child: const Text(
              "Confirm Code",
              style: TextStyle(color: Colors.white),
            )),
        const SizedBox(
          height: 7,
        ),
        GestureDetector(
          onTap: () {
            changeConfirmCode(false);
          },
          child: const Text("Re-Enter the Details"),
        ),
        const SizedBox(
          height: 7,
        ),
        GestureDetector(
          onTap: () {
            changeLogin(true);
          },
          child: Text(
            "Login Instead",
            style: TextStyle(
                fontSize: 14, color: const Color.fromARGB(255, 0, 190, 184)),
          ),
        )
      ],
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 20),
                  width: (MediaQuery.of(context).size.width - 70),
                  // height: 500,
                  constraints: BoxConstraints(
                      maxHeight: (isConfirmCode
                          ? 220
                          : isLogin
                              ? 270
                              : 570)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0.1, 2),
                            blurRadius: 7,
                            spreadRadius: 0.6,
                            blurStyle: BlurStyle.outer)
                      ]),
                  child: Container(
                    child: isConfirmCode
                        ? verify
                        : isLogin
                            ? login
                            : register,
                  ),
                ),
              ),
            ),
            if (isLoading)
              Positioned(
                top: 0,
                left: 0,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: const Color.fromRGBO(80, 80, 80, 0.3),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
