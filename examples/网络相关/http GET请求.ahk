#SingleInstance force
#z::
http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
url := "https://www.printf520.com:8080/GetTypeInfo?id=2"
;~ MsgBox % url . CustomFunction_SkSub_UrlEncode("?Refer=top_hot&topnav=1&wvr=6")
;~ Clipboard := url . CustomFunction_SkSub_UrlEncode("?Refer=top_hot&topnav=1&wvr=6")
http.Open("GET",url,false)
;~ HTTP.SetRequestHeader("accept","text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3")
;~ HTTP.SetRequestHeader("Accept-Encoding", "gzip, deflate, br") ;sdch is Google Shared Dictionary Compression for HTTP
;~ HTTP.SetRequestHeader("Accept-Language","zh-CN,zh;q=0.9,en;q=0.8")
;~ HTTP.SetRequestHeader("Upgrade-Insecure-Requests","1")
;~ HTTP.SetRequestHeader("Connection","keep-alive")
;~ HTTP.SetRequestHeader("Pragma","no-cache")
;~ HTTP.SetRequestHeader("Cache-Control","no-cache")

HTTP.SetRequestHeader("User-Agent","Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36")
;~ HTTP.SetRequestHeader("Cookie", "SINAGLOBAL=504924381010.5453.1561288298524; UOR=,,www.google.com; SCF=AgMkx6GftNFDqsQxFbzaIwxfxAciqqSb4K78ux3xM-AT7AGckFlyjtzTPpKu6bSIZDZ0bmxLW6Okbkma1uz_IaE.; SUHB=0TPUK2-agh51zF; SUB=_2AkMqA1aGf8NxqwJRmPAcy23hbYR3zQnEieKcX6ddJRMxHRl-yT83qlYstRB6AYN4aMTjL-XSHHmlFePfFzWcdv-zSLM7; SUBP=0033WrSXqPxfM72-Ws9jqgMF55529P9D9WFh.hkbhp3SqQwB1Uz-8XK0; _ga=GA1.2.1260882448.1566562943; _gid=GA1.2.45349867.1566562943; __gads=ID=8df8f6fd9b86f266:T=1566562953:S=ALNI_MY57axoTiAMfSzIqMpHqvzwNu8PcQ; _s_tentry=-; Apache=2790985602874.132.1566611949454; ULV=1566611949544:6:3:2:2790985602874.132.1566611949454:1566562734020; WBStorage=f54cf4e4362237da|undefined")
http.Send()
	errorcode := A_LastError
	if (errorcode != 0)
	{
			traytip,,网络连接失败，请再试一次。
			return
	}
html := http.Responsetext
MsgBox % html ;Text,Clear=1,LineBreak=1,Exit=0

return

CustomFunction_SkSub_UrlEncode(str, enc="UTF-8")
{
    enc:=trim(enc)
    If enc=
        Return str
   hex := "00", func := "msvcrt\" . (A_IsUnicode ? "swprintf" : "sprintf")
   VarSetCapacity(buff, size:=StrPut(str, enc)), StrPut(str, &buff, enc)
   While (code := NumGet(buff, A_Index - 1, "UChar")) && DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", code, "Cdecl")
   encoded .= hex
   Return encoded
}

UriDecode(Uri, Enc = "UTF-8")   ;将网址编码转换为encode编码
{
   Pos := 1
   Loop
   {
      Pos := RegExMatch(Uri, "i)(?:%[\da-f]{2})+", Code, Pos++)
      If (Pos = 0)
         Break
      VarSetCapacity(Var, StrLen(Code) // 3, 0)
      StringTrimLeft, Code, Code, 1
      Loop, Parse, Code, `%
         NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
      StringReplace, Uri, Uri, `%%Code%, % StrGet(&Var, Enc), All
   }
   Return, Uri
}
~lbutton & r::
reload
return
~lbutton & e::
edit
return
~lbutton & x::
exitapp
return