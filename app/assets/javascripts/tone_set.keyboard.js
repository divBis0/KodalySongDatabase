jQuery(function($) {

// *** Mapped keys ***
$('.tones').not('.ui-keyboard-input').keyboard({
	layout: 'custom',
	customLayout: {
		'normal' : [
			// "n(a):title_or_tooltip"; n = new key, (a) = actual key, ":label" = title_or_tooltip (use an underscore "_" in place of a space " ")
			'd(d):do r(r):re m(m):mi f(f):fa s(s):so l(l):la t(t):ti',
      '{shift}'
		],
		'shift' : [
			'\u24d3(D):circled_do(D) \u24e1(R):circled_re(R) \u24dc(M):circled_mi(M) \u24d5(F):circled_fa(F) \u24e2(S):circled_so(S) \u24db(L):circled_la(L) \u24e3(T):circled_ti(T)',
			'{shift}'
		]
	},
  css : {
    container : 'ui-widget-content ui-widget ui-corner-all ui-helper-clearfix ui-tone_set-keyboard'
  },
  tabNavigation : true,
  autoAccept : true,
	usePreview: false // no preveiw
}).addTyping({showTyping : true});

});