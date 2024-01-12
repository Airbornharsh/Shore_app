import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/snackBar.dart';
import 'package:shore_app/provider/SignUser.dart';

class NewPostContainer extends StatefulWidget {
  Function setIsLoading;
  bool isLoading;
  static String routeName = "new-post";
  NewPostContainer(
      {super.key, required this.isLoading, required this.setIsLoading});

  @override
  State<NewPostContainer> createState() => _NewPostContainerState();
}

class _NewPostContainerState extends State<NewPostContainer> {
  late File _tempFile;
  late File _originalFile;
  String _isFile = "";
  bool _isCroppped = false;
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                width: MediaQuery.of(context).size.width,
                height: _isFile == "image"
                    ? MediaQuery.of(context).size.width - 10 + 160
                    : 140,
                padding: const EdgeInsets.only(
                    top: 10, right: 20, bottom: 10, left: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            if (_isFile == "image")
                              Center(
                                child: Image.file(
                                  _tempFile,
                                  height: MediaQuery.of(context).size.width,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            if (_isFile == "image")
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    child: _isCroppped
                                        ? IconButton(
                                            onPressed: () async {
                                              final fileHeight =
                                                  (await decodeImageFromList(
                                                          (_originalFile)
                                                              .readAsBytesSync()))
                                                      .height;
                                              final fileWidth =
                                                  (await decodeImageFromList(
                                                          (_originalFile)
                                                              .readAsBytesSync()))
                                                      .width;

                                              final compressedtargetwidth =
                                                  (400 / fileHeight) *
                                                      fileWidth;

                                              File? compressedFile = 400 /
                                                          compressedtargetwidth !=
                                                      4 / 3
                                                  ? await FlutterNativeImage
                                                      .compressImage(
                                                          _originalFile.path,
                                                          quality: 40,
                                                          targetHeight: 400 * 2,
                                                          targetWidth:
                                                              compressedtargetwidth
                                                                      .toInt() *
                                                                  2)
                                                  : await FlutterNativeImage
                                                      .compressImage(
                                                          _originalFile.path,
                                                          quality: 40,
                                                          targetHeight:
                                                              compressedtargetwidth
                                                                      .toInt() *
                                                                  2,
                                                          targetWidth: 400 * 2);

                                              setState(() {
                                                _isCroppped = false;
                                                _tempFile = compressedFile;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.crop_original,
                                              color: Colors.grey.shade700,
                                            ))
                                        : IconButton(
                                            onPressed: () async {
                                              var fileHeight =
                                                  (await decodeImageFromList(
                                                          (_originalFile)
                                                              .readAsBytesSync()))
                                                      .height;
                                              var fileWidth =
                                                  (await decodeImageFromList(
                                                          (_originalFile)
                                                              .readAsBytesSync()))
                                                      .width;

                                              var offset = fileHeight >
                                                      fileWidth
                                                  ? (fileHeight - fileWidth) / 2
                                                  : (fileWidth - fileHeight) /
                                                      2;

                                              File croppedFile = (fileHeight /
                                                          fileWidth) ==
                                                      (4 / 3)
                                                  ? await FlutterNativeImage
                                                      .cropImage(
                                                          _originalFile.path,
                                                          offset.round(),
                                                          0,
                                                          fileHeight > fileWidth
                                                              ? fileWidth
                                                              : fileHeight,
                                                          fileHeight > fileWidth
                                                              ? fileWidth
                                                              : fileHeight)
                                                  : await FlutterNativeImage
                                                      .cropImage(
                                                          _originalFile.path,
                                                          fileHeight > fileWidth
                                                              ? 0
                                                              : offset.round(),
                                                          fileHeight > fileWidth
                                                              ? offset.round()
                                                              : 0,
                                                          fileHeight > fileWidth
                                                              ? fileWidth
                                                              : fileHeight,
                                                          fileHeight > fileWidth
                                                              ? fileWidth
                                                              : fileHeight);

                                              File? compressedFile =
                                                  await FlutterNativeImage
                                                      .compressImage(
                                                          croppedFile.path,
                                                          quality: 40,
                                                          targetHeight: 800,
                                                          targetWidth: 800);

                                              setState(() {
                                                _tempFile = compressedFile;
                                                _isCroppped = true;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.crop,
                                              color: Colors.grey.shade700,
                                            )),
                                  )),
                            if (_isFile == "image")
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isFile = "";
                                            _isCroppped = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        )),
                                  ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.black45)),
                            width: MediaQuery.of(context).size.width - 140,
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                          Container(
                            height: 45,
                            width: 82,
                            color: const Color.fromARGB(255, 0, 190, 184),
                            child: TextButton(
                              onPressed: () async {
                                try {
                                  if (_descriptionController.text.isEmpty) {
                                    snackBar(
                                        context, "Please enter description");
                                    return;
                                  }
                                  widget.setIsLoading(true);
                                  final user = Provider.of<SignUser>(context,
                                          listen: false)
                                      .getUserDetails;
                                  final random1 =
                                      (Random()).nextInt(99999).toString();
                                  final random2 =
                                      (Random()).nextInt(99999).toString();
                                  final fileName =
                                      "${_tempFile.path.split('/').last}_${random1 + random2}";
                                  final destination =
                                      "files/${user.id}/$fileName";

                                  bool res = await Provider.of<SignUser>(
                                          context,
                                          listen: false)
                                      .postUpload(
                                          _isFile,
                                          _tempFile,
                                          _descriptionController.text,
                                          fileName,
                                          destination);

                                  widget.setIsLoading(false);
                                  if (res) {
                                    snackBar(context, "Post Uploaded");
                                    setState(() {
                                      _descriptionController.clear();
                                      _isFile = "";
                                    });
                                  } else {
                                    snackBar(context, "Try Again");
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 0, 190, 184)),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(horizontal: 20),
                                ),
                              ),
                              child: const Text(
                                "Post",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
            child: GestureDetector(
              onTap: () async {
                try {
                  setState(() {
                    _isCroppped = false;
                  });
                  widget.setIsLoading(true);
                  print(await FilePicker.platform.getDirectoryPath());

                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(type: FileType.image, allowMultiple: false);

                  if (result == null) {
                    widget.setIsLoading(false);
                    return;
                  }

                  _isFile = "image";
                  String path = result.files[0].path as String;

                  final fileHeight = (await decodeImageFromList(
                          (File(path)).readAsBytesSync()))
                      .height;

                  final fileWidth = (await decodeImageFromList(
                          (File(path)).readAsBytesSync()))
                      .width;

                  final compressedtargetwidth = (400 / fileHeight) * fileWidth;

                  File? compressedFile = 400 / compressedtargetwidth != 4 / 3
                      ? await FlutterNativeImage.compressImage(path,
                          quality: 40,
                          targetHeight: 400 * 5,
                          targetWidth: compressedtargetwidth.toInt() * 5)
                      : await FlutterNativeImage.compressImage(path,
                          quality: 40,
                          targetHeight: compressedtargetwidth.toInt() * 5,
                          targetWidth: 400 * 5);

                  setState(() {
                    _tempFile = compressedFile;
                    _originalFile = compressedFile;
                  });
                  widget.setIsLoading(false);
                } catch (e) {
                  print("Cannot to Select File");
                  print(e);
                  _isFile = "";
                  widget.setIsLoading(false);
                }
              },
              child: Container(
                  child: Icon(
                    _isFile == "image" ? Icons.edit : Icons.add_a_photo,
                    size: 20,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color.fromARGB(255, 0, 190, 184))),
            ),
            bottom: 16,
            right: 16),
        if (widget.isLoading)
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
    );
  }
}
