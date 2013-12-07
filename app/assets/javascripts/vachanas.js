
$(function() {
  return $('a.load-more-vachanas').on('inview', function(e, visible) {
    if (!visible) {
      return;
    }
    return $.getScript($(this).attr('href'));
  });
});
