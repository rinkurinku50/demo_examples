import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageVideoPickDemo extends StatefulWidget {
  @override
  _ImageVideoPickDemo createState() => _ImageVideoPickDemo();
}

class _ImageVideoPickDemo extends State<ImageVideoPickDemo> {
  final picker = ImagePicker();
  var _image1;
  File _image;
  bool showView = false;
  List<dynamic> allData = ["add"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // _image1 != null
              //     ? SizedBox(
              //   height: 250,
              //   width: 250,
              //   child: Image.memory(_image1),
              // )
              //     : SizedBox(),
              CupertinoButton(child: Text("Open"), onPressed: getImage),
              CupertinoButton(child: Text("Video"), onPressed: getVideo),
              CupertinoButton(child: Text("Show"), onPressed: showList),
              showView ? buildGridView() : SizedBox.shrink()
              // showView ? Expanded(
              //     child: ListView.builder(
              //       itemCount: allData.length,
              //       itemBuilder: (context, index) {
              //         return SizedBox(
              //           height: 150,
              //           width: 150,
              //           child: allData[index].type == 0 ? Image.memory(
              //               allData[index].memoryImage) : Container(
              //             color: Colors.red,
              //           ),
              //         );
              //       },
              //     )) : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    var _hh = await pickedFile.readAsBytes();
    setState(() {
      if (pickedFile != null) {
        _image1 = _hh;
        allData.insert(0, MyModelImage(
            file: pickedFile,
            type: checkType(pickedFile.path),
            imageName: pickedFile.path,
            memoryImage: _hh
        ));
      }
    });
    print("type ${checkType(pickedFile.path)}");
    print("typeName ${pickedFile.path
        .split("/")
        .last}");
  }

  Future getVideo() async {
    PickedFile pickedFile = await picker.getVideo(
        source: ImageSource.gallery, maxDuration: Duration(seconds: 10));

    setState(() {
      if (pickedFile != null) {
        // _image1 = _hh;
        allData.insert(0, MyModelImage(
            file: pickedFile,
            type: checkType(pickedFile.path),
            imageName: pickedFile.path));
      }
    });

    print("type ${checkType(pickedFile.path)}");
  }

  int checkType(String file) {
    if (file.toString().endsWith(".jpg")) {
      return 0;
    } else if (file.toString().endsWith(".png")) {
      return 0;
    } else {
      return 1;
    }
  }

  String getName(String file) {
    return file
        .split("/")
        .last;
  }

  showList() {
    setState(() {
      showView = true;
    });
    // for (MyModelImage mm in allData) {
    //   // print("my files ${mm.imageName} ${mm.type} ${mm.file}");
    // }
  }


  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(allData.length, (index) {
        if (allData[index] is MyModelImage) {
          MyModelImage uploadModel = allData[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                allData[index].type == 0 ? Image.memory(
                    allData[index].memoryImage, width: 300,
                  height: 300,) : Container(
                  color: Colors.green,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        allData.replaceRange(index, index + 1, []);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            color: Colors.yellow,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // _onAddImageClick(index);
                getImage();
              },
            ),
          );
        }
      }),
    );
  }
}

class MyModelImage {
  PickedFile file;
  String imageName;
  int type;
  var memoryImage;

  MyModelImage({this.file, this.type, this.imageName, this.memoryImage});
}
