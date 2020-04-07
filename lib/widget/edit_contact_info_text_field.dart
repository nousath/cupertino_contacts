/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-自定义信息输入框
class EditContactInfoTextField extends StatelessWidget {
  final String name;
  final EditableItem item;
  final VoidCallback onDeletePressed;
  final TextInputType inputType;

  const EditContactInfoTextField({
    Key key,
    @required this.name,
    @required this.item,
    this.onDeletePressed,
    this.inputType = TextInputType.text,
  })  : assert(name != null),
        assert(item != null),
        assert(inputType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;
    var actionTextStyle = textTheme.actionTextStyle;
    return WidgetGroup.spacing(
      spacing: 10,
      children: [
        CupertinoButton(
          child: Icon(
            CupertinoIcons.minus_circled,
            color: CupertinoColors.systemRed,
          ),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: onDeletePressed,
        ),
        CupertinoButton(
          minSize: 44,
          borderRadius: BorderRadius.zero,
          padding: EdgeInsets.zero,
          child: WidgetGroup.spacing(
            spacing: 10,
            children: [
              Text(
                item.label,
                style: actionTextStyle.copyWith(
                  fontSize: 15,
                ),
              ),
              Icon(
                CupertinoIcons.forward,
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.secondaryLabel,
                  context,
                ),
              ),
              Container(
                width: 0.5,
                height: 32,
                color: CupertinoDynamicColor.resolve(
                  separatorColor.withOpacity(0.1),
                  context,
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        Expanded(
          child: SizedBox(
            height: 44,
            child: CupertinoTextField(
              controller: item.controller,
              keyboardType: inputType,
              style: textStyle.copyWith(
                color: themeData.primaryColor,
              ),
              placeholder: name,
              placeholderStyle: TextStyle(
                color: CupertinoDynamicColor.resolve(
                  placeholderColor,
                  context,
                ),
              ),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemBackground,
              ),
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              clearButtonMode: OverlayVisibilityMode.editing,
              scrollPadding: EdgeInsets.only(
                bottom: 54,
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
            ),
          ),
        ),
      ],
    );
  }
}
