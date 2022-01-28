import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:danaid/core/models/productModel.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel? product;
  const ProductDetails({ Key? key, this.product }) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  CarouselController carouselController = CarouselController();
  int qty = 0;
  bool buttonSpinner = false;
  
  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context);
    
    int? max = widget.product?.qty;
    
    List<Widget> images = [];
    if(widget.product!.imgGroup!.length >= 2) {
      for (int i = 0; i < widget.product!.imgGroup!.length; i++){
        Widget content = getImage(url: widget.product?.imgGroup?[i]);
        images.add(content);
      }
    }
    else {
      images.add(getImage(url: widget.product!.imgUrl!));
    }

    int? adhrPts = userProvider.getUserModel?.points;
      
    return Scaffold(
      backgroundColor: kDeepTeal,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: whiteColor),
          onPressed: ()=>Navigator.pop(context)
        ),
        title: Text(widget.product!.name!, style: TextStyle(color: whiteColor.withOpacity(0.7), fontSize: 20, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
        centerTitle: true
      ),
      body: Column(
        children: [
          Hero(
            tag: "prod",
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                scrollPhysics: BouncingScrollPhysics(),
                height: 200,
                aspectRatio: 16 / 9,
                viewportFraction: 0.6,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: images
            ),
          ),
          SizedBox(height: hv*2.5,),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2.5),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: hv*2.5,),
                    Text(widget.product!.name!.toUpperCase(), style: TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.w900)),
                    SizedBox(height: hv*1,),
                    Text(widget.product!.description!, style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: whiteColor,
            child: Column(
              children: [
                Table(
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[300]!), top: BorderSide(color: Colors.grey[300]!))
                      ),
                      children: [
                        TableCell(child: Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                          child: Text(S.of(context)!.quantit)
                        )),
                        TableCell(child: Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: (){
                                  if(qty > 1){
                                    setState(() {
                                      qty--;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.8), spreadRadius: 1.0, blurRadius: 2.0, offset: Offset(1,2))]
                                  ),
                                  child: Icon(LineIcons.minus, color: kDeepTeal,),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(qty.toString(), style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 18)),
                              SizedBox(width: 10,),
                              InkWell(
                                onTap: (){
                                  if((qty+1)*widget.product!.points! <= adhrPts!){
                                    if((qty+1) <= max!){
                                      setState(() {
                                        qty++;
                                      });
                                    }
                                    else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("La quantité de ${widget.product!.name} disponible ne dépasse pas $max..",)));
                                    }
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous n'avez pas assez de points pour en commander plus..",)));
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.8), spreadRadius: 1.0, blurRadius: 2.0, offset: Offset(1,2))]
                                  ),
                                  child: Icon(LineIcons.plus, color: kDeepTeal),
                                ),
                              ),
                            ],
                          )
                        )),
                      ]
                    ),
                    TableRow(
                      children: [
                        TableCell(child: Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                          child: Text(S.of(context)!.pointsDduire)
                        )),
                        TableCell(child: Container(
                          padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*1.5),
                          child: Text((widget.product!.points! * qty).toString() + " Pts", style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.end,)
                        )),
                      ]
                    ),
                  ],
                ),
                Center(
                  child: CustomTextButton(
                    text: S.of(context)!.commander, 
                    color: kDeepTeal,
                    isLoading: buttonSpinner,
                    enable: qty > 0,
                    action: (){
                      setState(() {
                        buttonSpinner = true;
                      });
                      try {
                        FirebaseFirestore.instance.collection("PRODUITS").doc(widget.product!.id).set({
                          "quantity" : FieldValue.increment(-qty)
                        }, SetOptions(merge: true)).then((value){
                          FirebaseFirestore.instance.collection("PRODUITS").doc(widget.product!.id).collection("COMMANDES_PRODUITS").add({
                            "userId": userProvider.getUserModel!.userId,
                            "productId": widget.product!.id,
                            "dateCreated": DateTime.now(),
                            "productName": widget.product?.name,
                            "status": 0,
                            "quantity" : qty,
                            "points": widget.product?.points
                          });
                        });
                        FirebaseFirestore.instance.collection("USERS").doc(userProvider.getUserModel!.userId).set({
                          "points" : FieldValue.increment(-(widget.product!.points! * qty))
                        }, SetOptions(merge: true));
                        userProvider.modifyPoints(-(widget.product!.points! * qty));
                        setState(() {
                          buttonSpinner = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Votre commande est en cours de traitemaent..",)));
                        Navigator.pop(context);
                      }
                      catch(e){
                        setState(() {
                          buttonSpinner = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Désolé une erreur a surgie..",)));
                      }
                      setState(() {
                        buttonSpinner = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget getImage({required String url}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: hv*1),
      decoration: BoxDecoration(
        color: whiteColor,
        image: DecorationImage(image: CachedNetworkImageProvider(url), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey[800]!.withOpacity(0.5), spreadRadius: 1.2, blurRadius: 2.5, offset: Offset(0,3))]
      ),
      child: url == "" || url == null ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LineIcons.shoppingCart, color: kDeepTeal, size: 150,),
        ],
      ) : null
    );
  }
}