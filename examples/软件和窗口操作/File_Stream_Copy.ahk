/*
    朋友的需求, 专用工具
    为资源管理器和TC拷贝时做一个GUI工具
    要求拷贝时比较Stream, 操作选取文件Stream留存方
*/


#singleinstance force
#include dbg.ahk



obj_trans_key_var(obj) {
      retObj := {}
      for key, var in obj
            retObj[var] := key
      return retObj
}

main:
      ;inipath=D:\Apps\OS\TotalCMD64\Plugins\Wdx\NTFS_diz\NTFS_diz.ini
      ;iniread, s, % inipath, Streams
      iniLs := obj_trans_key_var(["Tags",  "Type", "Score", "Review", "Year"])

      ;getIniLs(s) ;~ (数字 : stream标签名)
return

esc & f1::
       ;--------------------------------------------------
      ;~ 复制到该处文件夹路径
      toDir := getAWindowAddr()
      if (toDir.type = "explorer") {
            ;msgbox, % "当前取得资源管理的路径: `n" . (toDir.dir)
            desDir := toDir.dir
      } else if (toDir.type = "TC")  {
            ;msgbox, % "当前取得TC的路径: `n左侧路径为:" . (toDir.dirLeft) "`n右侧路径为" (toDir.dirRight)
            desDir := toDir.dirRight
      } else {
            msgbox, 当前激活的窗口不是"TC" 或 "Explorer"
            return
      }
      if not instr(fileexist(desDir), "d") {
            msgbox, 目标路径不合法 :`n%desDir%
            return
      }

      ;--------------------------------------------------
      spDict := getClipPathDict()    ;~ file path in clipboard {文件名 : 完整路径}


       ;--------------------------------------------------
       ;~ iniLs (数字 : stream标签名)

      for srcName, srcPath in spDict
      {
          if not fileexist(srcPath) {
                msgbox, 剪切板中似乎存在不合法的文件名`n（%srcPath%）`n此文件将跳过
                continue
          }

          splitpath, srcPath, , srcDir
          if (srcDir = desDir) {
                msgbox, 剪切板源路径与目标路径一致`n此文件跳过
                continue
          }
          desPath := desDir "\" srcName

          srcStream := {}
          desStream := {}
          
          for tagName in iniLs {
                
                s:= stream.read(srcPath, tagName)

                if (s <> "")
                    srcStream[tagName] := s
                    
                if fileexist(desPath) {
                      s:= stream.read(desPath, tagName)
                      if (s <> "")
                          desStream[tagName] := s
                 }
           }

          ;msgbox, % "---1" obj_dbg2(srcStream) "`n`n---2" obj_dbg2(desStream) "---"
          
          mod := GUIBT.get(    srcPath
                                         , srcStream.count() ? obj_dbg2(srcStream) : ""
                                         , desPath
                                         , desStream.count() ? obj_dbg2(desStream) : "")

        ;msgbox, % "当前选择："  GUIBT.whickCheck


        ;this.check := {OnlySrc : OnlySrc, OnlyDes: OnlyDes, JoinEach: JoinEach}

            finalStream := ""
          if (mod = "copy") {
            ;msgbox, 只拷贝

            finalStream := getFinalStream(desPath, srcStream, desStream)
            FileCopy, % srcPath, % desPath, 1
            stream.coverObj(desPath, finalStream)

          } else if (mod = "cut") {

            ;msgbox, 只剪切
            finalStream := getFinalStream(desPath, srcStream, desStream)
            FileMove, % srcPath, % desPath, 1
            stream.coverObj(desPath, finalStream)

          } else {

                tooltip, 此文件跳过
                settimer, ttHide, -1000
          }
      }
return

ttHide:
      tooltip
return

getFinalStream(desPath, srcStream, desStream) {
     finalStream := srcStream
     ;msgbox, % "---1" obj_dbg2(srcStream) "`n`n---2" obj_dbg2(finalStream) 
     if FileExist(desPath) {

        chek := GUIBT.whickCheck
        
        if (chek = "OnlyDes") {

            finalStream := desStream

        } else if (chek = "JoinEach") {

            key := "", var := ""
            
            for key, var in desStream
            {
                if not finalStream.HasKey(key)
                    finalStream[key] := var
                else 
                    if (finalStream[key] <> var) 
                          finalStream[key] := finalStream[key] . var

            }

        }
    }
    return finalStream
}



class stream {
    /* 用于读写stream

    */

    read(path, sm) {            ;~ 读取
        local s
        FileRead, s, % path ":" sm

        return s
    }

    append(path, sm, sAppend) { ;~ 追加
        FileAppend, % sAppend, % path ":" sm
        return
    }

    cover(path, sm, sWrite) {   ;~ 覆盖写入
        f := FileOpen(path ":" sm, "w")
        f.write(sWrite)
        f.close()
        f := ""
    }

    coverObj(path, objWrite) {
        for sm, sWrite in objWrite
        {
            f := FileOpen(path ":" sm, "w")
            f.write(sWrite)
            f.close()
            f := ""
        }
    }

    del(path, sm) {             ;~ 删除
        FileDelete, % path ":" sm
    }


    blank(path, sm) {           ;~ 设置该stream 为空字符串
        this.cover(path, sm, "")
    }
}


/*
f1::
spDict := getClipPathDict()    ;~ {文件名 : 完整路径}
for key, v in spDict
        print(key "       "  v)
RETURN
*/


;~ 取得剪切板的{文件 : 完整路径}的字典
getClipPathDict() {

      spDict := {}    ;~ {文件名 : 完整路径}
      a := clipboard
      a := regexreplace(a, "`r", "")
      loop, parse, a, % "`n"
      {
          splitpath, A_LoopField, fileName
          spDict[fileName] := A_LoopField
      }
      return spDict
}
/*
;-------------------------------------------
;~ 解析ini文件
getIniLs(s) {
      ls := []
      loop, parse, s, % "`n"
      {
            if not (A_LoopField ~= "^\s*$") {
              regexmatch(A_LoopField, "^([^\=]+)\=([^\=]+)$", ret)
              ls[ret1] := ret2
            }
      }
      return ls
}
*/

;~ 当前窗口判断
getAWindowAddr() {
        WinGetClass, AClsName, A

        if (AClsName = "TTOTAL_CMD") {

              ;~ 取得当前激活TC的窗口路径
              Controlgettext, dirLeft, window14, ahk_class TTOTAL_CMD
              Controlgettext, dirRight, window19, ahk_class TTOTAL_CMD
              dirLeft := substr(dirLeft, 1, -3)
              dirRight := substr(dirRight, 1, -3)

              return {"type": "TC", "dirLeft": dirLeft, "dirRight": dirRight}

        } else if (AClsName = "CabinetWClass") {

              ;~ 取得当前激活资源管理器当前路径
              ControlgetText, dirExplore, ToolbarWindow323, ahk_class CabinetWClass
              dirExplore := substr(dirExplore, 5)
              return {"type": "explorer", "dir": dirExplore}
        }
}

class GUIBT {
  static _ := GUIBT.addButton()
  static ret := ""
  addButton() {
      gui, theMsgUI:+toolwindow
      gui, theMsgUI:add, text, , 源路径 :
      gui, theMsgUI:add, edit, readonly w200 h20 hwndSRC
      gui, theMsgUI:add, edit, readonly w200 h70 hwndSRC_STREAM Wrap,
      gui, theMsgUI:add, text, , 目标路径 :
      gui, theMsgUI:add, edit, readonly w200 h20 hwndDES
      gui, theMsgUI:add, edit, readonly w200 h70 hwndDES_STREAM Wrap,

      gui, theMsgUI:add, Radio,  gGUIBT.radioEvent hwndOnlySrc, 保留拷贝源的Stream
      gui, theMsgUI:add, Radio,  gGUIBT.radioEvent hwndOnlyDes, 保留目标文件Stream
      gui, theMsgUI:add, Radio,  gGUIBT.radioEvent hwndJoinEach checked , 合并两侧Stream

      this.check := {OnlySrc : OnlySrc, OnlyDes: OnlyDes, JoinEach: JoinEach}

      gui, theMsgUI:add, button, gGUIBT.eventCopy w200 h35, 复 制
      gui, theMsgUI:add, button,  gGUIBT.eventCut w200 h35, 剪 切
      this.hwndSRC := SRC
      this.hwndDES := DES
      this.hwndSRC_S := SRC_STREAM
      this.hwndDES_S := DES_STREAM

      GUIBT.radioEvent()

  }
  eventCopy() {
        GUIBT.ret := "copy"
        GUIBT.radioEvent()
        gui, theMsgUI:hide
  }
  eventCut() {
        GUIBT.ret := "cut"
        GUIBT.radioEvent()
        gui, theMsgUI:hide
  }
  radioEvent() {
       for key, ctrlHwnd in GUIBT.check
      {
          guicontrolget, whichCheck, , % ctrlHwnd

          if (whichCheck)
                this.whickCheck := key
      }
  }

  get(srcPath, srcStream,desPath, destStream) {

      guicontrol, , % GUIBT.hwndSRC, % srcPath
      guicontrol, , % GUIBT.hwndSRC_S, % srcStream

      guicontrol, , % GUIBT.hwndDES, % desPath
      guicontrol, , % GUIBT.hwndDES_S, % destStream


      gui, theMsgUI:show, , theMsgUI
      sleep 200
      loop {
      } until (not winexist("theMsgUI"))
      GUIBT.radioEvent()
      return this.ret
  }
}
theMsgUIGuiClose() {
    GUIBT.ret :=""
   gui, theMsgUI:hide
}

obj_dbg1(obj) {
    ret := ""
    if IsObject(obj) {
        ret .= "{"
        for key, var in obj
            ret .= key . " :" . obj_dbg1(var) . ", "
        if (key <> "")
            ret := SubStr(ret, 1, -2)
        ret .= "}"
    } else {
        if obj is number
            ret := obj
        else if (obj = "")
            ret = ""
        else
            ret := """" obj """"
    }
    return ret
}

;---------------------------------------------------------------------
;~ 将对象转换为可读字符串
obj_dbg2(obj) {
    ret := ""
    for key, var in obj
        ret .= key "=" obj_dbg1(var) "`n"
    if (key <> "")
        ret := SubStr(ret, 1, -1)
    return ret
}