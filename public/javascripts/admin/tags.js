Event.observe(window, 'load', function() { init() });

function disable_all() {
  var words = $('tags').select('input#tag_candidate_word').map(function(input){return input.value});
  $('disable_all').down('input#words').value = words;
  return true;
}

function init() {
  $('disable_all').onsubmit = disable_all;
}

