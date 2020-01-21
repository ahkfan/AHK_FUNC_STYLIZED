 arr:={"aa":88,"jj":"89","hg":"567"}
msgbox % &arr "|" arr.GetAddress("aa") "|" arr.GetAddress("jj") "|" arr.GetAddress("hg")    ;~ 有效

arr:= {aa: 88}
msgbox, % arr.GetAddress("aa")  ;~ 无效