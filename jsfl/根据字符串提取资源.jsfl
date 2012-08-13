fl.outputPanel.clear(); 
findStr = prompt("请输入要导出的类,以'',''分割");
getStr(findStr);
var resourcePath=fl.browseForFileURL("open"); 

swfPath=resourcePath;


analyseFolder(resourcePath); 

function getStr(_str){
	if(_str == null){
		return;
	}
	var reg = /'|\[|\]|\s*/g;
	var str = _str.split(",").join("==").replace(reg,"");
	findStr = str.split("==");
}

//递归处理每个文件?
function analyseFolder(folderPath) 
{
	if(folderPath == null){
		return;
	}
		var fileName=folderPath; 
		var ind=fileName.indexOf("."); 
		//后缀 
		var ext=fileName.substr(ind+1,fileName.length-ind);
		var FileName=fileName.substr(0,ind);
		fl.trace(FileName+"...."+ext);
		ext=ext.toLowerCase(); 
		//不是fla则略?
		if(ext!="fla") 
		{
			return; 
		}
		
		//不要后缀的文件名 
		shortName=fileName.substr(0,ind); 
		var filePath=fileName; 
		fl.trace("filePath "+filePath);
		var dom = fl.openDocument(filePath); 
		var lib=dom.library; 
		var items=lib.items;
		//fl.trace(items);
		var k,l,lists=[],names=[];
		
		
		for(k=0;k<items.length;k++)
		{
			if(items[k].itemType == "folder"){
				continue;
			}
			for(l=0;l<findStr.length;l++){
				if(findStr[l] == items[k]["linkageClassName"]){
					lists.push(items[k]);
					names.push(findStr[l]);
					break;
				}
			}
		}
		
		var newDom = fl.createDocument();
		
		var shortName,selectList;
		var add;
		for(k=0;k<lists.length;k++){
			shortName = names[k];
			//newDom.library.newFolder(shortName+"File");
			newDom.addItem({x:0,y:0}, lists[k]);
			//fl.trace(lists[k].name);
			//fl.trace(newDom.library.selectItem(shortName));
			//newDom.library.moveToFolder(shortName+"File");
			
			//newDom.library.addNewItem("movie clip", shortName+"File/"+shortName);
			
			//fl.trace(newDom.library.duplicateItem(shortName+"/"+shortName));
			//fl.trace();
			//fl.trace(newDom.library.moveToFolder(shortName+"_File")); 
			//newDom.convertToSymbol("movie clip",lists[k],"top left"); 
           //	
          	
 			
			
 			//newDom.deleteSelection();
			//fl.trace(selectList);
			//traceAttr(selectList[0]);
				
		}
		newDom.selectAll();
		newDom.deleteSelection();
		fl.saveDocument(newDom, FileName+"_new.fla"); 
		fl.closeDocument(newDom);
		fl.closeDocument(dom,false);
}
function traceAttr(obj){
	var str;
	for(str in obj){
		fl.trace(str + " : "+obj[str]);
	}
}