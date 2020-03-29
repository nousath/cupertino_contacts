/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/presenter/cupertino_contacts_presenter.dart';
import 'package:cupertinocontacts/widget/contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/drag_dismiss_keyboard_container.dart';
import 'package:cupertinocontacts/widget/fast_index_container.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/search_bar_header_delegate.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/29.
///
/// iOS风格联系人页面
const double _kSearchBarHeight = 56.0;
const double _kNavBarPersistentHeight = 44.0;
const double _kIndexHeight = 26.0;
const double _kDividerSize = 0.3;
const double _kItemHeight = 85.0;

class CupertinoContactsPage extends StatefulWidget {
  const CupertinoContactsPage({Key key}) : super(key: key);

  @override
  _CupertinoContactsPageState createState() => _CupertinoContactsPageState();
}

class _CupertinoContactsPageState extends PresenterState<CupertinoContactsPage, CupertinoContactsPresenter> {
  _CupertinoContactsPageState() : super(CupertinoContactsPresenter());

  Widget _buildBody() {
    if (presenter.isLoading && presenter.isEmpty) {
      return Center(
        child: CupertinoActivityIndicator(
          radius: 14,
        ),
      );
    }
    return FastIndexContainer(
      indexs: presenter.indexs,
      itemKeys: presenter.contactKeys,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: presenter.onRefresh,
          ),
          if (presenter.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  '暂无联系人',
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
              ),
            )
          else
            for (int index = 0; index < presenter.count; index++)
              SliverPersistentHeader(
                key: presenter.contactKeys[index],
                delegate: ContactPersistentHeaderDelegate(
                  contactEntry: presenter.contactsMap.entries.elementAt(index),
                  dividerHeight: _kDividerSize,
                  indexHeight: _kIndexHeight,
                  itemHeight: _kItemHeight,
                ),
              ),
          SliverPadding(
            padding: MediaQuery.of(context).padding.copyWith(
                  top: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget builds(BuildContext context) {
    return CupertinoPageScaffold(
      child: DragDismissKeyboardContainer(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SupportNestedScrollView(
          pinnedHeaderSliverHeightBuilder: (context) {
            return MediaQuery.of(context).padding.top + _kNavBarPersistentHeight + _kSearchBarHeight;
          },
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CupertinoSliverNavigationBar(
                largeTitle: Text('通讯录'),
                leading: CupertinoButton(
                  child: Text('群组'),
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  onPressed: () {},
                ),
                trailing: CupertinoButton(
                  child: Text('添加'),
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  onPressed: () {},
                ),
                border: null,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SearchBarHeaderDelegate(
                  height: _kSearchBarHeight,
                  onChanged: presenter.onQuery,
                ),
              ),
            ];
          },
          body: _buildBody(),
        ),
      ),
    );
  }
}
