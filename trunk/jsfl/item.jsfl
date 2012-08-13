var i = 0;
var j = 0;
var str = "";
var lib = fl.getDocumentDOM().library;
var ary = [];
var alphaPoinsList = [];
for(i=0; i<lib.items.length; i++){
	a = lib.items[i];
	if(a.itemType=="bitmap"){
		ary[i] = a.name;
	}
}
for(i=0; i<ary.length; i++){
	setLinkage(ary[i]);
}

function setLinkage(fileNameId){
//item_10017.jpg
	fl.getDocumentDOM().library.selectItem(fileNameId);
	var endIndex = fileNameId.lastIndexOf(".");
	var key = fileNameId.substring(0, endIndex);
	var lib = fl.getDocumentDOM().library;
//lib.setItemProperty('allowSmoothing', true);
//lib.setItemProperty('compressionType', 'lossless');
	if (lib.getItemProperty('linkageImportForRS') == true) {
		lib.setItemProperty('linkageImportForRS', false);
	}
	lib.setItemProperty('linkageExportForAS', true);
	lib.setItemProperty('linkageExportForRS', false);
	lib.setItemProperty('linkageExportInFirstFrame', true);
	lib.setItemProperty('linkageClassName', key);
	lib.setItemProperty('scalingGrid',  false);
}