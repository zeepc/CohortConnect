console.log("connected");


$(document).on('turbolinks:load', function(){
  $(".button").click(function(){
      $('.modal, .modal-backdrop').hide();	
  });
})
