/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/widget/image_crop.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as image;
import 'dart:ui' as ui;

/// Created by box on 2020/4/2.
///
/// 截图
class CropImagePage extends StatefulWidget {
  final Uint8List bytes;

  const CropImagePage({
    Key key,
    @required this.bytes,
  })  : assert(bytes != null),
        super(key: key);

  @override
  _CropImagePageState createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final _cropKey = GlobalKey<ImageCropState>();
  ImageStream _imageStream;
  ui.Image _image;
  ImageStreamListener _imageListener;
  ImageProvider _memoryImage;

  @override
  void initState() {
    _memoryImage = MemoryImage(widget.bytes);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getImage();
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageListener);
    super.dispose();
  }

  void _getImage({bool force: false}) {
    final oldImageStream = _imageStream;
    _imageStream = _memoryImage.resolve(createLocalImageConfiguration(context));
    if (_imageStream.key != oldImageStream?.key || force) {
      oldImageStream?.removeListener(_imageListener);
      _imageListener = ImageStreamListener(_updateImage);
      _imageStream.addListener(_imageListener);
    }
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    _image = imageInfo.image;
  }

  _onCropPressed() {
    var currentState = _cropKey.currentState;
    if (_image == null || currentState == null) {
      return;
    }
    var srcWidth = _image.width;
    var srcHeight = _image.height;

    var area = currentState.area;
    var scale = currentState.scale;

    var scaleRect = Rect.fromLTWH(
      0,
      0,
      srcWidth / scale,
      srcHeight / scale,
    );
    var cropRect = Rect.fromLTRB(
      scaleRect.width * area.left,
      scaleRect.height * area.top,
      scaleRect.width * area.right,
      scaleRect.height * area.bottom,
    );

    var resizeImage = image.copyResize(
      image.decodeImage(widget.bytes),
      width: scaleRect.width.floor(),
      height: scaleRect.height.floor(),
    );
    var copyCropImage = image.copyCrop(
      resizeImage,
      cropRect.left.floor(),
      cropRect.top.floor(),
      cropRect.width.floor(),
      cropRect.height.floor(),
    );
    Navigator.pop(context, image.encodePng(copyCropImage));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            ImageCrop(
              key: _cropKey,
              image: _memoryImage,
              chipShape: BoxShape.circle,
            ),
            Positioned(
              top: 20,
              child: SafeArea(
                child: Text(
                  '移动和缩放',
                  style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: SafeArea(
                child: WidgetGroup.spacing(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 17,
                          color: CupertinoColors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                    ),
                    CupertinoButton(
                      child: Text(
                        '选取',
                        style: TextStyle(
                          fontSize: 17,
                          color: CupertinoColors.white,
                        ),
                      ),
                      onPressed: _onCropPressed,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}