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

function speakVachana(elementId) {
  var text = $('#' + elementId).text();
  speakVachanaText(text);
}

function speakVachanaText(text) {
  if (!window.speechSynthesis) {
    alert('ಧ್ವನಿ ವಾಚನವು ಈ ಬ್ರೌಸರ್ನಲ್ಲಿ ಲಭ್ಯವಿಲ್ಲ. ದಯವಿಟ್ಟು Chrome ಬಳಸಿ.');
    return;
  }
  window.speechSynthesis.cancel();
  var utterance = new SpeechSynthesisUtterance(text);
  utterance.lang = 'kn-IN';
  utterance.rate = 0.85;
  utterance.pitch = 1.0;
  speechSynthesis.speak(utterance);
}


