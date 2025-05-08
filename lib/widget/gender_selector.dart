import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';


enum GenderType {male ,female }

class GenderSelector extends StatefulWidget {
  final Function(GenderType) onChange;
  final String? title ;
  final GenderType? initValue;
  GenderSelector({required this.onChange, this.title, this.initValue});

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  Color maleColor = Colors.transparent;
  Color femaleColor = Colors.transparent;
  GenderType? type ;

  @override
  void initState() {
    // TODO: implement initState

    type = widget.initValue;
    if(widget.initValue == null){
      maleColor = Colors.transparent;
      femaleColor = Colors.transparent;
    }else{
      if(type == GenderType.male){
        maleColor = AppColor.blue;
      }else{
        femaleColor = AppColor.blue;
      }

    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.title != null)
          Row(
            children: [
              Text(
                widget.title!,
                style: TextStyle(
                    color: AppColor.blue,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        Container(
          height: 60,
          margin:const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius:BorderRadius.circular(4),
            border:Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      maleColor = AppColor.blue;
                      femaleColor = Colors.transparent;
                      type = GenderType.male;
                      widget.onChange(type!);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: maleColor,
                    ),
                    alignment: Alignment.center,
                    height: 60,
                    child: Text(
                      'male'.tr(),
                      style: TextStyle(
                        color: type == GenderType.male ?Colors.white :Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: AppColor.blue,
                height: double.infinity,
                width: 1,

              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      femaleColor = AppColor.blue;
                      maleColor = Colors.transparent;
                      type = GenderType.female;
                      widget.onChange(type!);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: femaleColor,
                    ),
                    alignment: Alignment.center,
                    height: 60,
                    child: Text(
                      'female'.tr(),
                      style: TextStyle(
                        color:type == GenderType.female ?Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}