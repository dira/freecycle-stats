Event.observe(window, 'load', function() { init() });

function init() {
  var dashboard = $('dashboard');

  dashboard.select('#offers, #requests').each(function(tab){
    // don't want to be considered spammers - so add the hundred links dynamically
    var action = tab.down('.action');
    tab.select('td .meta').each(function(meta){
      var duplicate = action.cloneNode(true).show();
      Element.insert(meta, { top :  duplicate});
    });

    // duplicate header
    var posts = tab.select('td');
    var duplicate_header_after = 9;
    var header = tab.down('thead tr');
    for (var i = duplicate_header_after - 1; i < posts.length - 1; i += duplicate_header_after) {
      var fake_head = header.cloneNode(true);
      fake_head.addClassName('head');
      Element.insert(posts[i].up('tr'), { after: fake_head });
    }
  });
}
