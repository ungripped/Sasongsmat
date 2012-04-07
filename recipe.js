$(document).ready(function() {
                  $("span:contains('Länkar')").parent("h2").hide();
                  $("span:contains('Författare')").parent("h2").hide();
                  $("span:contains('Källor')").parent("h2").hide();
                  $(".editsection").hide();
                  $("img[alt^='QR-']").parents("p").hide();
                  $("#manadshuvud").hide();
                  
                  $.each($("p"), function(index, obj) {
                         obj = $(obj);
                         obj.html($.trim(obj.html()));
                         });
                  $("p:empty").remove();
                  $("a[class!='mw-redirect']").addClass('vislink');
                  $.each($("img[src^='/']"), function(index, obj) {
                         $(obj).attr('src', 'http://xn--ssongsmat-v2a.nu' + $(obj).attr('src'));
                         });
                  
                  
                  
                  var arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                  $.each($('.manadsrad').children(), function(index, obj) {
                         obj = $(obj);
                         if (obj.hasClass('lite'))
                         arr[index] = 1;
                         else if (obj.hasClass('mycket'))
                         arr[index] = 2;
                         else if (obj.hasClass('full'))
                         arr[index] = 3;
                         });
                  
                  if ($('body > .thumb').length == 0) {
                  $('body').prepend($("<div class='thumb tright'><div class='thumbinner'><a href='#' class='image vislink'><img src='bigrecipe.png' class='thumbimage'/></a><div class='thumbcaption'>Bild saknas</div></div></div>"));
                  }
                  
                  $('body > .thumb').prepend('<div id="indicator"><canvas width="300" height="30"></canvas></div>');
                  renderIndicator($('#indicator canvas')[0], arr);
                  
                  console.log(arr);
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


function renderIndicator(canvas, seasonInfo) {
    if (window.devicePixelRatio) {
        var hidefCanvas = $(canvas);
        var canvasWidth = cssWidth = hidefCanvas.attr('width');
        var canvasHeight = cssHeight = hidefCanvas.attr('height');
        
        hidefCanvas.attr('width', canvasWidth * window.devicePixelRatio);
        hidefCanvas.attr('height', canvasHeight * window.devicePixelRatio);
        hidefCanvas.css('width', cssWidth);
        hidefCanvas.css('height', cssHeight);
        
    }
    
	var ctx = canvas.getContext('2d');
    
    ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
    
	ctx.strokeStyle = 'rgb(0,0,0)';
	ctx.font = "11px sans-serif";
	ctx.lineWidth = 1;
    
	ctx.textBaseline = "middle";
    ctx.textAlign = "center";
    
    var man = new Array ("J","F","M","A","M","J","J","A","S","O","N","D");
    var adj = new Array (0, 0, 0,0, 0,0,0,0,0,0,0,0);//höger/vänster-justering i pixlar av mpnadsbokstäver, fat de verkligen ska se centrerade ut
	var adjVertical = [-1, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0];
	$.each(seasonInfo, function(index, item) {
           var opac = 0;
           if (item == 1) { opac = .33; } 
           else if (item == 2) { opac = .67; }
           else if (item == 3) { opac = 1; }
           
           ctx.fillStyle = 'rgba(140, 198, 57,' + opac + ')';
           ctx.beginPath();
           //ctx.arc(10 + index*19, 10, 8, 0, Math.PI*2, true);
           ctx.arc(12 + index*25, 11, 10, 0, Math.PI*2, true);
           ctx.closePath();
           ctx.fill();
           ctx.stroke();
           
           ctx.fillStyle = 'rgba(0,0,0,1)';
           ctx.fillText(man[index], index*25 + 12 + adj[index], 11); // + adjVertical[index]);
           });
}



function removeInfoBoxes() {
	var boxes = "";
    
    $.each($("table.infobox"), function(idx, elm) {
           
           boxes += elm.outerHTML;
           $(elm).remove();
           });
    
	return boxes;
}