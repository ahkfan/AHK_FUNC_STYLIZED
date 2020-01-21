
/*
虚荣的笔记..有点乱

IE对象从这里摘的, 边看边尝试边翻译的部分:
	https://blog.csdn.net/darkread/article/details/7241098

IE属性:
	ie.Visible := true				;可选, 一般显示可见
	ie.Width := 1200 				;设置IE对象宽度
	ie.Height := 600 				;设置IE对象高度
	ie.Resizable :=0				;设置对象尺寸能否被改动
	ie.MenuBar :=0 					;不显示IE对象菜单栏
	ie.AddressBar :=0 				;不显示IE对象地址栏
	ie.ToolBar :=0 					;不显示IE对象工具栏
	ie.StatusBar := 0 				;不显示IE对象状态栏
	ie.FullScreen := 1				;全屏显示浏览器
	ie.Offline := 0					;设置离线脱机?


	ie.ReadyState					;枚举对象, 当前状态 https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/bb268228%28v%3dvs.85%29

	ie.StatusText					;状态栏文本字符串
	ie.LocationURL					;当前url(网址)
	ie.LocationName					;当前网页标题
	ie.FullName						;保存ie的完整名称字符串
	ie.Path							;保存ie的文件夹路径
	ie.Name							;保存ie的名称字符串
	ie.Busy							;布尔值, 忙碌状态为true
	ie.HWND							;窗口句柄

IE方法:
	ie.Navigate(url, Flags, TargetFrameName, PostData, Headers)	; 转向页面
	ie.GoBack()		;返回, 需要等待加载
	ie.GoForward()	;前进, 需要等待加载
	ie.GoHome()		;到主页
	ie.GoSearch()	;跳转至bing搜索网页 https://cn.bing.com/?scope=web
	ie.Quit()		;关闭浏览器
	ie.Refresh()	;刷新网页
	ie.Stop()		;取消继续加载页面

	ie.Parent 		;获取它的父对象
	ie.Document		;获取它的DOM对象, 操作网页主要方法

Document的方法
	;这里看w3cschool: https://www.w3cschool.cn/jsref/dom-obj-document.html
	;返回element元素对象在ahk中为数组, getElement(s).0 , 首位为0, id为getElement, id具有唯一性
	;getElement这类方法必须对html标签有所了解
	<标签 属性1="值">	标签中文本	</标签>

	ie.document.getElementById()			;返回对拥有指定 id 的第一个对象的引用。
	ie.document.getElementsByClassName().0	;返回文档中所有指定类名的元素集合，作为 NodeList 对象。
	ie.document.getElementsByName().0 		;返回带有指定名称的对象集合(数组)
	ie.document.getElementsByTagName().0	;返回带有指定标签名的对象集合(数组)

element元素对象方法
	;返回的元素对象属性/方法 看这, 菜鸟教程 : http://www.runoob.com/jsref/dom-obj-all.html
	;菜鸟教程这个页面显示大部分通用的元素方法


	;侧边导航栏[Html对象]下列表包含具体element元素的属性和方法
	如:
		百度 :
			input 元素(搜索框) id 为 kw, 有属性值value可以赋值为具体文本
			button 元素 id 为 su, 有click()方法执行点击, click()没找到记录
		某论坛:
			select元素的selectedIndex属性可以:=赋值为选中的项目
			元素.focus()方法似乎通用
/*

/* 示例
ie.Navigate("https://www.baidu.com/")					;设置转向的页面

while (ie.ReadyState != 4) or (ie.busy)					;等待网页加载完毕, 可写成函数
	sleep 10

ie.Document.getElementById("kw").value := "abc"			;设定元素(element)对象的文本
ie.Document.getElementById("kw").innerText := "abc"		;同上
ie.Document.getElementById("su").click()				;点击事件
sleep 1000
ie.Document.getElementById("kw").innerText := ""
ie.Document.getElementById("su").click()
;ie.Document.getElementsByClassName("input_search").0.click
;ie.Document.getElementsByClassName("input_search").0.innerText := "abc"
*/

ie := ComObjCreate("InternetExplorer.Application")		;创建ie对象
msgbox, % ie.Path
ie.Visible := true										;显示ie(是否可见)
ie.Navigate("http://www.crskybbs.net/login.php")		;跳转网页
while (ie.ReadyState != 4) or (ie.busy)					;等待网页加载完毕, 可写成函数
	ToolTip, % ie.StatusText

ie.Document.getElementsByName("question").0.focus()
ie.Document.getElementsByName("question").0.selectedIndex := 6

;ie.Navigate("https://www.baidu.com/")	;设置转向的页面



