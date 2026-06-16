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

function speechSynthesisVoices() {
  if (!window.speechSynthesis) return [];
  var voices = window.speechSynthesis.getVoices();
  if (voices.length) return voices;
  return [];
}

function findKannadaVoice() {
  var voices = speechSynthesisVoices();
  var kn = voices.filter(function(v) {
    return v.lang.indexOf('kn') === 0;
  });
  if (kn.length) return kn[0];
  var anyIn = voices.filter(function(v) {
    return v.lang.indexOf('IN') > 0;
  });
  if (anyIn.length) return anyIn[0];
  return voices[0] || null;
}

function speakVachanaText(text) {
  if (!window.speechSynthesis) {
    alert('ಧ್ವನಿ ವಾಚನವು ಈ ಬ್ರೌಸರ್ನಲ್ಲಿ ಲಭ್ಯವಿಲ್ಲ. ದಯವಿಟ್ಟು Chrome/Edge/Safari ನವೀಕರಿಸಿದ ಆವೃತ್ತಿಯನ್ನು ಬಳಸಿ.');
    return;
  }
  speechSynthesis.cancel();

  if (!speechSynthesisVoices().length) {
    speechSynthesis.addEventListener('voiceschanged', function handler() {
      speechSynthesis.removeEventListener('voiceschanged', handler);
      doSpeak(text);
    });
  }
  doSpeak(text);
}

function doSpeak(text) {
  var voice = findKannadaVoice();
  var utterance = new SpeechSynthesisUtterance(text);
  if (voice) {
    utterance.voice = voice;
  }
  utterance.lang = 'kn-IN';
  utterance.rate = 0.85;
  utterance.pitch = 1.0;
  utterance.volume = 1.0;
  utterance.onerror = function(e) {
    console.error('Speech error:', e);
  };
  speechSynthesis.speak(utterance);
}


