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

  loadBookmarks();
  $(document).on('click', '.bookmark-btn', toggleBookmark);
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

var BOOKMARKS_KEY = 'vachana_categories';

function migrateBookmarks() {
  var old = localStorage.getItem('vachana_bookmarks');
  if (old) {
    var parsed = JSON.parse(old);
    if (Array.isArray(parsed)) {
      var data = { version: 2, categories: { default: parsed } };
      localStorage.setItem(BOOKMARKS_KEY, JSON.stringify(data));
      localStorage.removeItem('vachana_bookmarks');
    }
  }
}

function getBookmarkData() {
  migrateBookmarks();
  var raw = localStorage.getItem(BOOKMARKS_KEY);
  if (!raw) return { version: 2, categories: { default: [] } };
  var d = JSON.parse(raw);
  if (!d.categories) d.categories = { default: [] };
  if (!d.categories.default) d.categories.default = [];
  return d;
}

function saveBookmarkData(data) {
  localStorage.setItem(BOOKMARKS_KEY, JSON.stringify(data));
}

function getBookmarkIds() {
  var d = getBookmarkData();
  var ids = [];
  for (var cat in d.categories) {
    d.categories[cat].forEach(function(id) {
      if (ids.indexOf(id) === -1) ids.push(id);
    });
  }
  return ids;
}

function getCategories() {
  var d = getBookmarkData();
  return Object.keys(d.categories);
}

function idInCategory(id, category) {
  var d = getBookmarkData();
  return d.categories[category] && d.categories[category].indexOf(id) !== -1;
}

function isBookmarkedAnywhere(id) {
  var d = getBookmarkData();
  for (var cat in d.categories) {
    if (d.categories[cat].indexOf(id) !== -1) return true;
  }
  return false;
}

function categoriesForId(id) {
  var d = getBookmarkData();
  var cats = [];
  for (var cat in d.categories) {
    if (d.categories[cat].indexOf(id) !== -1) cats.push(cat);
  }
  return cats;
}

function addBookmark(id, category) {
  var d = getBookmarkData();
  cat = category || 'default';
  if (!d.categories[cat]) d.categories[cat] = [];
  if (d.categories[cat].indexOf(id) === -1) d.categories[cat].push(id);
  saveBookmarkData(d);
}

function removeBookmark(id) {
  var d = getBookmarkData();
  for (var cat in d.categories) {
    var idx = d.categories[cat].indexOf(id);
    if (idx !== -1) d.categories[cat].splice(idx, 1);
  }
  saveBookmarkData(d);
}

function toggleBookmark() {
  var btn = $(this);
  var id = parseInt(btn.data('vachana-id'));
  if (isBookmarkedAnywhere(id)) {
    removeBookmark(id);
    btn.removeClass('bookmarked');
  } else {
    addBookmark(id, 'default');
    btn.addClass('bookmarked');
  }
  return false;
}

function showCategoryPicker(btn) {
  var id = parseInt(btn.data('vachana-id'));
  var popup = $('#category-picker');
  if (!popup.length) {
    popup = $('<div id="category-picker" class="category-picker">' +
      '<div class="category-picker-inner">' +
        '<strong style="font-size:13px;">ವರ್ಗ ಆಯ್ಕೆಮಾಡಿ:</strong>' +
        '<div class="category-list"></div>' +
        '<div style="margin-top:6px;"><input type="text" id="new-cat-input" placeholder="ಹೊಸ ವರ್ಗ..." style="width:140px;font-size:12px;padding:2px 4px;" />' +
        '<button class="btn btn-mini" id="new-cat-btn" style="margin-left:4px;">+</button></div>' +
        '<div style="margin-top:6px;text-align:right;">' +
          '<button class="btn btn-mini btn-primary" id="cat-pick-save">ಉಳಿಸಿ</button>' +
          '<button class="btn btn-mini" id="cat-pick-cancel" style="margin-left:4px;">ರದ್ದು</button>' +
        '</div>' +
      '</div></div>').appendTo('body');
    var selectedCat = 'default';
    popup.on('click', '.cat-option', function() {
      popup.find('.cat-option').removeClass('selected');
      $(this).addClass('selected');
      selectedCat = $(this).data('cat');
    });
    popup.on('click', '#cat-pick-save', function() {
      addBookmark(id, selectedCat);
      loadBookmarks();
      popup.fadeOut(150);
    });
    popup.on('click', '#cat-pick-cancel', function() {
      popup.fadeOut(150);
    });
    popup.on('click', '#new-cat-btn', function() {
      var name = $('#new-cat-input').val().trim();
      if (name) {
        var d = getBookmarkData();
        if (!d.categories[name]) {
          d.categories[name] = [];
          saveBookmarkData(d);
          renderCategoryOptions(popup, name);
        }
      }
      $('#new-cat-input').val('');
    });
  }
  renderCategoryOptions(popup, isBookmarkedAnywhere(id) ? 'default' : 'default');
  popup.fadeIn(150).position({ my: 'left top', at: 'left bottom', of: btn });
}

function renderCategoryOptions(popup, selected) {
  var d = getBookmarkData();
  var list = popup.find('.category-list').empty();
  for (var cat in d.categories) {
    var cls = 'cat-option' + (cat === selected ? ' selected' : '');
    list.append('<div class="' + cls + '" data-cat="' + cat + '">' + cat + ' (' + d.categories[cat].length + ')</div>');
  }
}

function loadBookmarks() {
  var ids = getBookmarkIds();
  $('.bookmark-btn').each(function() {
    var id = parseInt($(this).data('vachana-id'));
    $(this).toggleClass('bookmarked', ids.indexOf(id) !== -1);
  });
}

function createCategory(name) {
  var d = getBookmarkData();
  if (!d.categories[name]) d.categories[name] = [];
  saveBookmarkData(d);
}

function renameCategory(oldName, newName) {
  if (oldName === newName) return;
  var d = getBookmarkData();
  if (!d.categories[oldName]) return;
  d.categories[newName] = d.categories[oldName];
  delete d.categories[oldName];
  saveBookmarkData(d);
}

function deleteCategory(name) {
  if (name === 'default') return;
  var d = getBookmarkData();
  var ids = d.categories[name] || [];
  delete d.categories[name];
  ids.forEach(function(id) {
    if (d.categories['default'].indexOf(id) === -1) d.categories['default'].push(id);
  });
  saveBookmarkData(d);
}


