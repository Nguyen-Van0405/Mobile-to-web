//import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manga/screens/screens.dart';
import 'package:manga/widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';

import 'dart:io';


import 'comics_screen.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key ? key}) : super(key: key);

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {

  File ? image;
  late String url;

  Future pickImage(ImageSource _source) async {
    try {
      final image = await ImagePicker().pickImage(source: _source);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print("Failed to pick image: $e");
    }
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 110, right: 30, top: 40),
                  child: Row (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget> [
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                                maxRadius: 75,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  maxRadius: 70,
                                  backgroundImage: (image == null)
                                      ? AssetImage("assets/userimage.png")
                                      : FileImage(File(image!.path)) as ImageProvider

                                )
                            ),

                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 4,
                                          color: Theme.of(context).scaffoldBackgroundColor
                                      ),
                                      color: Colors.grey,
                                    ),


                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) => bottomSheet()),
    );

                                      },
                                        child: const Icon(Icons.edit, color: Colors.white,)

                                    )

                                    /*
                                    reusableButton("setting", const Icon(Icons.edit, color: Color.fromARGB(255, 22, 20, 20),), (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfile()));
                                    })
                                */
                                    )),
                          ],

                        ),

                      ),

                    ],

                  ),

                ),
              ],

            ),

          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text( "Xu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),),),
          Container(
            color: const Color.fromARGB(255, 36, 35, 35),
            height: 35,
            width: double.infinity,
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                squareButton(170, 25, "Lịch sử", false,  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ComicHomeScreen()));
                    
                }),
                const SizedBox(width: 10,),
                squareButton(170, 25, "Nạp xu", true,  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ComicHomeScreen()));
                    
                }),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              //padding: EdgeInsets.all(20),
              color: const Color.fromARGB(171, 252, 251, 251),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget> [
                  Column(
                    children: <Widget> [
                      button3(context, "Truyện theo dõi", const Icon(Icons.trending_up, color: Colors.grey,), () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ComicHomeScreen()));
                        //
                      }),
                      button3(context, "Thông báo", const Icon(Icons.notifications_none, color: Colors.grey), () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ComicHomeScreen()));
                        //
                      }),
                      button3(context, "Cài đặt", const Icon(Icons.settings, color: Colors.grey), () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ComicHomeScreen()));
                        //
                      }),                  
                      
                    ],
                  )
                ],
              )
              )
          ),
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            decoration:
            BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                

            ),
            child: MaterialButton(
              minWidth: 200,
              height: 40,
              onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) => {
                    print("Sign out"),
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => const LoginPage())),
                    });
              },
              color: const Color.fromARGB(255, 216, 210, 208),
              
              //border:  Border.all(color: Color.fromARGB(255, 104, 101, 101)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color.fromARGB(255, 104, 101, 101))
              ),
              child: const Text(
                "Đổi tài khoản", style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color.fromARGB(255, 104, 101, 101),
              ),
              ),

            ),


          ),

        ],

      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 14,),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [BoxShadow(
                offset: const Offset(0, -15),
                blurRadius: 20,
                color: const Color(0xFFDADADA).withOpacity(0.15),
              )]
          ),
          child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // IconButton(onPressed: () {}, icon: Icon(Icons.home),),
                  button2("Trang chủ", const Icon(Icons.home), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ComicHomeScreen()));
                  }),
                  //IconButton(onPressed: () {}, icon: Icon(Icons.book)),
                  button2("Truyện tranh", const Icon(Icons.book), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ComicsScreen()));
                  }),
                  //IconButton(onPressed: () {}, icon: Icon(Icons.account_balance)), 
                  button2("Tủ sách", const Icon(Icons.account_balance), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ComicHomeScreen()));
                  }),
                  //IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  button2("Comicolours", const Icon(Icons.edit), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ComicHomeScreen()));
                  }),
                  //IconButton(onPressed: () {}, icon: Icon(Icons.account_circle), color: Colors.deepOrange,),
                  button2("Cá nhân", const Icon(Icons.account_circle, color: Colors.deepOrange), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfile()));
                  }),
                ],
              )
          )
      ),

    );

  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Chọn ảnh từ: ",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                pickImage(ImageSource.camera);
                final ref = FirebaseStorage.instance.ref().child('avatar');
                ref.putFile(image!);
              },
              label: const Text("Máy ảnh", style: TextStyle(color: Colors.black),),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () async {
                pickImage(ImageSource.gallery);

              },
              label: const Text("Thư viện", style: TextStyle(color: Colors.black)),
            ),
          ])
        ],
      ),
    );
  }

}


