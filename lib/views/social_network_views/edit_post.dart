import 'dart:io';

import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/postModel.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:danaid/widgets/drawer.dart';
import 'package:danaid/widgets/forms/custom_text_field.dart';
import 'package:danaid/widgets/forms/defaultInputDecoration.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:danaid/widgets/loaders.dart';
import 'package:danaid/widgets/social_network_widgets/mini_components.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';

class EditPost extends StatefulWidget {

  final PostModel? post;
  final String? groupId;

  const EditPost({ Key? key, this.post, this.groupId }) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController textController = new TextEditingController();
  TextEditingController tagController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> pubAutoCompleteKey = new GlobalKey();

  String currentSymptomText = "";
  List<String> suggestions = [
    S.current.sant,
    S.current.politique,
    S.current.mdicament,
    S.current.dtente,
    S.current.jeux,
    S.current.danaid,
    S.current.soins
  ];
  List<String> tags = [];

  File? imageFileAvatar;
  String? imgUrl;
  bool imageLoading = false;
  bool buttonLoading = false;
  bool imageSpinner = false;

  bool publishLoading = false;

  int? pubType;

  initFields(){
    if(widget.post?.title != null){
      titleController.text = widget.post!.title!;
      setState((){});
    }
    if(widget.post?.text != null){
      textController.text = widget.post!.text!;
      setState((){});
    }
    if(widget.post?.imgUrl != null){
      this.imgUrl = widget.post!.imgUrl;
      setState((){});
    }
    if(widget.post?.tags != null && widget.post?.tags != []){
      for(int i = 0; i < widget.post!.tags!.length; i++){
        this.tags.add(widget.post!.tags![i]);
      }
      setState((){});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initFields();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    UserProvider userProvider = Provider.of<UserProvider>(context);
    pubType = widget.post!.postType;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, size: 25, color: Colors.grey[600],), onPressed: ()=>Navigator.pop(context)),
        centerTitle: true,
        title: Text(S.of(context).editionDuPost, style: TextStyle(color: kDeepTeal, fontSize: 17),),
        actions: [IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), onPressed: () => _scaffoldKey.currentState!.openEndDrawer())],
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
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: wv*3),
                child: Column(
                  children: [
                    
                    SizedBox(height: hv*1,),

                    imgUrl != null || imageFileAvatar != null ? Container(
                      margin: EdgeInsets.only(bottom: hv*3),
                      height: 175,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: imageFileAvatar != null ? FileImage(imageFileAvatar!) : CachedNetworkImageProvider(imgUrl!) as ImageProvider, fit: BoxFit.cover),
                        boxShadow: [BoxShadow(color: Colors.grey[700]!.withOpacity(0.7), blurRadius: 3.0, spreadRadius: 1.5, offset: Offset(0,2))]
                      ),
                    ) : Container(),

                    CustomTextField(
                      label: S.of(context).titre,
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
                      scrollPhysics: const BouncingScrollPhysics(),
                      style: TextStyle(color: kDeepTeal),
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red[300]!),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.only(top: hv*2, bottom: hv*2, left: wv*4, right: wv*4),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.transparent), 
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey[300]!),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: S.of(context).queVoulezVousDire,
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
                            Text(S.of(context).tags, style: TextStyle(fontSize: 16, color: kTextBlue),), SizedBox(width: wv*3,),
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
                    ),

                    SizedBox(height: hv*3,),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).remplacer, style: TextStyle(color: kDeepTeal, fontSize: 20)),
              SizedBox(height: hv*1,),
              Row(
                children: [
                  SizedBox(width: wv*3,),
                  !imageSpinner ? SocialNetworkMiniComponents.getPublicationIconButton(
                    heroTag: "image",
                    iconPath: 'assets/icons/Two-tone/Camera.svg',
                    title: S.of(context).photo,
                    action: (){FunctionWidgets.chooseImageProvider(context: context, gallery: getImageFromGallery, camera: getImageFromCamera);}
                  ) : Loaders().buttonLoader(kDeepTeal),
                  SocialNetworkMiniComponents.getPublicationIconButton(
                    heroTag: "document",
                    iconPath: 'assets/icons/Two-tone/Document.svg',
                    title: S.of(context).doc,
                    action: (){}
                  ),
                  SocialNetworkMiniComponents.getPublicationIconButton(
                    heroTag: "video",
                    iconPath: 'assets/icons/Bulk/Video.svg',
                    title: S.of(context).vido,
                    action: (){}
                  ),
                  SocialNetworkMiniComponents.getPublicationIconButton(
                    heroTag: "voice",
                    iconPath: 'assets/icons/Two-tone/Voice.svg',
                    title: S.of(context).audio,
                    action: (){}
                  ),
                ],
              ),
              SizedBox(height: hv*0.5,),
              CustomTextButton(
                text: S.of(context).sauvegarder,
                isLoading: publishLoading,
                color: kDeepTeal,
                action: () async {
                  setState(() {
                    publishLoading = true;
                  });
                  String? url = widget.post!.imgUrl!;
                  Map<String, dynamic> input = {
                    "lastDateModified": DateTime.now(),
                    "userAuthId": userProvider.getUserModel!.authId,
                    "user": FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel!.userId),
                    "userId": userProvider.getUserModel!.userId,
                    "userAvatar": userProvider.getUserModel!.imgUrl,
                    "userName": userProvider.getUserModel!.fullName,
                    "text": textController.text,
                    "tags": tags,
                    "imgUrl": url,
                    "title": titleController.text
                  };
                  if (imageFileAvatar != null) {
                    setState(() {
                      publishLoading = true;
                    });
                    File? file = imageFileAvatar;
                    String name = (pubType == 0) ? "question-image" : (pubType == 1) ? "discussion-image" : "crowdfunding-image";
                    String path = (pubType == 0) ? 'posts/${userProvider.getUserModel!.userId}/question/$name'+'_'+DateTime.now().millisecondsSinceEpoch.toString() : (pubType == 1) ? 'posts/${userProvider.getUserModel!.userId}/discussion/$name'+'_'+DateTime.now().millisecondsSinceEpoch.toString() : 'posts/${userProvider.getUserModel!.userId}/crowdfunding/$name'+'_'+DateTime.now().millisecondsSinceEpoch.toString();
                    Reference storageReference = FirebaseStorage.instance.ref().child(path);
                    final metadata = SettableMetadata(
                      customMetadata: {'picked-file-path': file!.path}
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name remplacée")));
                      url = await storageReference.getDownloadURL();
                      input["imgUrl"] = url;
                      print("download url: $url");
                      await publish(id: userProvider.getUserModel!.authId!, input: input);
                      setState(() {
                        publishLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).postModifi)));
                      Navigator.pop(context);
                    }).catchError((e){
                      print(e.toString());
                    });
                  } else {
                    await publish(id: userProvider.getUserModel!.authId!, input: input);
                    setState(() {
                      publishLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).postModifi)));
                    Navigator.pop(context);
                  }

                },
              ),
            ],
          )
        ],
      ),
    );
  }

  publish({required String id, required Map input}) async {
    DocumentReference normalRef = FirebaseFirestore.instance.collection("POSTS").doc(widget.post!.id);
    DocumentReference groupRef = FirebaseFirestore.instance.collection("GROUPS").doc(widget.groupId).collection("POSTS").doc(widget.post!.id);
    DocumentReference docRef = widget.groupId == null ? normalRef : groupRef;
    try {
      await docRef.set(input, SetOptions(merge: true))
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

  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        imageSpinner = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).aucuneImageSelectionne),));
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
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(S.of(context).aucuneImageSelectionne),));
    }
    setState(() {
      imageSpinner = false;
    });
  }
  
}