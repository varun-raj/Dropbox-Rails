var $element = $('.section').bind('webkitAnimationEnd', function(){
    $(this).removeClass('clicked');
});

var $elementFox = $('.section').bind('animationend', function(){
    $(this).removeClass('clicked');
});

$('.section').click(function(){
   $(this).addClass('clicked');
});
