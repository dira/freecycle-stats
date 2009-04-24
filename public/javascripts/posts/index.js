Event.observe(window, 'load', function() { init() });

function init() {
  var dashboard = $('dashboard');

  dashboard.select('#offers,#requests').each(function(tab){
    // add links to the group
    var action = tab.down('.action');
    tab.select('.post .meta').each(function(meta){
      Element.insert(meta, { top : action.cloneNode(true) });
    });
    // and make them visible
    tab.select('.post .meta .action').each(function(action) { 
      action.removeClassName('none');
    });

    // duplicate header
    var posts = tab.select('.post');
    var duplicate_header_after = 9;
    var header = tab.down('thead tr');
    for (var i = duplicate_header_after - 1; i < posts.length - 1; i += duplicate_header_after) {
      var fake_head = header.cloneNode(true);
      fake_head.addClassName('head');
      Element.insert(posts[i].up('tr'), { after: fake_head });
    }
  });
}
