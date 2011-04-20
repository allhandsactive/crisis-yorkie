$(function() {

	function _reorderOrds(cx, first) {
		var el, match, thisOrd, newOrd, txt;
		var pauseIncr = 175, pauseAmt = -pauseIncr;
		for (i = 0; i < cx.length; i++) {
			el = $(cx[i]).find('.ord');
		  newOrd = i + 1;
			txt = el.text();
			if ((match = /^(\d+)\.$/.exec(txt))) {
				thisOrd = parseInt(match[1], 10);
				if (newOrd == thisOrd) {
					console.log("YES: "+newOrd);
					continue;
				}
			} else {
				console.log("no: "+txt);
			}
			(function(el, ordInt){
			  setTimeout(function(){
				  el.text('' + ordInt + '.');
				  el.css({opacity: 0.0});
					el.animate({
				    opacity: 1.0
				  }, 1500, function() {
					  //el.css({opacity : 100.0})
				  });
			  }, (pauseAmt += pauseIncr));
			})(el, newOrd);
		}
	};


	var _sortStopped = function(e, ui) {
		_reorderOrds(ui.item.parent().children());
	};


  $('ul.alternatives').sortable({
	  stop : _sortStopped
	}).disableSelection();
});
