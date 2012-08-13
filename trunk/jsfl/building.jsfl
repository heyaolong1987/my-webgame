var i = 0;
var j = 0;
var str = "";
var lib = fl.getDocumentDOM().library;
var ary = [];
var alphaPoinsList = [];
for(i=0; i<lib.items.length; i++){
	a = lib.items[i];
	//if(a.name!="undefined" && a.name.indexOf("/")==-1){
	//	ary.push(a.name);
	//}
	if(a.itemType=="bitmap" && a.name!="undefined" && a.name.indexOf("/")==-1){
		ary.push(a.name);
	}
}
for(i=0; i<ary.length; i++){
	setLinkage(ary[i]);
	convertToMcCenterContent(ary[i]);
}

function resetName(fileNameId) {
	fl.getDocumentDOM().library.selectItem(fileNameId);
	var key = fileNameId.substr(fileNameId.lastIndexOf("_")+1);
	if(key.indexOf(".")!=-1) {
		key = key.substr(0, key.length-4);
	}
	var clan = key.substr(0, 1);
	var type = key.substr(2, 2);
	var level = key.substr(4, 1);
	if(type.charAt(0)=="0") {
		type = type.substr(1,1);
	}
	key = fileNameId.substr(0, fileNameId.lastIndexOf("_")+1) + clan;
	if(type>0) {
		key = key + "_" + type;
	}
	if(level>0) {
		key = key + "_" + level;
	}
	var lib = fl.getDocumentDOM().library;
	if(fileNameId.indexOf(".")!=-1) {
		key = key + fileNameId.substr(fileNameId.indexOf("."));
	}
	lib.renameItem(key);
	return key;
}

function resetLinkage(fileNameId) {
	fl.getDocumentDOM().library.selectItem(fileNameId);
	var key = fileNameId.substr(fileNameId.lastIndexOf("_")+1);
	if(key.indexOf(".")!=-1) {
		key = key.substr(0, key.length-4);
	}
	var clan = key.substr(0, 1);
	var type = key.substr(2, 2);
	var level = key.substr(4, 1);
	if(type.charAt(0)=="0") {
		type = type.substr(1,1);
	}
	key = fileNameId.substr(0, fileNameId.lastIndexOf("_")+1) + clan;
	if(type>0) {
		key = key + "_" + type;
	}
	if(level>0) {
		key = key + "_" + level;
	}
	var lib = fl.getDocumentDOM().library;
	if (lib.getItemProperty('linkageImportForRS') == true) {
		lib.setItemProperty('linkageImportForRS', false);
	}
	lib.setItemProperty('linkageExportForAS', true);
	lib.setItemProperty('linkageExportForRS', false);
	lib.setItemProperty('linkageExportInFirstFrame', true);
	lib.setItemProperty('linkageClassName', key);
	lib.setItemProperty('scalingGrid',  false);
}

function setLinkage(fileNameId){
	fl.getDocumentDOM().library.selectItem(fileNameId);
	//fl.getDocumentDOM().library.renameItem("building_img_"+fileNameId.substr(9));
	var lib = fl.getDocumentDOM().library;
	if (lib.getItemProperty('linkageImportForRS') == true) {
		lib.setItemProperty('linkageImportForRS', false);
	}
	lib.setItemProperty('linkageExportForAS', true);
	lib.setItemProperty('linkageExportForRS', false);
	lib.setItemProperty('linkageExportInFirstFrame', true);
	lib.setItemProperty('linkageClassName', fileNameId.substr(0, fileNameId.length-4));
	lib.setItemProperty('scalingGrid',  false);
}

function convertToMc(fileNameId){
	var key = fileNameId.substr(13, fileNameId.length-17);
	fl.getDocumentDOM().library.selectItem(ary[i]);
	fl.getDocumentDOM().library.addItemToDocument({x:0, y:0});
	
	fl.getDocumentDOM().selectAll();
	fl.getDocumentDOM().convertToSymbol('movie clip', 'building_mc_'+key, 'top left');
	var lib = fl.getDocumentDOM().library;
	if (lib.getItemProperty('linkageImportForRS') == true) {
		lib.setItemProperty('linkageImportForRS', false);
	}
	lib.setItemProperty('linkageExportForAS', true);
	lib.setItemProperty('linkageExportForRS', false);
	lib.setItemProperty('linkageExportInFirstFrame', true);
	lib.setItemProperty('linkageClassName', 'building_mc_'+key);
	lib.setItemProperty('scalingGrid',  false);
	
	fl.getDocumentDOM().mouseClick({x:1, y:1}, false, true);

	fl.getDocumentDOM().selectAll();
	fl.getDocumentDOM().deleteSelection();
}



function convertToMcCenterContent(fileNameId){
	var key = fileNameId.substr(13, fileNameId.length-17);
	fl.getDocumentDOM().library.selectItem(ary[i]);
	fl.getDocumentDOM().library.addItemToDocument({x:0, y:0});
	
	fl.getDocumentDOM().selectAll();
	fl.getDocumentDOM().convertToSymbol('movie clip', 'building_mc_'+key, 'top left');
	var lib = fl.getDocumentDOM().library;
	if (lib.getItemProperty('linkageImportForRS') == true) {
		lib.setItemProperty('linkageImportForRS', false);
	}
	lib.setItemProperty('linkageExportForAS', true);
	lib.setItemProperty('linkageExportForRS', false);
	lib.setItemProperty('linkageExportInFirstFrame', true);
	lib.setItemProperty('linkageClassName', 'building_mc_'+key);
	lib.setItemProperty('scalingGrid',  false);
	
	fl.getDocumentDOM().mouseClick({x:1, y:1}, false, true);
	fl.getDocumentDOM().enterEditMode('inPlace');
	
	fl.getDocumentDOM().selectAll();
	fl.getDocumentDOM().moveSelectionBy({x:-fl.getDocumentDOM().selection[0].width/2, y:-fl.getDocumentDOM().selection[0].height});
	
	fl.getDocumentDOM().exitEditMode();
	fl.getDocumentDOM().selectAll();
	fl.getDocumentDOM().deleteSelection();
}