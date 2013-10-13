( function ( $ ) {
	'use strict';

	$.extend( $.ime.sources, {
		'kn-inscript': {
			name: 'ಇನ್ಸ್ಕ್ರಿಪ್ಟ್',
			source: '/assets/rules/kn/kn-inscript.js'
		},
		'kn-inscript2': {
			name: 'ಇನ್\u200cಸ್ಕ್ರಿಪ್ಟ್ ೨',
			source: '/assets/rules/kn/kn-inscript2.js'
		},
		'kn-transliteration': {
			name: 'ಲಿಪ್ಯಂತರಣ',
			source: '/assets/rules/kn/kn-transliteration.js'
		},
		'kn-kgp': {
			name: 'KGP/Nudi/KP Rao',
			source: '/assets/rules/kn/kn-kgp.js'
		},
		'ky-cyrl-alt': {
			name: 'Кыргыз Alt',
			source: 'rules/ky/ky-cyrl-alt.js'
		}
	} );

	$.extend( $.ime.languages, {
		'kn': {
			autonym: 'ಕನ್ನಡ',
			inputmethods: [ 'kn-transliteration', 'kn-inscript', 'kn-kgp', 'kn-inscript2' ]
		}
	} );

}( jQuery ) );
