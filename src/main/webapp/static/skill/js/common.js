$(document).ready(function(){


	//GNB
	$('#gnbBot .gbMenu > li').each(function(index){
		var gnbName = $(this).children('a').text();
		$(this).children('ul').prepend('<div class="gbTitle"><div><h6><span>'+gnbName+'</span></h6><p>서울시 독성물질 중독관리센터</p></div></div>');
	});

	$('#gnbBot .gbMenu > li').each(function(index){
		if ($(this).has('ul').length){
			$(this).append('<span></span>');
		} else {
			$(this).find('a').addClass('deptNo');
		};		
	});

	$('#gnbBot .gbMenu > li').hover(
		function () {
			$('#gnbBot .gbMenu > li > ul').removeClass('on');
			$(this).children('ul').addClass('on');
		},
		function () {
			$('#gnbBot .gbMenu > li > ul').removeClass('on');
		} 
	);

	$('#gnbBot .gbMenu > li > a').focus(function(){
		$('#gnbBot .gbMenu > li > ul').removeClass('on');
		$(this).next('ul').addClass('on');
	});	
	
	$('#gnbBot .gbMenu > li:first-child > a').keydown(function(event){
		var v_keyCode = event.keyCode || event.which;
		if(v_keyCode == 9){
			if(event.shiftKey){
				$(this).next('ul').removeClass('on');
			}else{				
				
			}
		}
	});

	$('#gnbBot .gbMenu > li > ul > li:last-child > a').blur(function(){
		$('#gnbBot .gbMenu > li > ul').removeClass('on');
	});

	




	//모바일메뉴
	$('#gnbMo').prepend('<em></em><em></em><em></em>');
	$('#gnbMo').click(function(){
		if($(this).is('.on')) {
			$(this).children('span').text('전체메뉴 열기');
			$(this).removeClass('on');
			$('.gbWrap').removeClass('on');
			$('html, body').removeClass('lock');
		}else {
			$(this).children('span').text('전체메뉴 닫기');
			$(this).addClass('on');
			$('.gbWrap').addClass('on');
			$('html, body').addClass('lock');
		}
	});
	
	$('.gtSns').clone().appendTo('.gbWrap');

	$('#gnbBot .gbMenu > li > span').click(function(){
		if($(this).is('.on')) {
			$(this).removeClass('on');
			$(this).prev('ul').removeClass('open');
		}else {
			$('#gnbBot .gbMenu > li > span').removeClass('on');
			$('#gnbBot .gbMenu > li > ul').removeClass('open');
			$(this).addClass('on');
			$(this).prev('ul').addClass('open');
		}
	});

	


	$('body').on('mousewheel', function(e) {
		var wheel = e.originalEvent.wheelDelta; 
		var sHeight = $(document).scrollTop();
		if(wheel<0){
			if(sHeight>=0){
				$('#gnb').addClass('scroll');	
			};
		} else {
			if(sHeight<120){
				$('#gnb').removeClass('scroll');
			};
		};
	})





	//패밀리사이트
	$('.fttFmy button').click(function(){
		if($(this).is('.on')) {
			$(this).removeClass('on');
			$(this).next().slideUp('fast');
		}else {
			$(this).addClass('on');
			$(this).next().slideDown('fast');
		}
	});	

	$(document).mouseup(function (e){
		if($('.fttFmy').has(e.target).length === 0){
			$('.fttFmy ul').slideUp('fast');
			$('.fttFmy button').removeClass('on');
		}
	});




	//subNav
	$('.subBcrb button').click(function(){
		if($(this).is('.on')) {
			$(this).removeClass('on');
			$(this).next().slideUp('fast');
		}else {
			$('.subBcrb button').removeClass('on');
			$('.subBcrb ul').slideUp('fast');
			$(this).addClass('on');
			$(this).next().slideDown('fast');
		}
	});	

	$(document).mouseup(function (e){
		if($('.subBcrb').has(e.target).length === 0){
			$('.subBcrb ul').slideUp('fast');
			$('.subBcrb button').removeClass('on');
		}
	});

	
	


		
	


});



