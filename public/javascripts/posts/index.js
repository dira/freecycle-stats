Event.observe(window, 'load', function() { init() });

function init() {
  var dashboard = $('dashboard');
  dashboard.select('#offers,#requests').each(function(tab){
    var action = tab.down('.action');
    tab.select('.post .meta').each(function(meta){
      Element.insert(meta, {top : action.cloneNode(true) }); 
    });
    // and make them visible
    tab.select('.post .meta .action').each(function(action) { 
      action.removeClassName('none');
    });
  });
}
