# ObjCPokeMiku

[![Version](http://cocoapod-badges.herokuapp.com/v/ObjCPokeMiku/badge.png)](http://cocoadocs.org/docsets/ObjCPokeMiku)
[![Platform](http://cocoapod-badges.herokuapp.com/p/ObjCPokeMiku/badge.png)](http://cocoadocs.org/docsets/ObjCPokeMiku)

## 使い方

CocoaPodsで配布しています。`pod install`でインストールしてください。

    pod "ObjCPokeMiku"

### 初期化

```
#import <ObjCPokeMiku/PMMiku.h>
```

`<ObjCPokeMiku/PMMiku.h>`をインポートしてください。

```
PMMiku *miku;
```

`NSX-39`の操作は`PMMiku`クラスを介して行います。
`PMMiku`クラスは、操作のたびにインスタンスを作る形ではなく、アプリ起動中に一つのインスタンスを使い回すようにしてください。

```
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    miku = [[PMMiku alloc] init];
}
```

`[[PMMiku alloc] init]`を呼ぶと、自動的にオンライン状態(起動中)の`NSX-39`を見つけて、接続し操作可能な状態にします。複数の`NSX-39`が接続されているときは、最初に見つかったデバイスを使います。(将来的には別個に操作できるように拡張されるかも)


## Requirements

## Installation

ObjCPokeMiku is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "ObjCPokeMiku"

## Author

sota, 

## License

ObjCPokeMiku is available under the MIT license. See the LICENSE file for more info.

