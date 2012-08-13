fl.outputPanel.clear(); 
var className = "data";
//fl.trace(className);
var resourcePath;
var swfPath;
var bitmapFolder;
var mcFolder;
var list;
if(className==""||className==null){
	alert("请输入类名");
}else {
	resourcePath=fl.browseForFolderURL("请选择素材路径："); 
	if(resourcePath != null){
		swfPath=resourcePath;
		bitmapFolder="图素"; 
		mcFolder="导出类"; 
		list = FLfile.listFolder(resourcePath,"directories");
		//fl.trace("list "+list.length);
		var paths;
		for(var i=0;i<list.length;i++){
			paths = resourcePath+"/"+list[i];
			//fl.trace("list[i]:  "+list[i]+" paths "+paths);
			analyseFolder(paths,"");
		}
	}
	//analyseFolder(resourcePath,""); 
}




//递归处理每个文件夹 
function analyseFolder(folderPath,libFolder,resName,savePath) 
{
	var fileList=FLfile.listFolder(folderPath,"files");
	var filePathList;
	var filePathArr=[];
	var offset=[];
	
	var timeLine;
	var bitmap;
	var folderList;
	var temp = folderPath.split("/").pop().split(",");
	var _savePath = folderPath.split("/");
	_savePath.pop();
	_savePath = _savePath.join("/");
	//fl.trace("temp"+temp+"  folderPath "+folderPath+"  _savePath "+_savePath);
	if(temp.length <= 1){
		folderList=FLfile.listFolder(folderPath,"directories"); 
	 	for(var j=0;j<folderList.length;j++) 
	 	{
			analyseFolder(folderPath+"/"+folderList[j],libFolder+"/"+folderList[j],temp,_savePath); 
		}
		 return;
	}
	var dom = fl.createDocument(); 
	var lib=dom.library; 
	//fl.trace("folderPath analyseFolder "+folderPath+" "+temp);
	var allOffset = [Math.floor(temp[0]),Math.floor(temp[1])];
	//className = temp[2]+"";
	className = resName+"";
	lib.addNewItem("movie clip", className);
	fl.getDocumentDOM().library.addItemToDocument({x:200,y:200},className);
	lib.editItem(className);
	timeLine=fl.getDocumentDOM().getTimeline();
	timeLine.insertBlankKeyframe();
	for(var i=0;i<fileList.length;i++)
	{
		var fileName=fileList[i]; 
		//fl.trace("folderPath "+folderPath);
		var ind=fileName.indexOf("."); 
		filePathList=folderPath.split("|");
		filePathArr=filePathList[1].split("/");
		//fl.trace(FLfile.createFolder(swfPath+"/"+filePathList[1]));
		//如果没有后缀或后缀不正确则略过
		if(ind<=0||ind==(fileName.length-1))
		{
			continue;
		}
		//后缀 
		var ext=fileName.substr(ind+1,fileName.length-ind);
		var FileName=fileName.substr(0,ind);
		ext=ext.toLowerCase(); 
		//不是图片则略过
		if(ext!="bmp"&&ext!="gif"&&ext!="jpg"&&ext!="jpeg"&&ext!="png") 
		{
			continue; 
		}
		
		
		//不要后缀的文件名 
		shortName=fileName.substr(0,ind); 
		var filePath=folderPath+"/"+fileName; 
		//导入图片 
		dom.importFile(filePath,true); 
		//选择项 
		lib.selectItem(fileName); 
		
		
		
		
	   	
		var offsetPath=folderPath+"/"+shortName+".txt";
		var offsetFile = FLfile.read(offsetPath)+"";
		if(offsetFile == ""){
			//fl.trace("offsetFile == null");
			continue;
		}
		offset=FLfile.read(offsetPath).split("||");
		offset=[Math.floor(offset[0]),Math.floor(offset[1])];

		lib.editItem(className);
		timeLine=fl.getDocumentDOM().getTimeline();
		
		//放到舞台上 
		fl.getDocumentDOM().library.addItemToDocument({x:0,y:0},fileName);
		//fl.trace("allOffset "+allOffset+"   offset "+offset+" offsetPath "+offsetPath+"FLfile.read(offsetPath)");
		bitmap=timeLine.layers[0].frames[timeLine.frameCount-1].elements[0];
		bitmap.x = 0+offset[0]+allOffset[0];
		bitmap.y = 0+offset[1]+allOffset[1];
		
		//fl.trace("offsetPath:  "+bitmap +bitmap.name+"    "+bitmap.x +"    "+bitmap.y); 
		
		timeLine.insertKeyframe();
		fl.getDocumentDOM().selectAll(); 

		fl.getDocumentDOM().deleteSelection();
		
		timeLine.insertBlankKeyframe();
		
	 }
	 timeLine.removeFrames();
	 for(var i=0;i<timeLine.frameCount;i++)
	 {
		if(i>1 && i % 2 == 0){
			//fl.trace("i "+i);
			timeLine.clearKeyframes(i);
		}
	 }
	 
	 timeLine.insertBlankKeyframe();
	 fl.trace(fl.actionsPanel.setText("stop();"));
	 //timeLine.removeFrames();
	 //fl.trace("swfPath     "+folderPath+"/save.swf");
	 dom.exportSWF(folderPath+"/"+resName+".swf",true);
	 dom.frameRate = 24;
	 fl.saveDocument(dom,savePath+"/"+resName+".fla"); 
	 dom.close(false); 
	 //子文件夹 
	 folderList=FLfile.listFolder(folderPath,"directories"); 
	 for(var j=0;j<folderList.length;j++) 
	 {
		analyseFolder(folderPath+"/"+folderList[j],libFolder+"/"+folderList[j]); 
	 }
}