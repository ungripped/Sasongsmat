$(document).ready(function() {
	$("img[alt^='QR-']").parents("p").hide();
    $("p:empty").remove();
    //$("a[class!='mw-redirect']").addClass('vislink');
	
	$("caption:first").addClass("first");
	$("a").removeClass('vislink');
	$("th:contains('Recept')").parents("tr").remove();
	$("a[title^='Recept:']").parents("tr").remove();
	
	$.each($("img"), function(idx, elm) {
		var f = "file://";
		if (elm.src.indexOf(f) == 0) {
			elm.src = "http://xn--ssongsmat-v2a.nu/" + elm.src.substring(f.length);
		}
		else {
			elm.src = "http://xn--ssongsmat-v2a.nu/" + elm.src;
		}
	});
});


/*
          
              $("a").click(function(event) {
                           var target = $(event.target);
                           
                           if (target.attr("class") == "mw-redirect") {
                           event.preventDefault();
                           }
                           if (!target.is("a")) {
                           event.preventDefault();
                           }
                           else if (target.attr("href").match(/^\/ssm\/Fil/)) {
                           event.preventDefault();
                           }
                           });

*/