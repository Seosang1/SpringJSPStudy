$(document).ready(function(){

	//메인배너
	$('.mcBg').slick({
		swipe: false,
		autoplay: true,
		autoplaySpeed: 4000,
		speed:1000,
		arrows: false,
		dots: false,
		fade: true,
		pauseOnHover: false,
		asNavFor: '.mcTitle',
		responsive: [{
		breakpoint: 992,
			settings: {
				swipe: true,
				arrows: false
			}
		}]
	});

	$('.mcTitle').slick({
		asNavFor: '.mcBg',
		autoplaySpeed: 4000,
		speed:1000,
		arrows: false,
		fade: true
	});




	//메인 패밀리사이트
	$('.mfSldr').slick({
		swipe: false,
		autoplay: true,
		autoplaySpeed: 4000,
		speed:800,
		arrows: true,
		dots: false,
		slidesToShow: 5,
		slidesToScroll: 1,
		pauseOnHover: false,
		responsive: [{
		breakpoint: 1141,
			settings: {
				swipe: true,
				slidesToShow: 3,
				slidesToScroll: 1,
			}
		},{
		breakpoint: 992,
			settings: {
				swipe: true,
				slidesToShow: 2,
				slidesToScroll: 1,
			}
		}]
	});
	



});


//연구보고서
function mccTab(obj, num){
	$('.mccTab ul li a').removeClass('on');
	$(obj).addClass('on');
	$('.mccCont').hide();
	$('#mcc'+num).show();
};





//wayPoint
$('.mainCnt').waypoint(function(direction) {
	if(direction==="down") {
		counter();
	} else {
		//counter();
	}
}, {	   
	offset: '100%'
});