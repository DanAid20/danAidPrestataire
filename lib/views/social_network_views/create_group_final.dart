import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/conversationChatModel.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/providers/usersListProvider.dart';
import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGroupFinalStep extends StatefulWidget {
  @override
  _CreateGroupFinalStepState createState() => _CreateGroupFinalStepState();
}

class _CreateGroupFinalStepState extends State<CreateGroupFinalStep> {

  QuerySnapshot searchSnapshot;
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _groupNameController = new TextEditingController();
  TextEditingController _groupDescriptionController = new TextEditingController();
  TextEditingController _organizationNameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _contactNameController = new TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  SharedPreferences preferences;
  
  PageController controller = PageController(initialPage: 0, keepPage: false);
  int currentPageValue = 0;
  List<Widget> pageList;
  bool confirm = false;

  List<UserModel> _users = [];
  
  File imageFileAvatar;
  bool imageLoading = false;
  bool buttonLoading = false;
  String avatarUrl;
  bool imageSpinner = false;

  bool publicGroup = false;
  bool privateGroup = false;
  String groupType;
  String _type;
  String phone;
  bool phoneEnabled = false;
  String initialCountry = 'CM';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');

  bool _serviceTermsAccepted = false;
  bool _trustConditionAccepted = false;

  initTextFields(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if((userProvider.getUserModel.fullName != null) & (userProvider.getUserModel.fullName != "")){
      setState(() {
        _contactNameController.text = userProvider.getUserModel.fullName;
      });
    }
    if (userProvider.getUserModel.phoneList[0] != null){
      setState(() {
        phone = userProvider.getUserModel.phoneList[0]["number"];
      });
    }
  }

  searches() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UsersListProvider usersListProvider = Provider.of<UsersListProvider>(context, listen: false);
    UserModel user = userProvider.getUserModel;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("USERS").where("nameKeywords", arrayContains: _searchController.text.toLowerCase()).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        //_users = [];

        List<bool> _checked = List<bool>.filled(snapshot.data.docs.length, false);
        return snapshot.data.docs.length >= 1 ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot userSnapshot = snapshot.data.docs[index];
            UserModel singleUser = UserModel.fromDocument(userSnapshot);
            if (singleUser.userId == user.userId) {
              return Container();
            }
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Row(
                  children: [
                    Checkbox(
                      value: _checked[index],
                      fillColor: MaterialStateProperty.all(kDeepTeal),
                      onChanged: (val){
                        setState(() {
                          _checked[index] = val;
                        });
                        if(_checked[index] == true){
                          if (!_users.contains(singleUser)){
                            _users.add(singleUser);
                          }
                        }
                        else {_users.remove(singleUser);}
                        //_checked[index] == true ? usersListProvider.addUser(singleUser) : usersListProvider.removeUser(singleUser);
                      }
                    ),
                    Expanded(
                      child: SearchResult(
                        user: user,
                        target: singleUser,
                        onTap: (){
                          setState(() {
                            _checked[index] = !_checked[index];
                          });
                          if(_checked[index] == true){
                          if (!_users.contains(singleUser)){
                            _users.add(singleUser);
                          }
                        }
                        else {_users.remove(singleUser);}
                          //_checked[index] == true ? usersListProvider.addUser(singleUser) : usersListProvider.removeUser(singleUser);
                        },
                      ),
                    ),
                  ],
                );
              }
            );
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(MdiIcons.databaseRemove, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text(S.of(context).aucunUtilisateurAvecPourNom+" :\n \"${_searchController.text}\"", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    initTextFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 

    pageList = <Widget>[
      formLayout(getStep1()),
      formLayout(getStep2()),
      formLayout(getStep3(context)),
    ];
    return WillPopScope(
      onWillPop: () async {
        if (currentPageValue == 0)
          Navigator.pop(context);
        else
          controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
            onPressed: (){
              if (currentPageValue == 0)
                Navigator.pop(context);
              else
                controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
            }
          ),
          title: Text(S.of(context).ajouterUnBnficiaire, style: TextStyle(color: kPrimaryColor, fontSize: wv*4.5, fontWeight: FontWeight.w500),),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(currentPageValue == 0 ? "1 / 3\n" : currentPageValue == 1 ? "2 / 3\n" : "3 / 3\n", style: TextStyle(fontWeight: FontWeight.w700,color: kBlueDeep),),
            ),
            Expanded(
              child: PageView.builder(
                pageSnapping: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: pageList.length,
                onPageChanged: (int page) => getChangedPageAndMoveBar(page),
                controller: controller,
                itemBuilder: (context, index) {
                  return pageList[index];
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: hv*3, top: hv*2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < pageList.length; i++)
                    if (i == currentPageValue) ...[circleBar(true)] else
                      circleBar(false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        imageSpinner = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context).aucuneImageSelectionne),));
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 75);
    if (pickedFile != null) {
      setState(() {
        imageSpinner = true;
      });
      setState(() {
        imageFileAvatar = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context).aucuneImageSelectionne),));
    }
  }

  Widget noUsers(context) {
    final hv = MediaQuery.of(context).size.height / 100;
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: hv * 30),
          Hero(
            tag: "search",
            child: Icon(
              Icons.search,
              size: hv * 10,
              color: Colors.grey,
            ),
          ),
          Text(
            S.of(context).cherchezDesUtilisateurs,
            style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  getStep1(){
    UsersListProvider usersListProvider = Provider.of<UsersListProvider>(context, listen: false);
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: hv*3),
                decoration: BoxDecoration(
                  color: kSouthSeas.withOpacity(0.4),
                  image: imageFileAvatar != null ? DecorationImage(image: FileImage(imageFileAvatar), fit: BoxFit.cover) : null,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).ajouterUnePhoto, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.bold),),
                      IconButton(
                        icon: CircleAvatar(backgroundColor: kDeepTeal,child: Icon(LineIcons.plus, color: whiteColor, size: 25,)), 
                        onPressed: ()=>FunctionWidgets.chooseImageProvider(context: context, gallery: getImageFromGallery, camera: getImageFromCamera),
                      ),
                    ],
                  )
                ],),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: wv*1, vertical: hv*2),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: usersListProvider.getUsers.map((UserModel user) {
                                return Column(
                                  children: [
                                    CircleAvatar(
                                      radius: wv*5,
                                      backgroundColor: kSouthSeas.withOpacity(0.4),
                                      backgroundImage: user.imgUrl != null ? CachedNetworkImageProvider(user.imgUrl) : null,
                                      child: user.imgUrl == null ? Icon(LineIcons.user, color: whiteColor,) : Container(),
                                    ),
                                    SizedBox(child: Text(user.fullName, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,), width: wv*16,)
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: hv*1.5),

                        CustomTextField(
                          label: S.of(context).nomDuGroupe,
                          onChanged: (val)=>setState((){}),
                          controller: _groupNameController,
                        ),

                        SizedBox(height: hv*2,),

                        CustomTextField(
                          label: S.of(context).descriptionDuGroupe,
                          multiLine: true,
                          minLines: 4,
                          maxLines: 5,
                          onChanged: (val)=>setState((){}),
                          controller: _groupDescriptionController,
                        ),

                        SizedBox(height: hv*2,),

                        Row(
                          children: [
                            SizedBox(width: wv*2,),
                            SvgPicture.asset('assets/icons/Two-tone/Unlock.svg', width: wv*7),
                            Expanded(
                              child: CheckboxListTile(
                                value: publicGroup,
                                dense: true,
                                onChanged: (val)=>setState((){publicGroup = val; privateGroup = !val; groupType = "PUBLIC";}),
                                activeColor: primaryColor,
                                title: Text(S.of(context).publique, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 16)),
                                subtitle: Text(S.of(context).toutLeMondePeutVoirChaqueIntitPeutAjouterDes),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: hv*1,),

                        Row(
                          children: [
                            SizedBox(width: wv*2,),
                            SvgPicture.asset('assets/icons/Two-tone/Unlock.svg', width: wv*7),
                            Expanded(
                              child: CheckboxListTile(
                                value: privateGroup,
                                dense: true,
                                onChanged: (val)=>setState((){privateGroup = val; publicGroup = !val; groupType = "PRIVATE";}),
                                activeColor: primaryColor,
                                title: Text(S.of(context).priv, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 16)),
                                subtitle: Text(S.of(context).seulsLesInvitsPeuventVoirSeulLadminPeutAjouterDes),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: hv*2,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                text: S.of(context).suivant,
                expand: false,
                enable: _groupNameController.text.isNotEmpty && _groupDescriptionController.text.isNotEmpty && groupType != null,
                action: ()=>controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate),
              ),
            ),
            Expanded(
              child: CustomTextButton(
                text: S.of(context).annuler,
                color: kSouthSeas,
                expand: false,
                action: ()=>Navigator.pop(context),
              ),
            ),
          ],
        )

      ],
    );
  }

  getStep2(){
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: hv*3),
                decoration: BoxDecoration(
                  color: kSouthSeas.withOpacity(0.4),
                  image: imageFileAvatar != null ? DecorationImage(image: FileImage(imageFileAvatar), fit: BoxFit.cover) : null,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).ajouterUnePhoto, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.bold),),
                      IconButton(
                        icon: CircleAvatar(backgroundColor: kDeepTeal,child: Icon(LineIcons.plus, color: whiteColor, size: 25,)), 
                        onPressed: ()=>FunctionWidgets.chooseImageProvider(context: context, gallery: getImageFromGallery, camera: getImageFromCamera),
                      ),
                    ],
                  )
                ],),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*3),
                    child: Column(
                      children: [
                        SizedBox(height: hv*2.5),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: wv*3),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).typeDeGroupe, style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
                              SizedBox(height: 5,),
                              Container(
                                constraints: BoxConstraints(minWidth: wv*45),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    hint: Text(S.of(context).choisir, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                    isExpanded: true,
                                    value: _type,
                                    items: [
                                      DropdownMenuItem(
                                        child: Text(S.of(context).rseauMdecinDeFamille, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                        value: S.of(context).mdf,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(S.of(context).association, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                        value: S.of(context).association,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(S.of(context).entreprise, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                        value: S.of(context).entreprise,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(S.of(context).sponsor, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                        value: S.of(context).sponsor,
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _type = value;
                                      });
                                    }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: hv*2,),

                        CustomTextField(
                          label: S.of(context).nomDeLorganisation,
                          onChanged: (val)=>setState((){}),
                          controller: _organizationNameController,
                        ),

                        SizedBox(height: hv*2,),

                        CustomTextField(
                          label: S.of(context).personneContact,
                          onChanged: (val)=>setState((){}),
                          controller: _contactNameController,
                        ),

                        SizedBox(height: hv*2.5,),

                        !phoneEnabled ? Container(
                          margin: EdgeInsets.symmetric(horizontal: wv*3),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 2.0, spreadRadius: 1.0)]
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: wv*3),
                            title: Text(S.of(context).numroMobile, style: TextStyle(fontSize: wv*4, color: Colors.grey[600]),),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(phone, style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                            ),
                            trailing: IconButton(
                              enableFeedback: false,
                              icon: CircleAvatar(
                                radius: wv * 3.5,
                                backgroundColor: kDeepTeal,
                                child: Icon(
                                  Icons.edit,
                                  color: whiteColor,
                                  size: wv * 4,
                                ),
                              ),
                              onPressed: ()=>setState((){phoneEnabled = true;}),
                            ),
                          ),
                        ):
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: wv*3),
                          child: Column(children: [
                            Text(S.of(context).numroMobile, style: TextStyle(fontSize: wv*4),),
                            SizedBox(height: hv*1,),
                            InternationalPhoneNumberInput(
                              validator: (String phone) {
                                return (phone.isEmpty)
                                    ?  S.of(context).entrerUnNumeroDeTlphoneValide : null;
                              },
                              onInputChanged: (PhoneNumber number) {
                                phone = number.phoneNumber;
                                print(number.phoneNumber);
                              },
                              onInputValidated: (bool value) {
                                print(value);
                              },
                              spaceBetweenSelectorAndTextField: 0,
                              selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET,),
                              ignoreBlank: false,
                              textStyle: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: number,
                              textFieldController: _phoneController,
                              formatInput: true,
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputDecoration: defaultInputDecoration(),
                              onSaved: (PhoneNumber number) {
                                print('On Saved: $number');
                              }, 
                            )
                          ],crossAxisAlignment: CrossAxisAlignment.start,),
                        ),
                        
                        SizedBox(height: hv*2.5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                text: S.of(context).suivant,
                expand: false,
                enable: _contactNameController.text.isNotEmpty && _organizationNameController.text.isNotEmpty && phone != null && _type != null,
                action: ()=>controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate),
              ),
            ),
            Expanded(
              child: CustomTextButton(
                text: S.of(context).annuler,
                color: kSouthSeas,
                expand: false,
                action: ()=>Navigator.pop(context),
              ),
            ),
          ],
        )

      ],
    );
  }
  
  getStep3(BuildContext context){
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: hv*3),
                decoration: BoxDecoration(
                  color: kSouthSeas.withOpacity(0.4),
                  image: imageFileAvatar != null ? DecorationImage(image: FileImage(imageFileAvatar), fit: BoxFit.cover) : null,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).ajouterUnePhoto, style: TextStyle(color: kTextBlue, fontWeight: FontWeight.bold),),
                      IconButton(
                        icon: CircleAvatar(backgroundColor: kDeepTeal,child: Icon(LineIcons.plus, color: whiteColor, size: 25,)), 
                        onPressed: ()=>FunctionWidgets.chooseImageProvider(context: context, gallery: getImageFromGallery, camera: getImageFromCamera),
                      ),
                    ],
                  )
                ],),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*0),
                    child: Column(
                      children: [
                        SizedBox(height: hv*2.5),

                        HomePageComponents.termsAndConditionsTile(
                          action: ()=>FunctionWidgets.termsAndConditionsDialog(context: context),
                          value: _serviceTermsAccepted,
                          activeColor: primaryColor,
                          onChanged: (newValue) {
                            setState(() {
                              _serviceTermsAccepted = newValue;
                            });
                          },
                        ),
                        SizedBox(height: hv*2.5),

                        HomePageComponents.confirmTermsTile(
                          action: ()=>FunctionWidgets.termsAndConditionsDialog(context: context),
                          value: _trustConditionAccepted,
                          activeColor: primaryColor,
                          onChanged: (newValue) {
                            setState(() {
                              _trustConditionAccepted = newValue;
                            });
                          },
                        ),
                        
                        SizedBox(height: hv*2.5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                text: S.of(context).terminer,
                expand: false,
                isLoading: buttonLoading,
                enable: _serviceTermsAccepted && _trustConditionAccepted,
                action: () async {
                  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                  UsersListProvider usersListProvider = Provider.of<UsersListProvider>(context, listen: false);
                  setState(() {
                    buttonLoading = true;
                  });
                  List<String> members = []; List<String> membersImgUrls = []; //List<String> membersAuths = [];

                  for(int i = 0; i < usersListProvider.getUsers.length; i++){
                    members.add(usersListProvider.getUsers[i].userId);
                    if(usersListProvider.getUsers[i].imgUrl != null){
                      membersImgUrls.add(usersListProvider.getUsers[i].imgUrl);
                    }
                  }
                  
                  members.add(userProvider.getUserModel.userId);
                  //usersListProvider.getUsers.map((UserModel user) => members.add(user.userId));
                  print(members.toString());
                  String url;
                  Map<String, dynamic> input = {
                    "dateCreated": DateTime.now(),
                    "creatorAuthId": userProvider.getUserModel.authId,
                    "creatorId": userProvider.getUserModel.userId,
                    "adminsIds": [userProvider.getUserModel.userId],
                    "creatorAvatar": userProvider.getUserModel.imgUrl,
                    "groupName": _groupNameController.text,
                    "groupDescription": _groupDescriptionController.text,
                    "contactName": _contactNameController.text,
                    "organizationName": _organizationNameController.text,
                    "groupType": _type,
                    "groupCategory": groupType,
                    "contactPhone": phone,
                    "membersIds": members,
                    "membersAvatarsUrls": membersImgUrls,
                    "imgUrl": url
                  };
                  if (imageFileAvatar != null) {
                    File file = imageFileAvatar;
                    String path = 'groups/${userProvider.getUserModel.userId}/'+_groupNameController.text;
                    Reference storageReference = FirebaseStorage.instance.ref().child(path);
                    final metadata = SettableMetadata(
                      customMetadata: {'picked-file-path': file.path}
                    );

                    UploadTask storageUploadTask;
                    if (kIsWeb) {
                      storageUploadTask = storageReference.putData(await file.readAsBytes(), metadata);
                    } else {
                      storageUploadTask = storageReference.putFile(File(file.path), metadata);
                    }

                    storageUploadTask.catchError((e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                    });
                    storageUploadTask.whenComplete(() async {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${_groupNameController.text} ajoutée")));
                      url = await storageReference.getDownloadURL();
                      input["imgUrl"] = url;
                      print("download url: $url");
                      await createGroup(id: userProvider.getUserModel.authId, input: input);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Groupe ajouté")));
                      usersListProvider.setUsers([]);
                      Navigator.pop(context);
                    }).catchError((e){
                      print(e.toString());
                    });
                  } else {
                    await createGroup(id: userProvider.getUserModel.authId, input: input);
                    setState(() {
                      buttonLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Groupe ajouté")));
                    usersListProvider.setUsers([]);
                    Navigator.pop(context);
                  }
                  setState(() {
                    buttonLoading = false;
                  });
                },
              ),
            ),
            Expanded(
              child: CustomTextButton(
                text: S.of(context).annuler,
                color: kSouthSeas,
                enable: !buttonLoading,
                expand: false,
                action: ()=>Navigator.pop(context),
              ),
            ),
          ],
        )

      ],
    );
  }

  createGroup({String id, Map input}) async {
    try {
      print("inside");
      await FirebaseFirestore.instance.collection("GROUPS")
        .add(input).then((value) {
          Navigator.pop(context);
        })
        .catchError((e){
          print(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          setState(() {
            buttonLoading = false;
          });
      });
    }
    catch(e) {
      print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          buttonLoading = false;
        });
    }
  }
  
  
  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget formLayout(Widget content){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 3.0, spreadRadius: 1.0)]
      ),
      child: content,
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
          color: isActive ? kDeepTeal : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}

class SearchResult extends StatelessWidget {
  final UserModel user;
  final UserModel target;
  final Function onTap;

  const SearchResult({Key key, this.onTap, this.user, this.target}) : super(key: key);

  ConversationChatModel getConversation() {
    ConversationChatModel chatRoomModel = ConversationChatModel();
    String conversationId = Algorithms.getConversationId(userId: user.authId, targetId: target.authId);
    FirebaseFirestore.instance.collection("CONVERSATIONS").doc(conversationId).get().then((conversation) {
      ConversationChatModel chatRoom = ConversationChatModel.fromDocument(conversation);
      chatRoomModel = chatRoom;
    });
    return chatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: hv*0.2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: target.imgUrl != null
              ? CachedNetworkImageProvider(target.imgUrl)
              : null,
          child: target.imgUrl != null ? Container() : Icon(LineIcons.user, color: whiteColor,),
        ),
        title: Text(target.fullName),
        subtitle: Text(target.profileType == doctor ? S.of(context).mdecin : target.profileType == serviceProvider ? S.of(context).prestataire : S.of(context).adhrent, style: TextStyle(color: kTextBlue),),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: kDeepTeal,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}