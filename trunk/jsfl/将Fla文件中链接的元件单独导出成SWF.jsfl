swfPath=fl.browseForFolderURL("请选择素材导出路径："); ;
var lib = fl.getDocumentDOM().library;
var length = lib.items.length;
for (var i = 0; i < length; i ++) {
	var item = lib.items[i];
	if (item.itemType == "movie clip" && item.linkageExportForAS) {
		var dom = fl.createDocument();
		var domLib = dom.library;
		dom.addItem({x:dom.width/2, y:dom.height/2}, item);
		domLib.selectItem(item.name);
		var tempItem = domLib.getSelectedItems()[0];
		tempItem.linkageClassName = 'data';
		fl.trace(item.name);
		dom.exportSWF(swfPath + "/" + item.linkageClassName + ".swf", true);
		dom.close(false);
	}
}
fl.trace(lib.items.length);
alert("导出完成");