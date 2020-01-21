/*

array* 在 ahk 是特殊的取值办法, 部分情况下用于替代 for 循环

*/


/* ;-----------------------------------
;~ array* 用例1: 作为其它多层数组的键
a := [1, 2 ,3]
b:= {}
b.1 := {}
b.1.2 := {}
b.1.2.3 := 123
msgbox, % b[a*]

*/

/* ;-----------------------------------
;~ array* 用例2: 作为可变参数

fc(b*)
{
    return b.Length()
}
a := [1, 2, 3]
msgbox, % fc(a*) "-" fc(a)

*/


/* ;-----------------------------------
;~ array* 例3: 此例不报错

fc2(a, b, c)
{
    return a . "-" . b . "-" . c
}
a := [1, 2, 3, 5, 6]
msgbox, % fc2(a*)
*/


/* ;-----------------------------------
;~ array* 例4
obj := {key1 : {key2 : {key3 : 123}}}
a := ["key1", "key2", "key3"]
msgbox, % obj[a*]
*/


/* ;-----------------------------------
;~ array* 例5:

class CLS
{
    class key1
    {
        class key2
        {
            static key3 := 123
        }
    }
}
a := ["key1", "key2", "key3"]
msgbox, % CLS[a*]
*/



/* ;-----------------------------------
;~ array* 例6:
class CLS
{
    class key1
    {
        class key2
        {
            static key3 := 123
        }
    }
}
a := "key1.key2.key3"
msgbox, % CLS[strsplit(a, ".")*]

*/