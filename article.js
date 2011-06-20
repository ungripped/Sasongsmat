$(document).ready(function(){
    $("span:contains('Länkar')").parent("h2").hide();
    $("span:contains('Författare')").parent("h2").hide();
    $("span:contains('Källor')").parent("h2").hide();
    $("img[alt^='QR-']").parents("p").hide();
    $("p:empty").remove();
});