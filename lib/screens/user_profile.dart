import 'dart:io';
import 'package:cparking/provider/userData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../widgets/badge.dart';
import 'package:path/path.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfile extends StatefulWidget {
  String userName;
  String userId;

  static const routeName = '/userProfile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // var _user;
  bool _isInit = true;
  bool _isLoading = false;
  bool _isGetimage = false;
  File _image;
  String _uploadedFileURL;
  
  var _editedUserProfile = UserData(
    id: null,
    profileImageUrl: '',
    reports: null,
    score: 0,
    userName: '',
  );

  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/cover.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future getImage(String userId) async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = _image;
      _isGetimage = true;
      // print(_image);
    });
  }

  Future uploadProfilePicture(context, userId) async {
    try {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('userProfile/$userId/${basename(_image.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      setState(() {
        _isLoading = true;
      });
      await uploadTask.onComplete;
      setState(() {
        _isLoading = false;
      });
      storageReference.getDownloadURL().then((fileUrl) {
        setState(() {
          _uploadedFileURL = fileUrl;
          _editedUserProfile = UserData(
            id: _editedUserProfile.id,
            profileImageUrl: _uploadedFileURL,
            reports: _editedUserProfile.reports,
          );
        });
      }).then((_) =>
          Provider.of<Auth>(context).updateUserProfile(_editedUserProfile));
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  Widget _buildProfileImage(Auth userData) {
    return Center(
      child: Container(
        child: GestureDetector(
          onTap: () {
            getImage(
              (userData.userData.userName),
            );
          },
          child: Badge(
            color: Colors.black87,
            // value: '2',
          ),
        ),
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (userData.userData.profileImageUrl) == ""
                ? AssetImage('images/unknownProfileImg.png')
                : NetworkImage(
                    (userData.userData.profileImageUrl).toString(),
                  ),
            fit: BoxFit.scaleDown,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName(String _fullName) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Raleway',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      _fullName,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context, Auth userData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        'GOLD II',
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Raleway',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer(Auth userData) {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // _buildStatItem("Followers", _followers),
          _buildStatItem("Posts", (userData.userReportsCount.toString())),
          _buildStatItem(
            "Scores",
            (userData.userData.score.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Lato',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => print("followed"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "FOLLOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () => print("Message"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "MESSAGE",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final _userData = Provider.of<Auth>(context);

    return Scaffold(
      // extendBody: true,
      // appBar: AppBar(
      //   leading: IconButton(
      //     color: Colors.transparent,
      //     icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SizedBox(
            height: 50,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          color: Colors.black54,
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height / 5),

                  _buildProfileImage(_userData),
                  _buildFullName(
                    (_userData.userData.userName),
                  ),
                  _buildStatus(context, _userData),
                  _buildStatContainer(_userData),
                  // _buildBio(context),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSeparator(screenSize),
                  SizedBox(height: 10.0),
                  !_isGetimage
                      ? SizedBox(
                          height: 10,
                        )
                      : Center(
                          child: FlatButton(
                            color: Colors.grey,
                            onPressed: () async {
                              await uploadProfilePicture(
                                  context, _userData.userId);
                            },
                            child: Text('Update Profile Picture'),
                          ),
                        ),
                  // _buildGetInTouch(context),
                  SizedBox(height: 8.0),
                  // _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
