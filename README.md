[![publish](https://github.com/ZuYun/parallaxj/actions/workflows/publish.yml/badge.svg)](https://github.com/ZuYun/parallaxj/actions/workflows/publish.yml)  [![lib web](https://github.com/ZuYun/parallaxj/actions/workflows/libweb.yml/badge.svg)](https://github.com/ZuYun/parallaxj/actions/workflows/libweb.yml)

# what is it

[![online](https://img.shields.io/badge/online-test-green)](https://zuyun.github.io/parallaxj/#/)

https://user-images.githubusercontent.com/9412501/159013153-79af72be-30e9-4d92-b34e-7af11c772812.mp4

# how to use
[![pub](https://img.shields.io/badge/pub-v0.0.1-green)](https://pub.dev/packages/parallaxj)
```dart
Parallaxable(
    offsetRadio: 1.0 / 10,
    under: _underBackground(),
    above: _aboveBackground(),
)
```
## customization

```dart
const Parallaxable({
    Key? key,
    required this.above,
    required this.under,
    this.angle = math.pi / 9,
    this.rotateDiff = 1.1,
    this.offsetRadio = 1.0 / 6,
    this.offsetDepth = 2,
})
```
