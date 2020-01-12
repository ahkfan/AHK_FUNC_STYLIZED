/* 网络相关的函数

web_url_download_str(url, encoding="utf-8")
web_http_get(url)
web_http_post(url)
web_http_comobjcreate()

web_get_ip_public()

web_json_read_key(js, keyIndex)

*/



web_url_download_str(url, encoding="utf-8")
{
	/*
	简介: 下载网页

	参1: url		type(String)
		网页url

	参2: encoding	type(String)
		对应网页编码

	返回值: type(String)

	*/
	static a := "AutoHotkey/" A_AhkVersion
	if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen", "str", a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
	{
		return 0
	}
	c := s := 0, o := ""
	if (f := DllCall("wininet\InternetOpenUrl", "ptr", h, "str", url, "ptr", 0, "uint", 0, "uint", 0x80003000, "ptr", 0, "ptr"))
	{
		while (DllCall("wininet\InternetQueryDataAvailable", "ptr", f, "uint*", s, "uint", 0, "ptr", 0) && s>0)
		{
			VarSetCapacity(b, s, 0)
			DllCall("wininet\InternetReadFile", "ptr", f, "ptr", &b, "uint", s, "uint*", r)
			o .= StrGet(&b, r>>(encoding="utf-16"||encoding="cp1200"), encoding)
		}
		DllCall("wininet\InternetCloseHandle", "ptr", f)
	}
	DllCall("wininet\InternetCloseHandle", "ptr", h)
	return o
}

web_http_get(url)
{
	static whr := web_http_comobjcreate()
    whr.Open("GET", url)
    whr.Send()
	whr.WaitForResponse()
    result := whr.ResponseText
	return result
}

web_http_post(url)
{
    static whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("POST", url, true)

    if (headers != "")
    {
        for key, value in headers
        {
            whr.SetRequestHeader(key, value)
        }
    }

    whr.Send()
    whr.WaitForResponse()
    return whr.ResponseText
}

web_http_comobjcreate()
{
	/*
	返回值: type(ComObject)
		web_http_get 与 web_http_post 共用的Com对象 WinHttp.WinHttpRequest.5.1

	*/
	static WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	return WebRequest
}

web_get_ip_public()
{
	/*
	简介: 获取公网ip

	参数: 无

	返回值: type(String)
		本机所在公网ip, 格式如 "111.111.111.111"
	*/
	return web_json_read(web_http_get("http://ip.taobao.com/service/getIpInfo.php?ip=myip"), "data.ip")
}

web_json_read_key(ByRef js, keyIndex, v = "")
{
	/*
	简介: 解析json字符串, 函数来源不详, 摘自网友 EZ 的 capsez.ahk

	参1: js 		type(String)/传址
		json 字符串

	参2: keyIndex	type(String)
		键索引, 如 {data: {some : "thing"}}, 取 some, 填 "data.some"

	返回值:type(String)
		读取的数据, 失败返回空, bug不详

	示例:
		j = {"code":0,"data":{"ip":"121.204.62.159","country":"中国","area":"","region":"福建","city":"福州","county":"XX","isp":"电信","country_id":"CN","area_id":"","region_id":"350000","city_id":"350100","county_id":"xx","isp_id":"100017"}}
		MsgBox, % web_json_read(j, "data.ip")
		;~ 弹窗 121.204.62.159
	*/

	j = %js%
	Loop, Parse, keyIndex, .
	{
		p = 2
		RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
		Loop
		{
			If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
			. "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
			{
				Return
			}
			Else If (x2 == q2 or q2 == "*")
			{
				j = %x3%
				z += p + StrLen(x2) - 2
				If (q3 != "" and InStr(j, "[") == 1)
				{
					StringTrimRight, q3, q3, 1
					Loop, Parse, q3, ], [
					{
						z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
						j = %x1%
					}
				}
				Break
			}
			Else
			{
				p += StrLen(x)
			}
		}
	}
	If v !=
	{
		vs = "
		If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
		and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
		{
			vs := "", v := vx1
		}
		StringReplace, v, v, ", \", All
		js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
	}
	Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
		? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}