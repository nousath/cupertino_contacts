/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/presenter/contact_detail_presenter.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/util/native_service.dart';
import 'package:cupertinocontacts/widget/contact_detail_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/emergency_contact_dialog.dart';
import 'package:cupertinocontacts/widget/error_tips.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/multi_line_text_field.dart';
import 'package:cupertinocontacts/widget/send_message_dialog.dart';
import 'package:cupertinocontacts/widget/share_location_dialog.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/toolbar.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

/// Created by box on 2020/3/30.
///
/// 联系人详情
const double _kMaxAvatarSize = 80;
const double _kMinAvatarSize = 44;
const double _kMaxNameSize = 26;
const double _kMinNameSize = 15;

class ContactDetailPage extends StatefulWidget {
  final String identifier;
  final Contact contact;
  final HomeLaunchMode launchMode;

  const ContactDetailPage({
    Key key,
    @required this.identifier,
    this.contact,
    this.launchMode = HomeLaunchMode.normal,
  })  : assert(identifier != null),
        assert(launchMode != null),
        super(key: key);

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends PresenterState<ContactDetailPage, ContactDetailPresenter> {
  _ContactDetailPageState() : super(ContactDetailPresenter());

  String get _routeTitle {
    var route = ModalRoute.of(context);
    String title;
    if (route is CupertinoPageRoute) {
      title = route.title;
    }
    return title;
  }

  @override
  Widget builds(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var actionTextStyle = textTheme.actionTextStyle;
    var contact = presenter.object;

    if (contact == null) {
      return ErrorTips();
    }

    var phones = contact.phones;
    var emails = contact.emails;
    var urls = contact.urls;
    var postalAddresses = contact.postalAddresses;
    var dates = contact.dates;
    var socialProfiles = contact.socialProfiles;

    final hasPhone = phones != null && phones.isNotEmpty;

    final children = List<Widget>();
    if (hasPhone) {
      children.addAll(phones.where((element) {
        return selections.contains(element.label);
      }).map((e) {
        return _NormalGroupInfoWidget(
          name: selections[e.label].labelName,
          value: e.value,
          valueColor: actionTextStyle.color,
          onPressed: () {
            NativeService.call(e.value);
          },
        );
      }));
    }
    if (emails != null && emails.isNotEmpty) {
      children.addAll(emails.where((element) {
        return selections.contains(element.label);
      }).map((e) {
        return _NormalGroupInfoWidget(
          name: selections[e.label].labelName,
          value: e.value,
          valueColor: actionTextStyle.color,
          onPressed: () {
            NativeService.email(e.value);
          },
        );
      }));
    }
    if (urls != null && urls.isNotEmpty) {
      children.addAll(urls.where((element) {
        return selections.contains(element.label);
      }).map((e) {
        var url = e.value;
        url = url.startsWith('http') ? url : 'http://$url';
        return _NormalGroupInfoWidget(
          name: selections[e.label].labelName,
          value: url,
          valueColor: actionTextStyle.color,
          onPressed: () {
            NativeService.url(url);
          },
        );
      }));
    }
    if (postalAddresses != null && postalAddresses.isNotEmpty) {
      children.addAll(postalAddresses.where((element) {
        return selections.contains(element.label);
      }).map((e) {
        final value = [
          e.street,
          e.region,
          e.city,
          e.postcode,
          e.country,
        ].where((element) => element != null && element.isNotEmpty).join(' ');
        return _NormalGroupInfoWidget(
          name: selections[e.label].labelName,
          value: value,
          trailing: Container(
            width: 80,
            height: 80,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.tertiarySystemGroupedBackground,
              context,
            ),
            alignment: Alignment.center,
            child: Text(
              '地图',
              style: textTheme.textStyle.copyWith(
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.secondaryLabel,
                  context,
                ),
              ),
            ),
          ),
          onPressed: () {
            NativeService.maps(value);
          },
        );
      }));
    }
    if (dates != null && dates.isNotEmpty) {
      children.addAll(dates.where((element) {
        return selections.contains(element.label);
      }).map((e) {
        var dateTime = e.date.toDateTime();
        return _NormalGroupInfoWidget(
          name: selections[e.label].labelName,
          value: DateFormat('yyyy年MM月dd日').format(e.date.toDateTime()),
          valueColor: actionTextStyle.color,
          onPressed: () {
            var currentYear = DateTime.now().year;
            var currentYearBirthday = DateTime(currentYear, dateTime.month, dateTime.day);
            NativeService.calendar(currentYearBirthday);
          },
        );
      }));
    }
    if (socialProfiles != null && socialProfiles.isNotEmpty) {
      children.addAll(socialProfiles.where((element) {
        return selections.contains(element.label);
      }).map((e) {
        return _NormalGroupInfoWidget(
          name: selections[e.label].labelName,
          value: e.value,
          valueColor: actionTextStyle.color,
          onPressed: () {
            switch (e.label.toLowerCase()) {
              case 'twitter':
                NativeService.url('https://www.twitter.com');
                break;
              case 'facebook':
                NativeService.url('https://www.facebook.com');
                break;
              case 'flickr':
                NativeService.url('https://www.flickr.com');
                break;
              case '领英':
                NativeService.url('https://www.linkedin.com');
                break;
              case 'myspace':
                NativeService.url('https://www.myspace.com');
                break;
              case '新浪微博':
                NativeService.url('https://www.sina.com');
                break;
            }
          },
        );
      }));
    }
    children.add(MultiLineTextField(
      controller: presenter.remarksController,
      name: '备注',
      minLines: 2,
      backgroundColor: CupertinoColors.secondarySystemGroupedBackground,
    ));
    final isNormalMode = widget.launchMode == HomeLaunchMode.normal;
    if (isNormalMode) {
      if (hasPhone) {
        children.add(_NormalButton(
          text: '发送信息',
          onPressed: () {
            showSendMessageDialog(context, phones, emails);
          },
        ));
      }
      children.add(_NormalButton(
        text: '共享联系人',
        onPressed: () {
          Share.share(
            contact.displayName,
            subject: contact.displayName,
          );
        },
      ));
      if (hasPhone) {
        children.add(_NormalButton(
          text: '添加到个人收藏',
          onPressed: () {},
        ));
        children.add(_NormalButton(
          text: '添加到紧急联系人',
          isDestructive: true,
          onPressed: () {
            showAddEmergencyContactDialog(context, phones);
          },
        ));
        children.add(_NormalButton(
          text: '共享我的位置',
          onPressed: () {
            showShareLocationDialog(context);
          },
        ));
      }
    }

    var persistentHeaderDelegate = ContactDetailPersistentHeaderDelegate(
      contact: contact,
      maxAvatarSize: _kMaxAvatarSize,
      minAvatarSize: _kMinAvatarSize,
      maxNameSize: _kMaxNameSize,
      minNameSize: _kMinNameSize,
      paddingTop: MediaQuery.of(context).padding.top,
      launchMode: widget.launchMode,
      routeTitle: _routeTitle,
    );

    var borderSide = BorderSide(
      color: CupertinoDynamicColor.resolve(
        separatorColor,
        context,
      ),
      width: 0.0,
    );

    return CupertinoPageScaffold(
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return persistentHeaderDelegate.minExtent;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: persistentHeaderDelegate,
            ),
          ];
        },
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: CupertinoScrollbar(
            child: ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: children.length,
              itemBuilder: (context, index) {
                var length = children.length;
                var isLast = index == length - 1;
                return Container(
                  foregroundDecoration: BoxDecoration(
                    border: Border(
                      top: isLast && hasPhone && isNormalMode ? borderSide : BorderSide.none,
                      bottom: isLast || (index == length - 2 && hasPhone && isNormalMode) ? borderSide : BorderSide.none,
                    ),
                  ),
                  child: children[index],
                );
              },
              separatorBuilder: (context, index) {
                if (index == children.length - 2 && hasPhone && isNormalMode) {
                  return SizedBox(
                    height: 40,
                  );
                }
                return Container(
                  width: double.infinity,
                  color: CupertinoDynamicColor.resolve(
                    CupertinoColors.secondarySystemGroupedBackground,
                    context,
                  ),
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  child: CupertinoDivider(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NormalGroupInfoWidget extends StatelessWidget {
  final String name;
  final String value;
  final Color valueColor;
  final Widget trailing;
  final VoidCallback onPressed;

  const _NormalGroupInfoWidget({
    Key key,
    @required this.name,
    @required this.value,
    this.valueColor,
    this.trailing,
    this.onPressed,
  })  : assert(name != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = CupertinoTheme.of(context).textTheme.textStyle;
    return Toolbar(
      value: TextEditingValue(
        text: value,
        selection: TextSelection(
          baseOffset: 0,
          extentOffset: value.length,
        ),
      ),
      options: ToolbarOptions(
        copy: true,
      ),
      builder: (context) {
        return CupertinoButton(
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.secondarySystemGroupedBackground,
            context,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: onPressed,
          child: WidgetGroup.spacing(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 80,
            children: <Widget>[
              Expanded(
                child: WidgetGroup.spacing(
                  alignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  direction: Axis.vertical,
                  children: [
                    Text(
                      name,
                      style: textStyle.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      value ?? '暂无',
                      style: textStyle.copyWith(
                        color: valueColor ?? textStyle.color,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        );
      },
    );
  }
}

class _NormalButton extends StatelessWidget {
  final String text;
  final bool isDestructive;
  final VoidCallback onPressed;

  const _NormalButton({
    Key key,
    @required this.text,
    this.isDestructive = false,
    this.onPressed,
  })  : assert(text != null),
        assert(isDestructive != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var actionTextStyle = textTheme.actionTextStyle;
    if (isDestructive) {
      actionTextStyle = actionTextStyle.copyWith(
        color: CupertinoColors.destructiveRed,
      );
    }
    return CupertinoButton(
      minSize: 44,
      padding: EdgeInsets.only(
        left: 16,
        right: 10,
      ),
      borderRadius: BorderRadius.zero,
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: actionTextStyle,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
