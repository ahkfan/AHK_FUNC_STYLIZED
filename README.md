# AHK_FUNC_STYLIZED
An autohotkey script aim to turn autohotkey into a unified function style script and extend some simple but useful function.  
Mainly based on the forum project [v2functionforv1](https://autohotkey.com/boards/viewtopic.php?f=37&t=29689)   
It provides an alternative way to use AHK command.  
Most of AHK command can by replaced by a function through it.  
A strong, safe and sane AHK is not the goal of this lib.  
Document is not completed yet.  
  
[Chinese Version](README_CN.md)

## THIS IS AN ALPHA RELEASE

USE IT AT YOUR OWN RISK

## Good At AHK ?

Please fork and pull request

### How To Use

1. Download the .zip file in release.
2. Unzip the download file and put all of .ahk file into `your_user_doucments\Autohotkey\Lib`.
3. Import moulde by call the function named by moulde(I call it moulde function)  or `#include` it.
```autohotkey
; Example import fsrand moulde
rand := fsrand()
; Call rand method
rand.rand(1, 10)
; Include way
#include <fsrand>
; Use function to return moulde inner class
rand := fsrand()
; Call method like above
```
4. Some moulde functions are designed to use directly, which is indicated in the comment of the moulde file.
5. Some mouldes must be included to use, which is indicated also.

### Struction of It

- This lib sperates ahk into several mouldes
- Every moulde is consisted of two parts:
  1. Its moulde function
  2. And its implementation classes

|Moulde Function|Implementation Class|
|:--:|:--:|
|Return class to be called|Implementation of every method|
|Only one, named by moulde|One or more, named by the rule:<br>\_\_AHKFS_CLASS_(TASK)|

- Optional Extend folder contains optional moulde
- controversial folder is for some controversial files
- GUI is not in plan for now, because in v2 GUI is already OO. 

### Other Tips

- You can refer the MouldeName+FunctionName doucment of ahk
- If you are finding other libs of AutoHotkey check [awesome-AutoHotkey](https://github.com/ahkscript/awesome-AutoHotkey)
- If you demand a strong, safe and sane AutoHotkey check [Facade](https://github.com/Shambles-Dev/AutoHotkey-Facade)
- For use GUI in OOP way, recommend [CGUI](https://github.com/evilC/CGui) or [GUICLASS](https://github.com/maestrith/GUIClass)

### Future Plan

- [ ] wiki
- [ ] work for beta
- [ ] full test