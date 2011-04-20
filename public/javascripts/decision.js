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

  var _encodeRankingValue = function(ul) {
    var ss = [];
    ul.children().each(function(){
      ss.push($(this).find('.label').text());
    });
    return ss.join(',');
  };

  // @todo unhack this was written quickly
  var f = $('#the-form'); // assume max one for now
  var alts = f.find('ul.alternatives');
  var questionIdx = 0;
  if (alts.length) {
    for (var i = 0; i < alts.length; i++) {
      var a = alts[i] = $(alts[i]);
      var useName = a.attr('data-form-name') || ("q-"+questionIdx+"-multi-winner");
      ++ questionIdx;
      var inp = $('<input type="hidden" name="'+useName+'" value="" />');
      f.append(inp);
      a.data("_input", inp);
    }
    $('#the-form').bind('submit', function(f){ // would like only once
      for (i = 0; i < alts.length; i++) {
        a.data('_input').attr('value', _encodeRankingValue(alts[i]));
      }
    });
  }


  alts.sortable({
    stop : _sortStopped
  }).disableSelection();
});
