/*
*****************说明*****************
此函数与内置命令 UrlDownloadToFile 的区别有以下几点
1.直接下载到变量，没有临时文件
2.下载速度更快，大概100%
3.支持超时，不必死等
4.内置命令执行时，整个AHK程序都是卡顿状态。此函数不会
5.内置命令下载一些诡异网站（例如“牛杂网”）时，会概率性让进程或线程彻底死掉。此函数不会
6.支持设置网页字符集、URL的编码，乱码问题轻松解决
7.支持设置Cookie、Referer、User-Agent，网站检测问题轻松解决
8.支持设置代理服务器
9.支持设置是否开启重定向
10.这个版本是 0.5
*****************参数*****************
URL 网址，必须包含类似“http://www.”的开头。
Charset 网页字符集，不能是“936”之类的数字，必须是“gb2312”这样的字符。
URLCodePage URL的编码，是“936”之类的数字，默认是“65001”。有些网站需要UTF-8，有些网站又需要gb2312
Proxy 代理服务器，是形如“http://www.tuzi.com:80”的字符。
ProxyBypassList 代理服务器绕行名单，是形如“*.microsoft.com”的域名。符合域名的网址，将不通过代理服务器访问。
Cookie ，常用于登录验证。
Referer 引用网址，常用于防盗链。
UserAgent 用户信息，常用于防盗链。
EnableRedirects 重定向，默认获取跳转后的页面信息，0为不跳转。
Timeout 超时，单位为秒，默认不使用超时（Timeout=-1）。
*/


ToolTip % A_Index "-"  UrlDownloadToVar("http://192.168.10.211:33333/user?key1=123&key2=555")


UrlDownloadToVar(URL,Charset="",URLCodePage="",Proxy="",ProxyBypassList="",Cookie="",Referer="",UserAgent="",EnableRedirects="",Timeout=-1)
{
	ComObjError(0)  ;禁用 COM 错误通告。禁用后，检查 A_LastError 的值，脚本可以实现自己的错误处理
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if (URLCodePage<>"")    ;设置URL的编码
		WebRequest.Option(2):=URLCodePage
	if (EnableRedirects<>"")
		WebRequest.Option(6):=EnableRedirects
	if (Proxy<>"")  ;设置代理服务器。微软的代码 SetProxy() 是放在 Open() 之前的，所以我也放前面设置，以免无效
		WebRequest.SetProxy(2,Proxy,ProxyBypassList)
	WebRequest.Open("GET", URL, true)   ;true为异步获取，默认是false。龟速的根源！！！卡顿的根源！！！
	if (Cookie<>"") ;设置Cookie。SetRequestHeader() 必须 Open() 之后才有效
	{
		WebRequest.SetRequestHeader("Cookie","tuzi")    ;先设置一个cookie，防止出错，见官方文档
		WebRequest.SetRequestHeader("Cookie",Cookie)
	}
	if (Referer<>"")    ;设置Referer
		WebRequest.SetRequestHeader("Referer",Referer)
	if (UserAgent<>"")  ;设置User-Agent
		WebRequest.SetRequestHeader("User-Agent",UserAgent)
	WebRequest.Send()
	WebRequest.WaitForResponse(Timeout) ;WaitForResponse方法确保获取的是完整的响应
	if (Charset="") ;设置字符集
		return,WebRequest.ResponseText()
	else
	{
		ADO:=ComObjCreate("adodb.stream")   ;使用 adodb.stream 编码返回值。参考 http://bbs.howtoadmin.com/ThRead-814-1-1.html
		ADO.Type:=1 ;以二进制方式操作
		ADO.Mode:=3 ;可同时进行读写
		ADO.Open()  ;开启物件
		ADO.Write(WebRequest.ResponseBody())    ;写入物件。注意 WebRequest.ResponseBody() 获取到的是无符号的bytes，通过 adodb.stream 转换成字符串string
		ADO.Position:=0 ;从头开始
		ADO.Type:=2 ;以文字模式操作
		ADO.Charset:=Charset    ;设定编码方式
		return,ADO.ReadText()   ;将物件内的文字读出
	}
}
