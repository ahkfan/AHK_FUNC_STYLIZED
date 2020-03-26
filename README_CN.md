# AHK_FUNC_STYLIZED
本项目是个美味的简单小项目  
食用本项目你就可以用比较OOP的方式使用AHK了，而且本项目也致力于提供一些在AHK使用中直击痛点的小函数，让你在AHK使用中感觉到一些甜点的美味  
主要基于论坛的 [v2functionforv1](https://autohotkey.com/boards/viewtopic.php?f=37&t=29689)   
现在，你要是想OOP的调用大部分的函数已经没问题了  
因为是个简单的项目什么优雅啊，强壮啊等等一概与本库没关系。又不是不能用.jpg  
文档在写了（咕咕咕
  
[English Version](README.md)

## 现在还是alpha版

**请自己为自己的使用负责哦**

## 感觉自己还擅长AHK？

那赶紧快为本库多提点pull requests吧

### 如何食用

1. 下载release版
2. 解压并把所有`lib`下的`.ahk`文件放进 `your_user_doucments\Autohotkey\Lib`.
3. 通过调用和模块文件同名的函数就可以引入模块（这些函数也叫做模块函数），或者你愿意的话`#include` 也行
```autohotkey
; 引入模块
rand := fsrand()
; 调用方法
rand.rand(1, 10)
; Include 的方式
#include <fsrand>
; 用模块函数返回实现类
rand := fsrand()
; 和上面一样调用即可
```
4. 有些模块函数是设计成用来直接调用的，如果是这样，模块文件的注释会直接注明的
5. 还有些模块是必须显式的用`#include`引入，这样也会注明的

### 模块的组成
- 本项目将AHK的功能分成了一系列的模块
- 每个模块都是由两个部分组成:
  1. 模块函数
  2. 和实现类

|模块函数|实现类|
|:--:|:--:|
|返回实现类|每个实现方法都在里面|
|只有一个，就是模块的名字|可以有几个，由这样的规则命名:<br>\_\_AHKFS_CLASS_它的任务|

- Optional Extend 文件夹里是可选的函数，要不是太甜了，就是比较复杂
- controversial 文件夹是争议模块，还在设计中
- GUI 还不会做，因为毕竟v2里就是OOP的了，不要再造轮子啦啊啊！ 

### 小贴士

- 需要的参考的话可以找找AHK对应的文档大体是一样的
- 推荐去找AHK库的地方 [awesome-AutoHotkey](https://github.com/ahkscript/awesome-AutoHotkey)
- 要是要求高的话，搞基的安全一致化AHK的库 [Facade](https://github.com/Shambles-Dev/AutoHotkey-Facade)
- 我不管，我就要OOP GUI，那么 [CGUI](https://github.com/evilC/CGui)， [GUICLASS](https://github.com/maestrith/GUIClass)挑一个吧

### 未来计划

- [ ] wiki
- [ ] work for beta
- [ ] full test