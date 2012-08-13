var scenes = [["白珠滩", 10220], ["冰雪城", 10520], ["不高山", 10330], ["彩虹沟", 10210],
 ["苍凉崖", 10230], ["凤起山", 10530], ["浮云林", 10630], ["怪石窟", 10410], ["观虹瀑", 10440],
 ["归楼", 10350], ["花湖树海", 10320], ["锦池", 10430], ["九曲回肠湾", 10140], ["莲悦湖", 10620],
 ["梦之园", 10110], ["迷雾森林", 10130], ["盘古塔", 10640], ["清潭", 10450], ["天父峰", 10510],
 ["亡灵声", 10650], ["微风山谷", 10150], ["蔚瀉湖", 10240], ["无冬", 10540], ["无木林", 10420],
 ["逍遥岛", 10250], ["雪海", 10550], ["银滩", 10310], ["永夏", 10340], ["洲原野", 10610], ["紫岭", 10120]
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
//雪海.png
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