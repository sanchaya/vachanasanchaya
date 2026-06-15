$(function() {
  $('a.load-more-vachanas').on('inview', function(e, visible) {
    if (!visible) {
      return;
    }
    var $link = $(this);
    $link.hide();
    $('<div class="loading-indicator">Loading...</div>').insertAfter($link);
    return $.getScript($link.attr('href'), function() {
      $('.loading-indicator').remove();
    }).fail(function() {
      $('.loading-indicator').remove();
      $link.show();
    });
  });

  $(document).on('click', '.load-more-vachanas', function(e) {
    e.preventDefault();
    var $link = $(this);
    $link.hide();
    $('<div class="loading-indicator">Loading...</div>').insertAfter($link);
    $.getScript($link.attr('href')).always(function() {
      $('.loading-indicator').remove();
    }).fail(function() {
      $link.show();
    });
  });
});


