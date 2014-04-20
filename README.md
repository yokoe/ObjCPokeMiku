# ObjCPokeMiku

[![Version](http://cocoapod-badges.herokuapp.com/v/ObjCPokeMiku/badge.png)](http://cocoadocs.org/docsets/ObjCPokeMiku)
[![Platform](http://cocoapod-badges.herokuapp.com/p/ObjCPokeMiku/badge.png)](http://cocoadocs.org/docsets/ObjCPokeMiku)

## 使い方

CocoaPodsで配布しています。`pod install`でインストールしてください。

    pod "ObjCPokeMiku"

### Initialization

```
#import <objc-pokemiku/PMMiku.h>

PMMiku *miku;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    miku = [[PMMiku alloc] init];
}
```

Create an instance of PMMiku class first.

## Requirements

## Installation

ObjCPokeMiku is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "ObjCPokeMiku"

## Author

sota, 

## License

ObjCPokeMiku is available under the MIT license. See the LICENSE file for more info.

