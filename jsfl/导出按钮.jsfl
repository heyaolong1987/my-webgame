var dict = new Object();
var allKeyArr = [];
var lib = fl.getDocumentDOM().library;
for (var i = 0; i < lib.items.length; i++){
	var item = lib.items[i];
	var itemKey = item.name.substr(0, item.name.lastIndexOf('_'));
	var arr = dict[itemKey];
	if (itemKey.length > 0 ) {
		fl.trace(itemKey);
		if(arr == null) {
			arr = [];
			allKeyArr.push(itemKey);
		}
		arr.push(item);
		dict[itemKey] = arr;
		lib.selectItem(item.name);
		var keyArr = ['over', 'up', 'down', 'disable'];
		for (var j = 0; j < keyArr.length; j++) {
			var key = keyArr[j];
			if (item.name.indexOf(key) != -1) {
				lib.setItemProperty('linkageExportForAS', true);
				lib.setItemProperty('linkageClassName', key);
			}
		}
	}
}

var exportPath = fl.browseForFolderURL("请选择素材导出路径："); 
fl.trace(allKeyArr.length);
for (var i = 0; i < allKeyArr.length; i++) {
	var key = allKeyArr[i];
	var tempArr = dict[key];
	
	var dom = fl.createDocument();
	var domLib = dom.library;
	for (var j = 0; j < tempArr.length; j++) {
		var item = tempArr[j];
		dom.addItem({x:dom.width/2, y:dom.height/2}, item);
	}
	fl.saveDocument(dom, exportPath + "/" + key + ".fla");
	dom.exportSWF(exportPath + "/" + key + ".swf", true);
	dom.close(false);
}