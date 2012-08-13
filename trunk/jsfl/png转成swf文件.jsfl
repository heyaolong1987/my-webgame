fl.outputPanel.clear(); 
var className = "data";
fl.trace(className);
var resourcePath;
var swfPath;
var bitmapFolder;
var mcFolder;
if(className==""||className==null){
	alert("请输入类名");
}else {
	resourcePath=fl.browseForFolderURL("请选择素材路径："); 
	swfPath=fl.browseForFolderURL("请选择素材导出路径："); ;
	bitmapFolder="图素"; 
	mcFolder="导出类"; 
	analyseFolder(resourcePath, swfPath); 
}




//递归处理每个文件夹 
function analyseFolder(folderPath,outputFolder) 
{
	var fileList=FLfile.listFolder(folderPath, 'files');
	var filePathList;
	var filePathArr=[];
	for(var i=0;i<fileList.length;i++)
	{
		var fileName=fileList[i]; 
		var ind=fileName.indexOf("."); 
		filePathList=folderPath.split("|");
		filePathArr=filePathList[1].split("/");
		fl.trace(filePathList[1]);
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
		var dom = fl.createDocument(); 
		var lib=dom.library; 
		//不要后缀的文件名 
		shortName=fileName.substr(0,ind); 
		var filePath=folderPath+"/"+fileName; 
		//fl.trace(filePath); 
		//导入图片 
		dom.importFile(filePath,true); 
		//选择项 
		lib.selectItem(fileName); 
		var item=lib.items[0];
		item.name=FileName;
		item.linkageExportForAS = true;
		item.linkageExportInFirstFrame = true;
		item.linkageBaseClass = "flash.display.BitmapData";
		item.linkageClassName=className;
		dom.addItem({x:dom.width/2, y:dom.height/2}, item);
		dom.exportSWF(outputFolder+"/"+FileName+".swf",true);
		//fl.saveDocument(dom,swfPath+"/"+FileName+".fla"); 
		dom.close(false); 
	 }
	 //子文件夹 
	 var folderList=FLfile.listFolder(folderPath,"directories"); 
	 for(var j=0;j<folderList.length;j++) 
	 {
		var attr = FLfile.getAttributes(folderPath + "/" +folderList[j]);
		fl.trace("attr--->" + attr);
		fl.trace("directict---------->" + folderList[j]);
		if (attr && attr.indexOf("D")!=-1 && attr.indexOf("H")==-1) {
			FLfile.createFolder(swfPath + "/" + folderList[j]);
			analyseFolder(folderPath+"/"+folderList[j],outputFolder+"/"+folderList[j]); 
		}
	 }
}