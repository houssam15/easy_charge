import "package:flutter/material.dart";

class ServiceItem extends StatefulWidget {
  const ServiceItem({super.key,required this.index,required this.onTap});
  final int index;
  final void Function()? onTap;

  @override
  State<ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.index != null && widget.index == 0?BorderRadius.only(
        topLeft: Radius.circular(32),
        bottomLeft: Radius.circular(32),
      ):BorderRadius.only(
        topLeft: Radius.circular(0),
        bottomLeft: Radius.circular(0),
      ),
      child:Container(
        color: widget.index != null && widget.index == 0?Colors.white:null,
        child: ListTile(
          focusColor: Colors.white,
          leading: Icon(Icons.people),
          title: Text('Recharge account'),
          onTap:widget.onTap,
          selected: widget.index != null && widget.index == 0?true:false,
        ),
      ),
    );
  }
}
