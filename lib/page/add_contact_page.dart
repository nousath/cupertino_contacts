/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/add_contact_choose_ring_tone_button.dart';
import 'package:cupertinocontacts/widget/add_contact_group_container.dart';
import 'package:cupertinocontacts/widget/add_contact_info_group.dart';
import 'package:cupertinocontacts/widget/add_contact_normal_text_field.dart';
import 'package:cupertinocontacts/widget/add_contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/add_contact_remarks_text_field.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Created by box on 2020/3/30.
///
/// 添加联系人
class AddContactPage extends StatefulWidget {
  const AddContactPage({Key key}) : super(key: key);

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('新建联系人'),
        backgroundColor: CupertinoColors.tertiarySystemBackground,
        border: null,
        leading: NavigationBarAction(
          child: Text('取消'),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        trailing: NavigationBarAction(
          child: Text('完成'),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return 64.0;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: AddContactPersistentHeaderDelegate(),
            ),
          ];
        },
        body: Scrollbar(
          child: ListView(
            children: <Widget>[
              AddContactGroupContainer(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return AddContactNormalTextField();
                },
              ),
              SizedBox(
                height: 40,
              ),
              AddContactInfoGroup(
                itemCount: 2,
                buttonText: '添加电话',
              ),
              SizedBox(
                height: 40,
              ),
              AddContactInfoGroup(
                itemCount: 2,
                buttonText: '添加电子邮件',
              ),
              SizedBox(
                height: 40,
              ),
              AddContactChooseRingToneButton(),
              SizedBox(
                height: 40,
              ),
              AddContactChooseRingToneButton(),
              SizedBox(
                height: 40,
              ),
              AddContactInfoGroup(
                itemCount: 2,
                buttonText: '添加URL',
              ),
              SizedBox(
                height: 40,
              ),
              AddContactInfoGroup(
                itemCount: 2,
                buttonText: '添加地址',
              ),
              SizedBox(
                height: 40,
              ),
              AddContactInfoGroup(
                itemCount: 2,
                buttonText: '添加生日',
              ),
              SizedBox(
                height: 40,
              ),
              AddContactInfoGroup(
                itemCount: 2,
                buttonText: '添加日期',
              ),
              SizedBox(
                height: 40,
              ),
              AddContactInfoGroup(
                itemCount: 2,
                buttonText: '添加关联人',
              ),
              SizedBox(
                height: 40,
              ),
              AddContactInfoGroup(
                itemCount: 2,
                buttonText: '添加个人社交资料',
              ),
              SizedBox(
                height: 40,
              ),
              AddContactInfoGroup(
                itemCount: 2,
                buttonText: '添加即时信息',
              ),
              SizedBox(
                height: 40,
              ),
              AddContactRemarksTextField(),
              SizedBox(
                height: 40,
              ),
              CupertinoButton(
                minSize: 44,
                padding: EdgeInsets.only(
                  left: 16,
                  right: 10,
                ),
                borderRadius: BorderRadius.zero,
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.tertiarySystemBackground,
                  context,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '添加信息栏',
                    style: CupertinoTheme.of(context).textTheme.actionTextStyle.copyWith(
                          fontSize: 15,
                        ),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
