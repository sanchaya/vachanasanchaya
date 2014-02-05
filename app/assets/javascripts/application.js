// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.validate
//= require highcharts
//= require exporting
//= require rangy-core
//= require jquery.ime
//= require jquery.ime.selector
//= require jquery.ime.preferences
//= require jquery.ime.inputmethods
//= require SearchHighlight
//= require zeroclipboard
//= require_tree .


$( document ).ready( function () {
	$( '#search-word' ).ime();

	$( '.search-vachanakaara-name' ).ime();


	$("#main_search").validate({
		rules:{

			"vachana":
			{
				required: true,
				minlength: 2,
				maxlength: 20
			}
			
		},
		messages:{
			"vachana":
			{
				required: "ದಯವಿಟ್ಟು ಪದವನ್ನು ಬೆರಳಚ್ಚು ಮಾಡಿ",
				minlength: "ಕನಿಷ್ಟ 2 ಅಕ್ಷರವನ್ನು ಬೆರಳಚ್ಚು ಮಾಡಿ",
				maxlength: "User name should not exceed 20 letters"
			}
		},
    // errorElement: "div",
    //     wrapper: "div",  // a wrapper around the error message
    //     errorPlacement: function(error, element) {
    //       offset = element.offset();
    //       error.insertBefore(element)
    //         error.addClass('message');  // add a class to the wrapper
    //         error.css('position', 'absolute');
    //         error.css('left', offset.left + element.outerWidth());
    //         error.css('top', offset.top);
    //       }
    errorPlacement: function (error, element) {
    	alert(error.text());
    }


});

} );



// function validateSearchForm()
// {
// 	var x=document.forms["search_vachana"]["vachana"].value;
// 	if (x==null || x=="")
// 	{
// 		alert("ದಯವಿಟ್ಟು ನಿಮಗೆ ಬೇಕಾದ ಪದವನ್ನು ಇಲ್ಲಿ ಬೆರಳಚ್ಚು ಮಾಡಿ");
// 		return false;
// 	}
// }
