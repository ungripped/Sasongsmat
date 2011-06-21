$(document).ready(function() {
	$("span:contains('Länkar')").parent("h2").hide();
    $("span:contains('Författare')").parent("h2").hide();
    $("span:contains('Källor')").parent("h2").hide();
    $("img[alt^='QR-']").parents("p").hide();
    $("p:empty").remove();
	$("a[class!='mw-redirect']").addClass('vislink');
	
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
});