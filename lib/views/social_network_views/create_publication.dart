import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';

class CreatePublication extends StatefulWidget {
  final String groupId;

  const CreatePublication({Key key, this.groupId}) : super(key: key);

  @override
  _CreatePublicationState createState() => _CreatePublicationState();
}

class _CreatePublicationState extends State<CreatePublication> {
  GlobalKey<AutoCompleteTextFieldState<String>> pubAutoCompleteKey = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController textController = new TextEditingController();
  TextEditingController tagController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  int pubType;
  int docQuestionChoosed = 0;
  int discussionChoosed = 1;
  int fundRaisingChoosed = 2;

  File imageFileAvatar;
  bool imageLoading = false;
  bool buttonLoading = false;
  bool imageSpinner = false;

  String currentSymptomText = "";
  List<String> suggestions = [
    "Santé",
    "Politique",
    "Médicament",
    "Détente",
    "Jeux",
    "DanAid",
    "Soins"
  ];
  List<String> tags = [];

  bool publishLoading = false;

  DateTime selectedDate;
  DateTime initialDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, size: 25, color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        centerTitle: true,
        title: Text("Créer une publication", style: TextStyle(color: kDeepTeal, fontSize: 17),),
        actions: [IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), onPressed: () => _scaffoldKey.currentState.openEndDrawer())],
      ),
      endDrawer: DefaultDrawer(
        entraide: (){Navigator.pop(context); Navigator.pop(context);},
        accueil: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        carnet: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        partenaire: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
        famille: (){Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);},
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: wv*7,
                          backgroundColor: Colors.blueGrey[100],
                          child: ClipOval(
                            child: CachedNetworkImage(
                              height: wv*14,
                              width: wv*14,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                child: Center(child: Icon(LineIcons.user, color: Colors.white, size: wv*25,)),
                                padding: EdgeInsets.all(20.0),
                              ),
                              imageUrl: userProvider.getUserModel.imgUrl),
                          ),
                        ),
                        SizedBox(width: wv*2.5,),
                        Text("Bonjour "+userProvider.getUserModel.fullName+",", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.w600, fontSize: 15),)
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HomePageComponents.publicationType(
                            icon: LineIcons.doctor,
                            title: "Question à un médecin",
                            selected: pubType == docQuestionChoosed,
                            action: (){
                              setState(() {
                                pubType = docQuestionChoosed;
                              });
                            }
                          ),
                          HomePageComponents.publicationType(
                            icon: LineIcons.commentDots,
                            title: "Nouvelle Discussion",
                            selected: pubType == discussionChoosed,
                            action: (){
                              setState(() {
                                pubType = discussionChoosed;
                              });
                            }
                          ),
                          HomePageComponents.publicationType(
                            icon: LineIcons.handshake,
                            title: "Levée de fonds",
                            selected: pubType == fundRaisingChoosed,
                            action: (){
                              setState(() {
                                pubType = fundRaisingChoosed;
                              });
                            }
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: hv*2),
                    Stack(
                      children: [
                        AnimatedContainer(
                          margin: EdgeInsets.only(bottom: hv*2),
                          duration: Duration(milliseconds: 220),
                          width: imageFileAvatar != null ? wv*50 : 0,
                          height: imageFileAvatar != null ? hv*20 : 0,
                          decoration: imageFileAvatar != null ? BoxDecoration(
                            color: Colors.grey[200],
                            image: DecorationImage(image: FileImage(imageFileAvatar), fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(15)
                          ) : null,
                        ),
                        imageFileAvatar != null ? Positioned(child: IconButton(icon: CircleAvatar(backgroundColor: kDeepTeal,child: Icon(LineIcons.times, color: whiteColor, size: 25,)), onPressed: ()=>setState((){imageFileAvatar = null;}),), right: 0) : Container()
                      ],
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 220),
                      height: pubType == 2 ? 95 : 0,
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: "Montant",
                                fillColor: Colors.grey[200],
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                onChanged: (val)=>setState((){}),
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),],
                                controller: amountController,
                              ),
                            ),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" Délais", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                                  SizedBox(height: 5,),
                                  GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Row(children: [
                                        SvgPicture.asset("assets/icons/Bulk/CalendarLine.svg", color: kDeepTeal,),
                                        VerticalDivider(),
                                        Text( selectedDate != null ? "${selectedDate.toLocal()}".split(' ')[0] : "Choisir", style: TextStyle(fontSize: wv*4, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                      ],),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    CustomTextField(
                      label: " Titre",
                      fillColor: Colors.grey[200],
                      labelColor: kDeepTeal,
                      noPadding: true,
                      controller: titleController
                    ),

                    SizedBox(height: hv*2.5,),
                    
                    TextField(
                      minLines: 5,
                      maxLines: 7,
                      controller: textController,
                      onChanged: (val) => setState((){}),
                      scrollPhysics: BouncingScrollPhysics(),
                      style: TextStyle(color: kDeepTeal),
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red[300]),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.only(top: hv*2, bottom: hv*2, left: wv*4, right: wv*4),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.transparent), 
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey[300]),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: "Que voulez vous dire...",
                        hintStyle: TextStyle(color: kDeepTeal),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      height: pubType == 1 ? 80 : 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: hv*2.5,),
                            Row(children: [
                            Text("Tags", style: TextStyle(fontSize: 16, color: kTextBlue),), SizedBox(width: wv*3,),
                            Expanded(
                              child: Stack(
                                children: [
                                  SimpleAutoCompleteTextField(
                                    key: pubAutoCompleteKey, 
                                    suggestions: suggestions,
                                    controller: tagController,
                                    decoration: defaultInputDecoration(fillColor: Colors.grey[200]),
                                    textChanged: (text) => currentSymptomText = text,
                                    clearOnSubmit: false,
                                    submitOnSuggestionTap: false,
                                    textSubmitted: (text) {
                                      if (text != "") {
                                        !tags.contains(tagController.text) ? tags.add(tagController.text) : print("yo"); 
                                      }
                                      
                                    }
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      onPressed: (){
                                        if (tagController.text.isNotEmpty) {
                                        setState(() {
                                          !tags.contains(tagController.text) ? tags.add(tagController.text) : print("yo");
                                          tagController.clear();
                                        });
                                      }
                                      },
                                      icon: CircleAvatar(child: Icon(Icons.add, color: whiteColor), backgroundColor: kSouthSeas,),),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                          ]),
                      ),
                    ),

                    SimpleTags(
                      content: tags,
                      wrapSpacing: 4,
                      wrapRunSpacing: 4,
                      onTagPress: (tag) {
                        setState(() {
                          tags.remove(tag);
                        });
                      },
                      tagContainerPadding: EdgeInsets.all(6),
                      tagTextStyle: TextStyle(color: kPrimaryColor),
                      tagIcon: Icon(Icons.clear, size: wv*3, color: kDeepTeal,),
                      tagContainerDecoration: BoxDecoration(
                        color: kSouthSeas.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  ]),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ajouter", style: TextStyle(color: kDeepTeal, fontSize: 20)),
                SizedBox(height: hv*1,),
                Row(
                  children: [
                    !imageSpinner ? getPublicationIconButton(
                      heroTag: "image",
                      iconPath: 'assets/icons/Two-tone/Camera.svg',
                      title: "Photo",
                      action: (){FunctionWidgets.chooseImageProvider(context: context, gallery: getImageFromGallery, camera: getImageFromCamera);}
                    ) : Loaders().buttonLoader(kDeepTeal),
                    getPublicationIconButton(
                      heroTag: "document",
                      iconPath: 'assets/icons/Two-tone/Document.svg',
                      title: "Doc",
                      action: (){}
                    ),
                    getPublicationIconButton(
                      heroTag: "video",
                      iconPath: 'assets/icons/Bulk/Video.svg',
                      title: "Vidéo",
                      action: (){}
                    ),
                    getPublicationIconButton(
                      heroTag: "voice",
                      iconPath: 'assets/icons/Two-tone/Voice.svg',
                      title: "Audio",
                      action: (){}
                    ),
                  ],
                ),
                SizedBox(height: hv*3,),
                Center(
                  child: SizedBox(
                    width: wv*70,
                    child: Row(children: [
                      Expanded(
                        child: CustomTextButton(
                          isLoading: publishLoading,
                          loaderColor: kDeepTeal,
                          text: "Publier",
                          enable: pubButtonEnabled(),
                          noPadding: true,
                          color: kDeepTeal,
                          action: () async {
                            setState(() {
                              publishLoading = true;
                            });
                            String url;
                            Map<String, dynamic> input = {
                              "dateCreated": DateTime.now(),
                              "userAuthId": userProvider.getUserModel.authId,
                              "user": FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel.userId),
                              "userId": userProvider.getUserModel.userId,
                              "userAvatar": userProvider.getUserModel.imgUrl,
                              "userName": userProvider.getUserModel.fullName,
                              "text": textController.text,
                              "post-type": pubType,
                              "likes": 0,
                              "tags": tags,
                              "amount": pubType == 2 ? double.parse(amountController.text) : null,
                              "dateline-date": pubType == 2 ? selectedDate : null,
                              "amount-collected": pubType == 2 ? 0.0 : null,
                              "imgUrl": url,
                              "title": titleController.text,
                              "imgList": []
                            };
                            if (imageFileAvatar != null) {
                              setState(() {
                                publishLoading = true;
                              });
                              File file = imageFileAvatar;
                              String name = (pubType == 0) ? "question-image" : (pubType == 1) ? "discussion-image" : "crowdfunding-image";
                              String path = (pubType == 0) ? 'posts/${userProvider.getUserModel.userId}/question/$name' : (pubType == 1) ? 'posts/${userProvider.getUserModel.userId}/discussion/$name' : 'posts/${userProvider.getUserModel.userId}/crowdfunding/$name';
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
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name ajoutée")));
                                url = await storageReference.getDownloadURL();
                                input["imgUrl"] = url;
                                print("download url: $url");
                                await publish(id: userProvider.getUserModel.authId, input: input);
                                setState(() {
                                  publishLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post ajouté")));
                                //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous venez d'être crédité de 15 points")));
                                Navigator.pop(context);
                              }).catchError((e){
                                print(e.toString());
                              });
                            } else {
                              await publish(id: userProvider.getUserModel.authId, input: input);
                              setState(() {
                                publishLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post ajouté")));
                              Navigator.pop(context);
                            }
                            setState(() {
                              publishLoading = false;
                            });

                            
                            
                          },
                        ),
                      ),
                      SizedBox(width: wv*2,),
                      Expanded(
                        child: CustomTextButton(
                          text: "Annuler",
                          enable: !publishLoading,
                          noPadding: true,
                          textColor: kDeepTeal,
                          color: Colors.transparent,
                          action: ()=>Navigator.pop(context),
                        ),
                      ),
                    ],),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  publish({String id, Map input}) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    DocumentReference normalRef = FirebaseFirestore.instance.collection("POSTS").doc();
    DocumentReference groupRef = FirebaseFirestore.instance.collection("GROUPS").doc(widget.groupId).collection("POSTS_GROUPS").doc();
    DocumentReference docRef = widget.groupId == null ? normalRef : groupRef;
    try {
      await docRef.set(input, SetOptions(merge: true)).then((doc) async {
        print(docRef.id);
        FirebaseMessaging.instance.subscribeToTopic(docRef.id).whenComplete(() { print("subscribed");});
        FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel.userId).update({"points": FieldValue.increment(15)}).then((value){
          userProvider.modifyPoints(15);
        });
      })
        .catchError((e){
          print(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          setState(() {
            publishLoading = false;
          });
      });
    }
    catch(e) {
      print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          publishLoading = false;
        });
    }
  }

  bool pubButtonEnabled(){
    if(pubType == 0 || pubType == 1){
      return textController.text.isNotEmpty ? true : false;
    }
    else if (pubType == 2){
      if(amountController.text.isNotEmpty && selectedDate != null && textController.text.isNotEmpty){
        return true;
      }
      return false;
    }
    return false;
  }

  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        imageSpinner = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune image selectionnée'),));
      }
      imageSpinner = false;
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucune image selectionnée'),));
    }
    setState(() {
      imageSpinner = false;
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  getPublicationIconButton({String heroTag, String iconPath, String title, Function action}){
    return InkWell(
      onTap: action,
      child: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(horizontal: wv*1),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Hero(tag: heroTag, child: SvgPicture.asset(iconPath, color: kDeepTeal, width: 30)),
            Text(title, style: TextStyle(color: kDeepTeal, fontSize: 10))
          ],
        ),
      ),
    );
  }
}