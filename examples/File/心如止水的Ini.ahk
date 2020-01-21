

/*
说明:用于读写 Ini 文件的 Ini 对象 和 Section 对象
*/
class Ini {
	path:=""
;---------------------------------------------------------------------- 
	
	__New(aPath){
		new PathObj(aPath)
		this.path:=aPath
		return this
	}
;---------------------------------------------------------------------- 
	;引
	readAllIni(){
		FileRead,allIni,% this.path
		this.allIni := allIni
		return
	}
;---------------------------------------------------------------------- 
	;引
	trimBlankLine(){
		_Container.deepDelete(this.theMap,aRegEx:="^(?!.*=).*$")	
		return		
	}
;---------------------------------------------------------------------- 
	;引
	dividedBySection(){	
		theLineSpliter:=new Spliter(this.allIni,"`r`n")
		List:=theLineSpliter.split()		
		theSectionIndexList:=_List.OldMatch(List,"\[.*\]")		
		_List.RegExReplace(List,"\[(.*)\]","$1")					
		this.theMap:=_List.getMapByIndex(List,theSectionIndexList*)	
		return
	}
;---------------------------------------------------------------------- 
	;引
	dividedByKeyValue(){
		aSpliter:=new Spliter("","=")
		aSpliter.deleteBlankelement:=false
		aSpliter.elementTrim:=false		
		_Container.deepSplit(this.theMap,aSpliter)	
		return
	}
;---------------------------------------------------------------------- 
	;引
	swapToMap(){
		_Container.swapToMap(this.theMap)	
		_Container.shuck(this.theMap)
		_Container.swapToMaps(this.theMap)
		return
	}
	
;---------------------------------------------------------------------- 
	getMap(){
		this.readAllIni()
		this.dividedBySection()
		this.trimBlankLine()
		this.dividedByKeyValue()
		this.swapToMap()	
		return this.theMap
	}
;---------------------------------------------------------------------- 
	getSection(aSection){
		newSection:=this.Section.__New(this,aSection)
		return newSection
	}
	
;---------------------------------------------------------------------- 
	class Section{
		theIni:="",section:=""
		;---------------------------------------------------------
	__New(aIni,aSection){
		this.theIni:=aIni
		this.section:=aSection
		return this
	}
	;---------------------------------------------------------------------- 
		read(aKey,aDefault:=""){
			Thread, NoTimers , True
			Thread, Priority, 20000
			path := this.theIni.path
			LogPrintln(path,A_LineFile  "("  A_LineNumber  ")"  " : " "path >>> `r`n")
			LogPrintln(this.section,A_LineFile  "("  A_LineNumber  ")"  " : " "this.section >>> `r`n")
			LogPrintln(aKey,A_LineFile  "("  A_LineNumber  ")"  " : " "aKey >>> `r`n")
			IniRead, OutVar, %path% ,  % this.section, %aKey% , %aDefault%
			if ((aDefault="") AND (OutVar=="ERROR")){
				LogPrintln(OutVar,A_LineFile  "("  A_LineNumber  ")"  " : " "OutVar >>> `r`n")
				throwWithSt(_Ex.NoExistKey)
			}
			return OutVar
		}		
	;---------------------------------------------------------------------- 
		write(aKey,value){
			IniWrite, %value%, % this.theIni.path, % this.section, %aKey%
			return 
		}		
		
	;---------------------------------------------------------------------- 
		rawInit(aKey,value := ""){
			try{
				this.read(aKey)
			}
			catch{
				this.write(aKey,value)
			}
			return
		}			
	;---------------------------------------------------------------------- 
		init(aKeyList*){
			for i,v in aKeyList {
				ableLoad := (Mod(i,2)=0)
				if(ableLoad)
					this.rawInit(lastV,v)
				else
					lastV := v
			}
			return
		}		
	;---------------------------------------------------------------------- 
		writeByMap(aMap){
			for aKey , value in aMap {
				IniWrite, %value%, % this.theIni.path, % this.section, %aKey%
			}
			return 
		}		
	
;---------------------------------------------------------------------- 
	
		readInMap(aMap,aKey,aDefault:=""){
			data:=this.read(aKey,aDefault)
			aMap[aKey]:=data
			return
		}	
;---------------------------------------------------------------------- 
		getMap(aKeys*){
			theMap:=getEmptyMap(aKeys*)
			for key,v in theMap {
				this.readInMap(theMap,key,aDefault:="")
			}
			return theMap
		}
;---------------------------------------------------------------------- 
		
	}
}
;-----------class Ini End