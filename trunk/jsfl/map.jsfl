var scenes = [["����̲", 10220], ["��ѩ��", 10520], ["����ɽ", 10330], ["�ʺ繵", 10210],
 ["������", 10230], ["����ɽ", 10530], ["������", 10630], ["��ʯ��", 10410], ["�ۺ���", 10440],
 ["��¥", 10350], ["��������", 10320], ["����", 10430], ["�����س���", 10140], ["���ú�", 10620],
 ["��֮԰", 10110], ["����ɭ��", 10130], ["�̹���", 10640], ["��̶", 10450], ["�츸��", 10510],
 ["������", 10650], ["΢��ɽ��", 10150], ["ε�a��", 10240], ["�޶�", 10540], ["��ľ��", 10420],
 ["��ң��", 10250], ["ѩ��", 10550], ["��̲", 10310], ["����", 10340], ["��ԭҰ", 10610], ["����", 10120]
];
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
	convertToMc(ary[i]);
}

function getSceneId(scenename) {
	for (var x in scenes)
	{
		if(scenes[x][0] == scenename) {
			return scenes[x][1];
		}
	}
	return 0;
}

function convertToMc(fileNameId){
//ѩ��.png
	var endIndex = fileNameId.lastIndexOf(".");
	var scenename = fileNameId.substring(0, endIndex);
	var sceneid = getSceneId(scenename);
	var key = "map_img_3_" + sceneid;
	fl.getDocumentDOM().library.selectItem(fileNameId);
	fl.getDocumentDOM().library.addItemToDocument({x:0, y:0});
	
	fl.getDocumentDOM().selectAll();
	fl.getDocumentDOM().convertToSymbol('movie clip', scenename, 'top left');
	var lib = fl.getDocumentDOM().library;
	if (lib.getItemProperty('linkageImportForRS') == true) {
		lib.setItemProperty('linkageImportForRS', false);
	}
	lib.setItemProperty('linkageExportForAS', true);
	lib.setItemProperty('linkageExportForRS', false);
	lib.setItemProperty('linkageExportInFirstFrame', true);
	lib.setItemProperty('linkageClassName', key);
	lib.setItemProperty('scalingGrid',  false);
	
	fl.getDocumentDOM().mouseClick({x:1, y:1}, false, true);
	fl.getDocumentDOM().enterEditMode('inPlace');
	
	fl.getDocumentDOM().selectAll();
	fl.getDocumentDOM().breakApart();
	fl.getDocumentDOM().exitEditMode();
	fl.getDocumentDOM().selectAll();
	fl.getDocumentDOM().deleteSelection();
}