$( document ).ready(function() {

  $('.roll-dice').click(function() {
    $(this).fadeOut(500,function(){
        $('.third-left h2').fadeOut();
        $('.third-right h2').fadeOut();
        $('.stop-dice').show();
    });
  });

  $('.stop-dice').click(function() {
      $('.popup-wrap').addClass('active');
  });

  $('.chouse-number a').click(function() {
      $(this).toggleClass('active');
  });

  $('.minus').click(function() {
      $('.bid-amount');
  });

  // close pop up
  $('.close, .popup-wrap .overlay').click(function(event) {
    event.preventDefault();
    $('.popup-wrap').fadeOut().removeClass('active');
  });

});
