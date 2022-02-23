import 'package:cached_network_image/cached_network_image.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

class SocialNetworkMiniComponents {
  static Widget getPublicationIconButton({String? heroTag, String? iconPath, String? title, Function()? action}){
    return InkWell(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(horizontal: wv*1),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Hero(tag: heroTag!, child: SvgPicture.asset(iconPath!, color: kDeepTeal, width: 30)),
            Text(title!, style: TextStyle(color: kDeepTeal, fontSize: 10))
          ],
        ),
      ),
    );
  }

  static Widget getProfileAvatar({String? avatarUrl, int size = 12}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wv*0.5),
      width: wv*size,
      height: wv*size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        image: avatarUrl != null ? DecorationImage(image: CachedNetworkImageProvider(avatarUrl), fit: BoxFit.cover) : null,
        boxShadow: [BoxShadow(color: Colors.grey[800]!, blurRadius: 2.5, spreadRadius: 1, offset: Offset(0, 2))],
      ),
      child: avatarUrl == null ? Icon(LineIcons.user, size: 30,) : Container(),
    );
  }
}