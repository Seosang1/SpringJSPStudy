$(document).ready(function(){
    // sub menu view
    $('.gnb_wrap .gnb li').mouseenter(function(){
    	var subId = '#'+$(this).attr('id').replace('gnb', 'sub');
        $(subId).stop(true, true).slideDown('fast');
        $(subId).css('margin-left',$(this).offset().left+'px');
        $(subId).siblings().hide();
    });
    $('.gnb_sub_wrap').mouseleave(function(e){
        $('.gnb_sub').stop(true, true).slideUp('fast');
    });
    // placeholder
    if( !('placeholder' in document.createElement('input')) ){
        $('input[placeholder],textarea[placeholder]').each(function(){
            var that=$(this),
                text= that.attr('placeholder');
            if(that.val()===""){
                that.val(text).addClass('placeholder');
            }
            that.focus(function(){
                    if(that.val()===text){
                        that.val("").removeClass('placeholder');
                    }
                })
                .blur(function(){
                    if(that.val()===""){
                        that.val(text).addClass('placeholder');
                    }
                })
                .closest('form').submit(function(){
                if(that.val() === text){
                    that.val('');
                }
            });
        });
    }
    
    // date picker
    $('.datepicker').datepicker({
        dateFormat : 'yy-mm-dd',
        monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        monthNamesShort : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dayNamesShort : ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
        dayNamesMin : ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
        showButtonPanel:true,
        currentText:'',
        closeText:'취소',
        isRTL:true
    }, $.datepicker.regional['ko']).mask('0000-00-00');
    
    $('.datepickerMaxToday').datepicker({
        dateFormat : 'yy-mm-dd',
        monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        monthNamesShort : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dayNamesShort : ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
        dayNamesMin : ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
        showButtonPanel:true,
        maxDate: new Date(),
        currentText:'',
        closeText:'취소',
        isRTL:true
    }, $.datepicker.regional['ko']).mask('0000-00-00');
    
    $('.datepicker').next().click(function(e){
    	$(this).prev().focus();
    	e.preventDefault();
    	return false;
    });
    
    // 첨부파일
    var $fileBox = null;
    init();
});

// 첨부파일
var init = function() {
    $fileBox = $('.input-file');
    fileLoad();
}  
var fileLoad = function() {
    $.each($fileBox, function(idx){
      var $this = $fileBox.eq(idx), $btnUpload = $this.find('[type="file"]'), $label = $this.find('.file-label');
      
      $btnUpload.on('change', function() {
        var $target = $(this), fileName = $target.val(), $fileText = $target.siblings('.file-name');
        $fileText.val(fileName);
      })
      
      $btnUpload.on('focusin focusout', function(e) {
        e.type == 'focusin' ? $label.addClass('file-focus') : $label.removeClass('file-focus');
      })
    })
}
