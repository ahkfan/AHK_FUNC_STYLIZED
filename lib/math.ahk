﻿/* math := math() 数学函数

*/

math()
{
    return __CLASS_AHKFS_MATH
}

class __CLASS_AHKFS_MATH
{
    calc(t, t0="", t1="", t2="")
    {
        /* 

        简介: 输出字符串表达式的计算结果

        起源:       Laszlo      : http://www.autohotkey.com/forum/topic17058.html
        原作者:     derRaphael
        Bug修正:    Lv2

        ;msgbox, % math().calc("1*2+3")
        
        */
        static  f := "sqrt|log|ln|exp|sin|cos|tan|asin|acos|atan|rad|deg|abs", c := "fib|gcb|min|max|sgn"
                o := "\*\*|\^|\*|/|//|\+|\-|%", pi:="pi", e:="e"
        if ( t0 = "fib"  && t1 != "" && t2 != "" ) 
        {
            a := 0, b := 1 
            Loop % abs(t1)-1
                c := b, b += a, a := c
            return t1=0 ? 0 : t1>0 || t1&1 ? b : -b
        } 
        else if ( t0 != "" && RegExMatch( t0, "(" f "|" c "|" o "|!)" ) && t1 != "" && t2 != "" )
            return  t0 == "**" ? t1 ** t2 : t0 == "^" ? t1 ** t2 
                    : t0 == "*" ? t1 * t2   : t0 == "/" ? t1 / t2 : t0 == "+" ? t1 + t2 : t0 == "-" ? t1 - t2
                    : t0 == "//" ? t1 // t2 : t0 == "%" ? Mod( t1, t2 ) : t0 = "abs" ? abs( this.calc( t1 ) )
                    : t0 == "!" ? ( t1 < 2 ? 1 : t1 * this.calc( t, t0, t1-1, 0 ) )
                    : t0 = "log" ? log( this.calc( t1 ) ) : t0 = "ln" ? ln( this.calc ( t1 ) )
                    : t0 = "sqrt" ? sqrt( this.calc( t1 ) ) : t0 = "exp" ? Exp( this.calc ( t1 ) )
                    : t0 = "rad" ? this.calc( t1 )*4*atan(1)/180 : t0 = "deg" ? this.calc( t1 )*180/4*atan(1)
                    : t0 = "sin" ? sin( this.calc( "rad(" t1 ")" ) ) : t0 = "asin" ? asin( this.calc( "rad(" t1 ")" ) )
                    : t0 = "cos" ? cos( this.calc( "rad(" t1 ")" ) ) : t0 = "acos" ? acos( this.calc( "rad(" t1 ")" ) )
                    : t0 = "tan" ? tan( this.calc( "rad(" t1 ")" ) ) : t0 = "atan" ? atan( this.calc( "rad(" t1 ")" ) )
                    : t0 = "min" ? ( t1 < t2 ? t1 : t2 ) : t0 = "max" ? ( t1 < t2 ? t2 : t1 )
                    : t0 = "gcd" ? ( t2 = 0 ? abs(t1) : this.calc( t, t0, this.calc( t1 "%" t2 ) ) )
                    : t0 = "sgn" ? (t1>0)-(t1<0) : 0

        t := RegExReplace( t, "\s*", "" )

        while ( RegExMatch( t, "i)" f "|" c "|" o "|" pi "|" e "|!" ) )
        {
            if ( RegExMatch( t, "i)\b" pi "\b" ) )
                t := RegExReplace( t, "i)\b" pi "\b", 4 * atan(1) )

            else if ( RegExMatch( t, "i)\b" e "\b" ) )
                t := RegExReplace( t, "i)\b" e "\b", 2.718281828459045 )

            else if ( RegExMatch( t, "i)(" f "|" c ").*", s ) 
            && RegExMatch( s, "(?>[^\(\)]*)\((?>[^\(\)]*)(?R)*(?>[^\(\)]*)\)", m )
            && RegExMatch( m, "(?P<0>[^(]+)\((?P<1>[^,]*)(,(?P<2>.*))?\)", p ) )
                t := RegExReplace( t, "\Q" p "\E", this.calc( "", p0, p1, p2 != "" ? p2 : 0 ) )

            else if ( RegExMatch( t, "(?P<1>-*\d+(\.\d+)?)!", p) )
                t := RegExReplace( t, "\Q" p "\E", this.calc( "", "!", p1, 0 ) )

            else if ( RegExMatch( t, "\((?P<0>[^(]+)\)", p ) )
                t := RegExReplace( t, "\Q(" p0 ")\E", this.calc( p0 ) )

            else
                loop, parse, o, |
                {
                    while ( RegExMatch( t, "(?P<1>-*\d+(\.\d+)?)(?P<0>" A_LoopField ")(?P<2>-*\d+(\.\d+)?)", p ) )
                        t := RegExReplace( t, "\Q" p "\E", this.calc( "", p0, p1, p2 ) )
                    If ( RegExMatch(SubStr(t, 2), "[(\*\*)\^\*(//)/\+\-`%]") = 0 )
                        return t
                }
        }
        return t        
    }

}
