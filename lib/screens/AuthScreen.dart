import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/src/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/Utils/snackBar.dart';
import 'package:pinput/pinput.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/HomeScreen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  AuthScreen({super.key});
  bool start = true;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLogin = true;
  var isConfirmCode = false;
  var isLoading = false;
  bool isLoggedChecked = false;
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
    Navigator.of(context).popAndPushNamed(routeName);
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
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = data;
    });
  }

  void changeConfirmCode(bool data) {
    setState(() {
      isConfirmCode = data;
    });
  }

  Future codeSubmit() async {
    changeLoading(true);

    late final String emailIdFirebaseId;
    late final String phoneNumberFirebaseId;
    late final phoneAuthCredential;

    if (!isCodeValidation) {
      return;
    }

    try {
      phoneAuthCredential = await PhoneAuthProvider.credential(
          verificationId: this.verificationId,
          smsCode: _confirmCodeController.text.trim());

      print("step 1");

      // Sign the user in (or link) with the credential
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      phoneNumberFirebaseId = authCredential.user!.uid;

      print("step 2");

      if (authCredential.user == null) {
        snackBar(context, "Invalid Code");
        changeLoading(false);
        return;
      }
    } catch (e) {
      print(e);
      snackBar(context, "Invalid Code");
      changeLoading(false);
      return;
    }

    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: _emailIdController.text,
        password: _passwordController.text,
      );

      credential.user?.sendEmailVerification();

      emailIdFirebaseId = credential.user?.uid as String;

      print("Send Email Verification");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        snackBar(context, "Weak Password");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        snackBar(context, "Account already exists for this email.");
      }
      changeLoading(false);
      return;
    } catch (e) {
      print("Email Auth Error$e");
      changeLoading(false);
      return;
    }

    try {
      String Res = await Provider.of<SignUser>(context, listen: false).signUp(
          _nameController.text,
          _userNameController.text,
          int.parse(_phoneNumberController.text),
          _emailIdController.text,
          _passwordController.text,
          _confirmPasswordController.text,
          emailIdFirebaseId,
          phoneNumberFirebaseId,
          phoneAuthCredential);

      if (Res == "Done") {
        changeLogin(true);
        changeConfirmCode(false);

        _nameController.clear();
        _userNameController.clear();
        _phoneNumberController.clear();
        _emailIdController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
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
      return;
    } finally {
      changeLoading(false);
    }
  }

  Future registerHandler() async {
    changeLoading(true);

    if (!isRegisterValidation) {
      changeLoading(false);
      return;
    }
    try {
      auth.verifyPhoneNumber(
          phoneNumber: "+91${_phoneNumberController.text}",
          verificationCompleted: (PhoneAuthCredential credential) async {
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
  }

  Future loginHandler() async {
    changeLoading(true);

    if (!isLoginValidation) {
      changeLoading(false);
      return;
    }

    try {
      String loginRes = await Provider.of<SignUser>(context, listen: false)
          .signIn(_authController.text, _passwordController.text);

      auth.signInWithEmailAndPassword(
          email: Provider.of<SignUser>(context, listen: false)
              .getUserDetails
              .emailId,
          password: _passwordController.text);

      if (loginRes == "Done") {
        snackBar(context, "Logged In");
        Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
      } else {
        var snackBar = SnackBar(
          content: Text(loginRes),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // _authController.clear();
        // _passwordController.clear();
      }
    } catch (e) {
      print(e);
    }

    changeLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    if (widget.start) {
      setState(() {
        widget.start = false;
      });

      auth.authStateChanges().listen((User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
        }
      });
      // changeLoading(true);
      void onLoad() async {
        final prefs = await SharedPreferences.getInstance();

        try {
          if (prefs.containsKey("shore_accessToken")) {
            bool isValid = await Provider.of<SignUser>(context, listen: false)
                .isValidAccessToken();
            print(isValid);

            // changeLoading(false);
            if (isValid) {
              changeRoute(HomeScreen.routeName, context);
            }
            setState(() {
              changeLoading(false);
              isLoading = false;
              widget.start = false;
              isLoggedChecked = true;
            });
          }
          setState(() {
            changeLoading(false);
            widget.start = false;
            isLoggedChecked = true;
          });
        } catch (e) {
          print(e);
          changeLoading(false);
          widget.start = false;
          isLoggedChecked = true;
        }
      }

      onLoad();

      widget.start = false;
    }
    // });

    var login = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("lib/assets/images/login/profile_login.png"),
        SizedBox(height: 8),
        Text(
          "Welcome Back",
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 0, 190, 184)),
        ),
        Text(
          "Sign to continue",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400),
        ),
        SizedBox(
          height: 18,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0.5,
            )
          ]),
          child: TextField(
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone_android,
                color: const Color.fromARGB(255, 0, 190, 184),
              ),
              border: InputBorder.none,
              label: Text("Email / Number / UserName"),
              labelStyle: TextStyle(
                color: Colors.grey, //<-- SEE HERE
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
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0.5,
            )
          ]),
          child: TextField(
            style: TextStyle(color: Colors.grey.shade700),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_sharp,
                color: const Color.fromARGB(255, 0, 190, 184),
              ),
              border: InputBorder.none,
              label: Text("Password"),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(3, 3),
              blurRadius: 10,
              spreadRadius: 0.5,
            )
          ]),
          child: TextButton(
              onPressed: () async {
                await loginHandler();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 0, 190, 184))),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.symmetric(vertical: 7),
                child: Center(
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have account? ",
              style: TextStyle(color: Colors.grey.shade500),
            ),
            GestureDetector(
              onTap: () {
                changeLogin(false);
              },
              child: Text(
                "Create a New Account",
                style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 0, 190, 184)),
              ),
            )
          ],
        ),
      ],
    );

    var register = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Create Account",
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 0, 190, 184)),
        ),
        Text(
          "Create a new account",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400),
        ),
        SizedBox(
          height: 18,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0.5,
            )
          ]),
          child: TextField(
            style: TextStyle(color: Colors.grey.shade700),
            decoration: InputDecoration(
              border: InputBorder.none,
              label: Text("NAME"),
              prefixIcon: Icon(
                Icons.person_outline,
                color: Colors.grey.shade400,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _nameController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0.5,
            )
          ]),
          child: TextField(
            style: TextStyle(color: Colors.grey.shade700),
            decoration: InputDecoration(
              border: InputBorder.none,
              label: Text("USERNAME"),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey.shade400,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _userNameController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0.5,
            )
          ]),
          child: TextField(
            style: TextStyle(color: Colors.grey.shade700),
            decoration: InputDecoration(
              border: InputBorder.none,
              label: Text("PHONE NUMBER"),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.grey.shade400,
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
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0.5,
            )
          ]),
          child: TextField(
            style: TextStyle(color: Colors.grey.shade700),
            decoration: InputDecoration(
              border: InputBorder.none,
              label: Text("EMAIL ADDRESS"),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.grey.shade400,
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
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0.5,
            )
          ]),
          child: TextField(
            style: TextStyle(color: Colors.grey.shade700),
            decoration: InputDecoration(
              border: InputBorder.none,
              label: Text("PASSWORD"),
              prefixIcon: Icon(
                Icons.lock_sharp,
                color: Colors.grey.shade400,
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
          decoration: BoxDecoration(color: Colors.white, boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0.5,
            )
          ]),
          child: TextField(
            style: TextStyle(color: Colors.grey.shade700),
            decoration: InputDecoration(
              border: InputBorder.none,
              label: Text("CONFIRM PASSWORD"),
              prefixIcon: Icon(
                Icons.lock_sharp,
                color: Colors.grey.shade400,
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
        Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(3, 3),
              blurRadius: 10,
              spreadRadius: 0.5,
            )
          ]),
          child: TextButton(
              onPressed: () async {
                await registerHandler();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 0, 190, 184))),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.symmetric(vertical: 7),
                child: Center(
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )),
        ),
        const SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have a account? ",
              style: TextStyle(color: Colors.grey.shade500),
            ),
            GestureDetector(
              onTap: () {
                changeLogin(true);
              },
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 0, 190, 184)),
              ),
            )
          ],
        ),
      ],
    );

    var verify = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "lib/assets/images/login/otp.png",
        ),
        SizedBox(height: 16),
        Text(
          "OTP Verification",
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
              color: const Color.fromARGB(255, 0, 190, 184)),
        ),
        Text(
          "Enter the OTP sent to +91${_phoneNumberController.text}",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400),
        ),
        SizedBox(
          height: 18,
        ),
        // Container(
        //   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        //   decoration: BoxDecoration(color: Colors.white, boxShadow: const [
        //     BoxShadow(
        //       color: Colors.black12,
        //       offset: Offset(3, 3),
        //       blurRadius: 3,
        //       spreadRadius: 0.5,
        //     )
        //   ]),
        //   child: TextField(
        //     keyboardType: TextInputType.number,
        //     decoration: const InputDecoration(
        //       border: InputBorder.none,
        //       label: Text("Code"),
        //       fillColor: Colors.white,
        //       filled: true,
        //     ),
        //     controller: _confirmCodeController,
        //   ),
        // ),
        Pinput(
          length: 6,
          controller: _confirmCodeController,
          keyboardType: TextInputType.number,
          onCompleted: (value) async {
            await codeSubmit();
          },
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(3, 3),
              blurRadius: 10,
              spreadRadius: 0.5,
            )
          ]),
          child: TextButton(
              onPressed: () async {
                await codeSubmit();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 0, 190, 184))),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.symmetric(vertical: 7),
                child: Center(
                  child: const Text(
                    "Verify & Proceed",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
        ),
        const SizedBox(
          height: 18,
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
            if (isLoggedChecked)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 20),
                decoration: BoxDecoration(color: Colors.white),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 70),
                  height: MediaQuery.of(context).size.height,
                  child: Center(
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
            if (!isLoggedChecked)
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Image.asset("lib/assets/images/Shore_Logo.png",
                        width: MediaQuery.of(context).size.width * 0.6),
                  )),
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
