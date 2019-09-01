function bs_input_file() {
	$(".input-file").before(
		function() {
			if ( ! $(this).prev().hasClass('input-ghost') ) {
				var element = $("<input type='file' id='fileupload' class='input-ghost' style='visibility:hidden; height:0' accept='.csv,.xlsx' onchange='checkfile(this);parseFile(this);'>");
				element.attr("name",$(this).attr("name"));
				element.change(function(){
					element.next(element).find('input').val((element.val()).split('\\').pop());
				});
				$(this).find("button.btn-choose").click(function(){
					element.click();
				});
				$(this).find("button.btn-reset").click(function(){
					element.val(null);
					$(this).parents(".input-file").find('input').val('');
				});
				$(this).find('input').css("cursor","pointer");
				$(this).find('input').mousedown(function() {
					$(this).parents('.input-file').prev().click();
					return false;
				});
				return element;
			}
		}
	);
}
function checkfile(sender) {
    // 可接受的附檔名
    var validExts = new Array(".xlsx", ".csv");

    var fileExt = sender.value;
    fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
    if (fileExt != '' && validExts.indexOf(fileExt) < 0) {
      alert("檔案類型錯誤，可接受的副檔名有：" + validExts.toString());
      sender.value = null;
      return false;
    }
    else return true;
}

$(function() {
	bs_input_file();
});

function parseFile(input) {
    var fileExt = input.value;
    extension = fileExt.substring(fileExt.lastIndexOf('.')).toLowerCase();
    if(extension != undefined && '.xlsx' == extension.toLowerCase()) {
        doConvert(input);
    } 
    else if(extension != undefined && '.csv' == extension.toLowerCase()) {

    }
}

var url = window.URL.createObjectURL(new Blob([
	"importScripts('https://cdn.dhtmlx.com/libs/excel2json/1.0/worker.js');"
], { type: "text/javascript" }));

var worker = new Worker(url);
worker.addEventListener("message", e => {
    if (e.data.type === "ready"){
        jsonData = JSON.parse(JSON.stringify(e.data, replacer, 2));
        spreadsheet.parse(jsonData, 'xlsx');
    }
});

function doConvert(input) {
    worker.postMessage({
        type: "convert",
        data: input.files[0],
    });
};

function replacer(key, value) {
	if (key === null || value === null) {
	    return '';
	}
	return value;
}