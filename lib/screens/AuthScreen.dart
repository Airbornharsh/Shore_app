import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/HomeScreen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLogin = true;
  // var isConfirmCode = false;
  var isLoading = false;
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = TextEditingController();
  // final _confirmCodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _phoneNumberController.dispose();
    _emailIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  @override
  Widget build(BuildContext context) {
    var login = Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? const Color.fromARGB(255, 0, 99, 95)
                      : const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Email / Number / UserName",
              hintStyle: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              fillColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade900
                  : Colors.white,
              filled: true,
            ),
            controller: _authController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? const Color.fromARGB(255, 0, 99, 95)
                      : const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Password",
              hintStyle: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              fillColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade900
                  : Colors.white,
              filled: true,
            ),
            controller: _passwordController,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              String loginRes = await Provider.of<User>(context, listen: false)
                  .signIn(_authController.text, _passwordController.text);

              if (loginRes == "Done") {
                var snackBar = SnackBar(
                  content: const Text('Logged In'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                Navigator.of(context).popAndPushNamed("/");
              } else {
                var snackBar = SnackBar(
                  content: Text(loginRes),
                  // action: SnackBarAction(
                  //   label: 'Undo',
                  //   onPressed: () {
                  //     // Some code to undo the change.
                  //   },
                  // ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // _authController.clear();
                // _passwordController.clear();
              }
              setState(() {
                isLoading = false;
              });
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Provider.of<AppSetting>(context).getdarkMode
                        ? const Color.fromARGB(255, 0, 99, 95)
                        : const Color.fromARGB(255, 0, 190, 184))),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white),
            )),
        const SizedBox(
          height: 7,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isLogin = false;
            });
          },
          child: Text(
            "Create an New Account",
            style: TextStyle(
                fontSize: 14,
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? const Color.fromARGB(255, 0, 150, 145)
                    : const Color.fromARGB(255, 0, 190, 184)),
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
              border: Border.all(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? const Color.fromARGB(255, 0, 99, 95)
                      : const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Name",
              hintStyle: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              fillColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade900
                  : Colors.white,
              filled: true,
            ),
            controller: _nameController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? const Color.fromARGB(255, 0, 99, 95)
                      : const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "User Name",
              hintStyle: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              fillColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade900
                  : Colors.white,
              filled: true,
            ),
            controller: _userNameController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? const Color.fromARGB(255, 0, 99, 95)
                      : const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Phone Number",
              hintStyle: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              fillColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade900
                  : Colors.white,
              filled: true,
            ),
            controller: _phoneNumberController,
            keyboardType: TextInputType.number,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? const Color.fromARGB(255, 0, 99, 95)
                      : const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Email Id",
              hintStyle: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              fillColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade900
                  : Colors.white,
              filled: true,
            ),
            controller: _emailIdController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? const Color.fromARGB(255, 0, 99, 95)
                      : const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Password",
              hintStyle: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              fillColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade900
                  : Colors.white,
              filled: true,
            ),
            controller: _confirmPasswordController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? const Color.fromARGB(255, 0, 99, 95)
                      : const Color.fromARGB(255, 0, 190, 184))),
          child: TextField(
            style: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Confirm Password",
              hintStyle: TextStyle(
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              fillColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade900
                  : Colors.white,
              filled: true,
            ),
            controller: _passwordController,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              try {
                String Res = await Provider.of<User>(context, listen: false)
                    .signUp(
                        _nameController.text,
                        _userNameController.text,
                        int.parse(_phoneNumberController.text),
                        _emailIdController.text,
                        _passwordController.text,
                        _confirmPasswordController.text);

                if (Res == "Done") {
                  setState(() {
                    isLogin = true;
                  });
                } else {
                  var snackBar = SnackBar(content: Text(Res));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    isLoading = false;
                  });
                  // _nameController.clear();
                  // _userNameController.clear();
                  // _phoneNumberController.clear();
                  // _emailIdController.clear();
                  // _passwordController.clear();
                  // _confirmPasswordController.clear();
                }
                // setState(() {
                //   isConfirmCode = true;
                // });
              } catch (e) {
                print(e);
                setState(() {
                  isLoading = false;
                });
              }
              setState(() {
                isLoading = false;
              });
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Provider.of<AppSetting>(context).getdarkMode
                        ? const Color.fromARGB(255, 0, 99, 95)
                        : const Color.fromARGB(255, 0, 190, 184))),
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white),
            )),
        const SizedBox(
          height: 7,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isLogin = true;
            });
          },
          child: Text(
            "Login Instead",
            style: TextStyle(
                fontSize: 14,
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? const Color.fromARGB(255, 0, 150, 145)
                    : const Color.fromARGB(255, 0, 190, 184)),
          ),
        )
      ],
    );

    // var verify = Column(
    //   children: [
    //     Container(
    //       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //       padding: const EdgeInsets.only(top: 4),
    //       decoration: BoxDecoration(border: Border.all(color: Provider.of<AppSetting>(context).getdarkMode
    // ? const Color.fromARGB(255, 0, 99, 95)
    // : const Color.fromARGB(255, 0, 190, 184))),
    //       child: TextField(
    //         decoration: const InputDecoration(
    //           border: InputBorder.none,
    //           hintText: "Code",
    //           fillColor: Colors.white,
    //           filled: true,
    //         ),
    //         controller: _confirmCodeController,
    //       ),
    //     ),
    //     const SizedBox(
    //       height: 4,
    //     ),
    //     TextButton(
    //         onPressed: () async {
    //           setState(() {
    //             isLoading = true;
    //           });
    //           var res = await Provider.of<User>(context, listen: false)
    //               .CodeHandler(_confirmCodeController.text);

    //           if (res) {
    //             setState(() {
    //               isLogin = true;
    //             });
    //           } else {
    //             var snackBar =
    //                 const SnackBar(content: Text("Enter the Otp Correctly"));
    //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //             _confirmCodeController.clear();
    //           }
    //           setState(() {
    //             isLoading = false;
    //           });
    //         },
    //         style: ButtonStyle(
    //             backgroundColor:
    //                 MaterialStateProperty.all<Color>(Provider.of<AppSetting>(context).getdarkMode
    // ? const Color.fromARGB(255, 0, 99, 95)
    // : const Color.fromARGB(255, 0, 190, 184))),
    //         child: const Text(
    //           "Confirm Code",
    //           style: TextStyle(color: Colors.white),
    //         )),
    //     const SizedBox(
    //       height: 7,
    //     ),
    //     GestureDetector(
    //       onTap: () {
    //         setState(() {
    //           isConfirmCode = false;
    //         });
    //       },
    //       child: const Text("Re-Enter the Details"),
    //     ),
    //     const SizedBox(
    //       height: 7,
    //     ),
    //     GestureDetector(
    //       onTap: () {
    //         setState(() {
    //           isLogin = true;
    //         });
    //       },
    //       child: const Text(
    //         "Login Instead",
    //         style: TextStyle(fontSize: 14, color: Provider.of<AppSetting>(context).getdarkMode
    // ? const Color.fromARGB(255, 0, 99, 95)
    // : const Color.fromARGB(255, 0, 190, 184)),
    //       ),
    //     )
    //   ],
    // );

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? Colors.grey.shade900
                      : Colors.white),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 20),
                  width: (MediaQuery.of(context).size.width - 70),
                  // height: 500,
                  constraints: BoxConstraints(maxHeight: (isLogin ? 270 : 570)),
                  decoration: BoxDecoration(
                      color: Provider.of<AppSetting>(context).getdarkMode
                          ? Colors.grey.shade800
                          : Colors.white,
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
                    child: isLogin ? login : register,
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
