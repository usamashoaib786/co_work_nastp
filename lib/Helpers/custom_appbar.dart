import 'package:co_work_nastp/Helpers/app_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? txt;
  final Color? color;
  final Color? bgcolor;
  final Color? cicleColor;
  final Color? buttonColor;
  final bool? leadIcon;
  final Function()? onTap;
  final List<Widget>? action;

  const CustomAppBar(
      {super.key,
      this.txt,
      this.color,
      this.cicleColor,
      this.leadIcon,
      this.bgcolor,
      this.buttonColor,
      this.onTap,
      this.action});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(70);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: widget.bgcolor?? Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: AppText.appText("${widget.txt}",
            textColor: widget.color, fontSize: 24, fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      leading: widget.leadIcon == true
          ? GestureDetector(
              onTap: widget.onTap ??
                  () {
                    Navigator.pop(context);
                  },
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.cicleColor ?? Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Image.asset(
                    "assets/images/arrow.png",
                    height: 40,
                    color: widget.buttonColor,
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
      actions: widget.action,
    );
  }
}
