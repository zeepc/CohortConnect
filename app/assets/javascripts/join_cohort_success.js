$(document).on('turbolinks:load', function(){


$("#join").click(function(evt){
  evt.preventDefault();
  	$('#emailModal').modal('show');
    setTimeout( function(){
      $('#emailModal').remove();
        }, 2000 )
    $('#join').hide();
    });
});

