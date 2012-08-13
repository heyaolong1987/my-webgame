fl.outputPanel.clear();
//得到dom
var dom = fl.createDocument();
dom.frameRate = 24;
//得到library库
var lib = dom.library;
//选择顶级目录
var importPath = fl.browseForFolderURL("请选择一个顶级目录（一个模型一个目录）");
//文件夹目录结构如下
//顶级文件夹
//   待机文件夹  跑步文件夹  坐下文件夹  死亡.png  阴影.png
//      待机和跑步文件夹 分别包含   上  下  左 右  左上  左下   右上  右下  8个子目录
//       	 这些子目录中包含 1.png 2.png 3.png 。。。等等图片文件
if(importPath != null) {
	//导入 死亡.png  投影.png
	//var deadImgPath = importPath + "/死亡.png";
	var yinYingImgPath = importPath + "/阴影.png";
	//importImg(deadImgPath, 'dead', '死亡.png');
	importImg(yinYingImgPath);
	//8个方向
	var directions = new Array('右', '右上', '上',  '左上', '左', '左下', '下', '右下');
	var pngFileMask = "*.png";
	//包含各个方向子文件夹的父文件夹
	//譬如待机、跑步
	var fatherFolders = new Array("俯卧撑");
	//frame per png，隔5帧 0 5 10
	var fppngs = [5];
	//最后一帧是否stop
	var lastFrameScripts = new Array("gotoAndStop(1);");
	for(var k=0; k<fatherFolders.length; k++) {
		var fatherFolder = fatherFolders[k];
		lib.newFolder(fatherFolder);
		var tmpImgPath = importPath + "/" + fatherFolder + "/";
		//frame per png
		var fppng = fppngs[k];
		//最后一帧是否stop
		var lastFrameScript = lastFrameScripts[k];
		//循环8方向
		for (var i=0; i<directions.length; i++) {
			//新建库目录
			lib.newFolder(directions[i]);
			//新建元件 上mc 下mc。。。
			lib.addNewItem("movie clip", k+"_"+directions[i]+'mc');
			//编辑元件
			lib.editItem(k+"_"+directions[i]+'mc');
			//得到时间轴
			var timeline = dom.getTimeline();
			//导入png
			var directFolder = tmpImgPath + directions[i] + "/";
			var fileList = FLfile.listFolder(directFolder + pngFileMask, "files");
			if (fileList) {
    			//fl.trace(fileList.join());
				for(var j=0; j<fileList.length; j++) {
					var pngimg = fileList[j];
					dom.importFile(directFolder+pngimg, true);
					if(j != 0) {
						//fl.trace(fppng);
						timeline.insertBlankKeyframe(j*fppng);
						timeline.currentFrame = j*fppng;
					}
					lib.addItemToDocument({x:0, y:0}, pngimg);
					var el = timeline.layers[0].frames[timeline.currentFrame].elements[0];
					//读偏移文件,获得裁剪尺寸
					var cutfile = directFolder + pngimg.split(".")[0] + ".txt";
					//左边裁剪||上边裁剪||原图宽||原图高
					var offset = FLfile.read(cutfile).split("||");
					offset = [Math.floor(offset[0]), Math.floor(offset[1]), Math.floor(offset[2]), Math.floor(offset[3])];
					//fl.trace(el.width + "," + el.height + "," + el.y);
					//移动图片位置
					el.x = offset[0] - (offset[2]/2);
					el.y = offset[1] - offset[3];
					//fl.trace(el.x + "," + el.y);
					//将图片移动到方向目录
					lib.selectItem(pngimg);
					lib.moveToFolder(directions[i]);
				}
				//最后一张图加3个持续帧
				timeline.insertFrames(fppng-1);
				//加阴影
				timeline.addNewLayer("阴影", "normal", false);
				lib.addItemToDocument({x:0, y:-46}, '阴影.png');
				//最后一帧stop动作
				if(lastFrameScript != "") {
					timeline.setSelectedLayers(0);
					//新增一层as层
					timeline.addNewLayer("as");
					timeline.insertBlankKeyframe(timeline.layers[0].frameCount-1);
					timeline.layers[0].frames[timeline.layers[0].frameCount-1].actionScript = lastFrameScript; 
				}
				
				
			}
			//退出编辑模式
			dom.exitEditMode();
			//设置导出
			linkItem(k+"_"+directions[i]+'mc', k+"_"+i);
			//将汇总mc移动到上层文件夹
			lib.selectItem(k+"_"+directions[i]+'mc');
			lib.moveToFolder(fatherFolder);
			//将方向目录移动到上层文件夹
			lib.selectItem(directions[i]);
			lib.moveToFolder(fatherFolder);
		}
	}
}
//保存fla
dom.save();
dom.exportSWF();
//dom.close(false);

//导入一张图片，参数分别是：图片路径、图片导出类名、图片导入后的元件名称
function importImg(path, exportName, name) {
	dom.importFile(path, true);
	if(exportName == undefined) {
		//fl.trace(path);
		return;
	}
	linkItem(name, exportName);
}

//导出一个元件，参数分别是：元件名称、导出类名
function linkItem(name, exportName) {
	lib.selectItem(name);
	//lib.setItemProperty('allowSmoothing', true);
	//lib.setItemProperty('compressionType', 'lossless');
	if (lib.getItemProperty('linkageImportForRS') == true) {
		lib.setItemProperty('linkageImportForRS', false);
	}
	lib.setItemProperty('linkageExportForAS', true);
	lib.setItemProperty('linkageExportForRS', false);
	lib.setItemProperty('linkageExportInFirstFrame', true);
	lib.setItemProperty('linkageClassName', exportName);
	lib.setItemProperty('scalingGrid',  false);
}