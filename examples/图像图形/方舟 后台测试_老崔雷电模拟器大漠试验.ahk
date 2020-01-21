; - 必要函数, 调用指针 必须要的函数群
ComVar(Type=0xC) 		{
    static base := { __Get: "ComVarGet", __Set: "ComVarSet", __Delete: "ComVarDel" }
    ; 创建含 1 个 VARIANT 类型变量的数组.  此方法可以让内部代码处理
    ; 在 VARIANT 和 AutoHotkey 内部类型之间的所有转换.
    arr := ComObjArray(Type, 1)
    ; 锁定数组并检索到 VARIANT 的指针.
    DllCall("oleaut32\SafeArrayAccessData", "ptr", ComObjValue(arr), "ptr*", arr_data)
    ; 保存可用于传递 VARIANT ByRef 的数组和对象.
    return { ref: ComObjParameter(0x4000|Type, arr_data), _: arr, base: base }
}
ComVarGet(cv, p*) 		{
    ; 当脚本访问未知字段时调用.
    if (p.MaxIndex() = "") ; 没有名称/参数, 即 cv[]
    {
        return cv._[0]
    }
}
ComVarSet(cv, v, p*) 	{
    ; 当脚本设置未知字段时调用.
    if(p.MaxIndex() = "") ; 没有名称/参数, 即 cv[]:=v
    {
        return cv._[0] := v
    }
}
ComVarDel(cv) 			{
    ; 当对象被释放时调用.
    ; 必须进行这样的处理以释放内部数组.
    DllCall("oleaut32\SafeArrayUnaccessData", "ptr", ComObjValue(cv._))
}



; TODO: 考虑dm 对象是否使用全局对象比较适合,还是直接return以后再用作全局对象?
; 大漠入口函数,如果成功,返回一个dm对象
get_dm(){
    ;此处:=表示表达式返回值赋值给变量dm/
    ; 调用大漠开始
    dm := ComObjCreate("dm.dmsoft")
    ver := dm.ver()
    If (ver){
        return dm
    }
}

; 全局函数, 指针对象
global x := ComVar()
global y := ComVar()


; 绑定句柄, - 后台
get_windows(dm, hwnd){
    ; TODO: 准备切换一个mode
    ; 句柄: 35127920
    ; 这种模式能够在win10,win7上行得通.并没有问题.
    If (dm.BindWindow(hwnd,"gdi2","windows3","windows",0)){
        MsgBox 绑定句柄成功!
        return 1
    } Else {
        MsgBox 绑定句柄失败!
    }
}

; 后台截图
get_screenshot(dm, bmp_name){
    If (dm.Capture(0,0,2000, 2000, bmp_name)){
        return 1
    }
}

; 找图
find_pic(dm, bmp_name){
    If (dm.FindPic(0,0,2000, 2000, bmp_name, "000000", 0.9, 0, x.ref, y.ref) != (-1)){
        return [x[], y[]]
    }
}

; 点击
set_click(dm, move_postiion){
    ; 从后台截图中找图, ahk的简单数组是从1开始的
    c_x := move_postiion[1] + 5
    c_y := move_postiion[2] + 5
    ; 移动到
    If(dm.MoveTo(c_x,c_y)){
        ; 单击左键
        dm.LeftClick()
        return 1
    }
}


; ************开始运行********************************************
/**
 * 只是简单则行方舟的 副本循环,点几次鼠标罢了,测试后台抓图用
 * 使用run的方法去运行.
 * @param {*} dm 大漠接口对象
 * @param {*} m_hwnd 模拟器句柄
 */
class FangZhouRiChang
{
    __New(dm, m_hwnd){
        ; 构造函数
        this._dm := dm ; 大漠接口对象
        this.hwnd := m_hwnd ; 绑定句柄
        this.ready := 0 ; 后台准备情况

        this.dl_on := 0 ; 代理情况
        this.ksxd_1 := 0 ; 行动开始_入口
        this.ksxd_2 := 0 ; 开始行动_编队内
        this.speed := 0 ; 游戏速度
        this.xdjs := 0 ; 行动结束

        ; 绑定图片名字
        this.bmp_dict := {"dl" : "代理指挥_ON.bmp"
            ,"ksxd1" : "开始行动.bmp"
            ,"ksxd2" : "开始行动_编队内.bmp"
            ,"speed2" : "2倍速度_速度调节(2X).bmp"
            ,"speed1" : "1倍速度_速度调节(1X).bmp"
            ,"xdjs" : "行动结束.bmp"}

    }

    ; 后台准备
    set_ready(){
        If (get_windows(this._dm, this.hwnd)){
            this.ready := 1
        }
    }

    ; 检查
    check(bmp_file){
        If (find_pic(this._dm, bmp_file)){
            return 1
        }
    }
	
	; 等待图片出现
    wait_check(bmp_file, interval:=2000, count:=4){
        Loop{
				sleep, interval
				IF (this.check(bmp_file)){
					return 1
				}
                if A_Index > count
					break
				continue
			}
    }

    ; 找到图片,并且用左键单击
    get_bmp_click(bmp_file){
        move_p := find_pic(this._dm, bmp_file)
        If (set_click(this._dm, move_p)){
            return 1
        }
    }
	
    ; start 线性流程
    run(){
        this.set_ready()
        If (this.ready){
			; 检查代理
            IF (this.check(this.bmp_dict["dl"])){
				this.dl_on := 1
			}
        }
        If (this.dl_on){
			; 查找开始行动入口,并且点击进入
            IF (this.get_bmp_click(this.bmp_dict["ksxd1"])){
				this.ksxd_1 := 1
			}
        }
        If (this.ksxd_1){
			sleep, 3000
			; 查找开始行动_编队入口,并且点击进入
			IF (this.get_bmp_click(this.bmp_dict["ksxd2"])){
				this.ksxd_2 := 1
			}
			
        }
		If (this.ksxd_2){
			; 检查游戏当前游戏速度
			IF (this.wait_check(this.bmp_dict["speed2"])){
				this.speed := 2
			} Else{
				IF (this.wait_check(this.bmp_dict["speed1"])){
					this.speed := 1
				}
			}
		}
		IF (this.speed > 1){
			; 改变游戏速度为X1
			IF (this.get_bmp_click(this.bmp_dict["speed2"])){
				this.speed := 1
			}
        }
		IF (this.speed == 1){
			; 等待完成,
            If (wait_check(this.bmp_dict["xdjs"], 5000, 30)){
                this.xdjs := 1
            }
		}
		IF (this.xdjs){
			; 行动结束
			; FIXME: 没把升级考虑进去
			MsgBox 行动结束!
        }

    }
}


; **********main*************************************************************************************;
dm := get_dm()
test_1 := new FangZhouRiChang(dm, 133626)
test_1.run()