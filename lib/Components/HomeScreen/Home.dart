import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shore_app/Components/HomeScreen/Upload.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration:
            const BoxDecoration(color: Color.fromARGB(31, 121, 121, 121)),
        height: MediaQuery.of(context).size.height - 130,
        child: Column(
          children: const [
            SizedBox(
              height: 12,
            ),
            Upload(),
            SizedBox(
              height: 12,
            ),
            
          ],
        ),
      ),
    );
  }
}
