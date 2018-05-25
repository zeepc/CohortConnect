console.log("connected");


$(document).on('turbolinks:load', function(){
	console.log("doc ready!!!!")
  $(".button").click(function(){
      $('.modal, .modal-backdrop').hide();
      console.log("clicked");
  });
})
