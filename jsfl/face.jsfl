for(var i=0; i<107; i++)
{
	//得到library库
	var lib = fl.getDocumentDOM().library;
	//name 计算
	//65-73是没有的 100是没有的
	//k为最终表情序号
	var k = i;
	var name = "face_" + i;
	if(i<10)
		name = "face_0" + i;
	else if(i>=65 && i<91)
	{
		name = "face_" + (i+9);
		k = i+9;
	}
	else if(i>=91)
	{
		name = "face_" + (i+10);
		k = i+10;
	}
	//帧间隔不一样，100以下为0 6 12 18 …… ，100以上为0 3 6 9……
	var fppng = 6;//frame per png
	if(k>100)
		fppng = 3;
	//新建元件
	lib.addNewItem("movie clip", name);
	//编辑元件
	lib.editItem(name);
	//得到时间轴
	var timeline = fl.getDocumentDOM().getTimeline();
	//循环拖入png序列
	for(var j=0;;)
	{
		//拼接pngname
		var pngname = fillNumMask(3,k)+".tcp_"+fillNumMask(4,j)+".png";
		if(lib.itemExists(pngname))
		{
			//fl.trace(pngname);
			if(j != 0)
			{
				timeline.insertBlankKeyframe(j*fppng);
				timeline.currentFrame = j*fppng;
			}
			lib.addItemToDocument({x:0, y:0}, pngname);
			fl.getDocumentDOM().selectAll();
			var rect = fl.getDocumentDOM().getSelectionRect();
			//fl.trace(rect.left + ":" + rect.top);//总是.999，抑郁了
			//var w=(rect.right-rect.left);   
   			// var h=(rect.bottom-rect.top); 
			fl.getDocumentDOM().moveSelectionBy({x:-rect.left+0.001, y:-rect.top+0.001});
			j++;
		}
		else
		{
			timeline.insertFrames(fppng-1);
			break;
		}
	}
	//退出编辑模式
	fl.getDocumentDOM().exitEditMode();
	//选中
	lib.selectItem(name);
	//rename
	//lib.renameItem(name);
	//link
	lib.setItemProperty('symbolType', 'movie clip');
	if (lib.getItemProperty('linkageImportForRS') == true) {
	lib.setItemProperty('linkageImportForRS', false);
	}
	lib.setItemProperty('linkageExportForAS', true);
	lib.setItemProperty('linkageExportForRS', false);
	lib.setItemProperty('linkageExportInFirstFrame', true);
	lib.setItemProperty('linkageClassName', name);
	lib.setItemProperty('scalingGrid',  false);
}

function fillNumMask(length, num)
{
	var numstr = String(num);
	var rtn = numstr;
	for(var i=0; i<length-numstr.length; i++)
		rtn = "0"+rtn;
	return rtn;
}