var NotationKeyboard = {};

jQuery(function($) {
  
NotationKeyboard.options = {
	layout: 'custom',
	customLayout: {
		'normal' : [
			// "n(a):title_or_tooltip"; n = new key, (a) = actual key, ":label" = title_or_tooltip (use an underscore "_" in place of a space " ")
			'\ue1d2(1):whole_note(1)   \ue1d3(2):half_note(2) \ue1f1(3):quarter_note(3)      \ue1d7(4):eight_note(4)     \ue1d9(5):16th_note(5)',
      '\ue1f8(q):eighth_start_beam(q)  \ue1fa(w):16th_beam(w) \ue1f3(e):fract_eighth_note(e) \ue1f5(r):frac_16th_note(r) \ue1fc(.):augmentation_dot(.)',
      '{shift}'
		],
		'shift' : [
			'\ue4e3(!):whole_rest(Shift+1) \ue4e4(@):half_rest(Shift+2) \ue4e5(#):quarter_rest(Shift+3) \ue4e6($):eighth_rest(Shift+4) \ue4e7(%):16th_rest(Shift+5)', // Rests
      '\ue1fe(Q):tuplet_start(Q)     \ue202(W):tuplet3(W)         \ue200(E):tuplet_end(E)         \ue1fd(R):tie(R)',
			'{shift}'
		]
	},
  css : {
    container : 'ui-widget-content ui-widget ui-corner-all ui-helper-clearfix ui-notation-keyboard'
  },
  tabNavigation : true,
  autoAccept : true,
	usePreview: false // no preveiw
};

});