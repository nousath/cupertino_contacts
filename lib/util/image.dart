/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image;

class ImageFilterSrc {
  final Uint8List image;
  final List<double> matrix;

  ImageFilterSrc({
    @required this.image,
    @required this.matrix,
  })  : assert(image != null),
        assert(matrix != null && matrix.length == 20);
}

Future<Uint8List> _colorMatrixFilter(ImageFilterSrc params) {
  return compute(_colorMatrixFilterAsSync, params);
}

Uint8List _colorMatrixFilterAsSync(ImageFilterSrc params) {
  var src = image.decodeImage(params.image);
  var matrix = params.matrix;

  var tmp = image.Image.from(src);

  for (var y = 0; y < src.height; ++y) {
    for (var x = 0; x < src.width; ++x) {
      var c = tmp.getPixel(x, y);
      var red = image.getRed(c);
      var green = image.getGreen(c);
      var blue = image.getBlue(c);
      var alpha = image.getAlpha(c);

      var oldColors = [red, green, blue, alpha, 1.0];
      var newColors = Float64List(4);

      for (var col = 0; col < 5; ++col) {
        for (var row = 0; row < 4; ++row) {
          newColors[row] += oldColors[col] * matrix[col + row * 5];
        }
      }

      num r = newColors[0];
      num g = newColors[1];
      num b = newColors[2];
      num a = newColors[3];

      r = (r > 255.0) ? 255.0 : ((r < 0.0) ? 0.0 : r);
      g = (g > 255.0) ? 255.0 : ((g < 0.0) ? 0.0 : g);
      b = (b > 255.0) ? 255.0 : ((b < 0.0) ? 0.0 : b);
      a = (a > 255.0) ? 255.0 : ((a < 0.0) ? 0.0 : a);

      src.setPixel(x, y, image.getColor(r.toInt(), g.toInt(), b.toInt(), a.toInt()));
    }
  }

  return image.encodePng(src);
}

class ImageFilters {
  static Future<Uint8List> colorMatrixFilter(ImageFilterSrc src) {
    return _colorMatrixFilter(src);
  }
}
