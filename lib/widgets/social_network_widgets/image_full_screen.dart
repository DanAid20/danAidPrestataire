import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:flutter/material.dart';

class ImageFullScreen extends StatelessWidget {
  final String hero, title, imgUrl;
  const ImageFullScreen({ Key key, this.hero, this.title, this.imgUrl }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, size: 25, color: Colors.white,), onPressed: ()=>Navigator.pop(context)),
        title: Text(title, style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Hero(child: CachedNetworkImage(imageUrl: imgUrl), tag: hero,),
          ),
          SizedBox(height: hv*5,)
        ],
      ),
    );
  }
}