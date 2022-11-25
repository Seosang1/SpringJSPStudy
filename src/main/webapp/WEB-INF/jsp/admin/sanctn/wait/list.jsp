<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var cwmaList;
	
	$(function(){
		cwmaList = new cwma.list({pageLayer:$('.paging')});
		
		$('[name=jumin1]').keyup(function(){
			if($(this).val().length == 6){
				$('[name=jumin2]').focus();
			}
		});
		
		//검색버튼 클릭이벤트
		$('#btnSearch').click(function(e){
			if($.trim($('[name=bgnDrftDe]').val()) != "" && $.trim($('[name=endDrftDe]').val()) != ""){
				if( Number($('[name=bgnDrftDe]').val().replace(/-/g, '')) > Number($('[name=endDrftDe]').val().replace(/-/g, ''))){
					alert('종료일이 시작일보다 작을 수 없습니다.');
					return false;
				}
			}
			
			ajaxList(1);
			return false;
		});
		
		//검색버튼 클릭이벤트
		$('#mSearch').click(function(e){
			searchMember();
			return false;
		});
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(){
			$('#frm').attr('action', 'view.do');
			$('#frm').append('<input type="hidden" name="careerNo" value="'+$(this).data('sn')+'" />');
			$('#frm').append('<input type="hidden" name="sanctnKnd" value="'+$(this).data('knd')+'" />');
			$('#frm').submit();
		});
		
		//검색버튼 클릭이벤트
		$('#frm input').keyup(function(e){
			if(e.keyCode == 13){
				$('#btnSearch').click();
				e.preventDefault();
			}
			return false;
		});
		
		//검색버튼 클릭이벤트
		$('#siFrm input').keyup(function(e){
			e.preventDefault();
			if(e.keyCode == 13){
				$('#mSearch').click();
				e.preventDefault();
			}
			return false;
		});
		
		$('#chkAll').click(function(){
			if($('#chkAll').is(':checked')){
				$('#result tr').find('[name=docNoList]').each(function(){
					$(this).attr('checked', true);
				});
			}else{
				$('#result tr').find('[name=docNoList]').each(function(){
					$(this).attr('checked', false);
				});
			}
		});

		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/sanctnProgrs/excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'));
			e.preventDefault();
			return false;
		});
		
		agncyMember();
		
		<c:if test="${!empty param.se}">
			$('[name="se"]').each(function(){
				if($(this).val() == '${param.se}'){
					$(this).attr('checked',true);
				}
			})
		</c:if>
		
		$('#btnSearch').click();
	});
	
	//날짜계산 입력
	function dateInput(type, input){
		var date1 = '', date2 = '';
		
		var cDate = new Date();
		var cDate2 = new Date();
		
		if(type == '1'){
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate);
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2);
		}else if(type == '2'){
			cDate.setTime(new Date().getTime() - (1 * 24 * 60 * 60 * 1000)); //1일전
	
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate );
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '3'){
			cDate.setTime(new Date().getTime() - (7 * 24 * 60 * 60 * 1000)); //1일전
	
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate );
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '4'){
			cDate.setTime(new Date().getTime() - (30 * 24 * 60 * 60 * 1000)); //1일전
	
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate );
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '5'){
			cDate.setTime(new Date().getTime() - (60 * 24 * 60 * 60 * 1000)); //1일전
	
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate );
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '6'){
			date1 = cDate.getFullYear() + "-01-01";
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '7'){
			date1 = '';
			date2 = '';
		}
		$('[name=bgnDrftDe]').val(date1);				
		$('[name=endDrftDe]').val(date2);	
	}
	
	var wrapWindowByMask = function() {
        var maskHeight = $(document).height(); 
        var maskWidth = $(window).width();
        console.log( "document 사이즈:"+ $(document).width() + "*" + $(document).height()); 
        console.log( "window 사이즈:"+ $(window).width() + "*" + $(window).height());   
        $('#mask').css({
            'width' : maskWidth,
            'height' : maskHeight
        });
        $('#mask').fadeTo("slow", 0.8);
    }
    var popupOpen = function() {
        $('.layerpop').css("position", "absolute");
        $('.layerpop').css("top",(($(window).height() - $('.layerpop').outerHeight()) / 2) + $(window).scrollTop());
        $('.layerpop').css("left",(($(window).width() - $('.layerpop').outerWidth()) / 2) + $(window).scrollLeft());
        $('.layerpop').draggable();
        $('#layerbox').show();
    }
    var popupClose = function() {
        $('#layerbox').hide();
        $('#mask').hide();
        
    }
    var goApp = function() {
        popupOpen();
        wrapWindowByMask(); 
    }
	
	//리스트조회 함수
	var ajaxList = function(pageNo){
		$('#frm').attr('action', 'list.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '	<td><input type="checkbox" name="docNoList" data-knd="'+this.sanctnKnd+'" value="'+this.careerNo+'"> <label for="aa"></label></td>';
					html += '	<td>'+this.rownum+'</td>';
					html += '	<td>'+this.seNm+'</td>';
					html += '	<td>'+(this.rceptDe?this.rceptDe:'')+'</td>';
					html += '	<td class="btnView" data-sn="'+this.careerNo+'" data-knd="'+this.sanctnKnd+'">'+(this.rceptNo?this.rceptNo:'')+'</td>';
					html += '	<td class="btnView" data-sn="'+this.careerNo+'" data-knd="'+this.sanctnKnd+'">'+this.nm+'</td>';
					html += '	<td>'+(this.draftDe?this.draftDe:'')+'</td>';
					html += '	<td>'+this.chrgBrffcNm+'</td>';
					html += '	<td>'+this.drafter+'</td>';
					html += '	<td>'+this.sanctner+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="10">조회결과가 없습니다</td></tr>';
				
				$('#result').html(html);
				$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo+'/'+res.vo.totalPage+' 페이지 ');
				cwmaList.setPage(res.vo);
			}
		});
	}
	
	//대리결재 리스트
	var searchMember = function(){
		if($.trim($('#siFrm [name=agncyNm]').val()) == ""){
			alert('상세권한명을 입력하여 주십시오.');
			return;
		}
		$('#siFrm').attr('action', 'selectAgncyMember.do');
		$('#siFrm [name=se]').val('search');
		$('#siFrm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '    <td><input type="radio" id="rad201" name="cAgncyId" value="'+this.userId+'"> <label for="rad201"></label></td>';
					html += '    <td>'+this.brffcNm+'</td>';
					html += '    <td>'+this.userName+'</td>';
					html += '    <td>'+this.email+'</td>';
					html += '    <td>';
					html += '            <div class="input_date">';
					html += '                <input type="text" style="width: 105px;" class="datepicker" name="cBgnde">';
					html += '                <button type="button" href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></button>';
					html += '            </div>';
					html += '            <span class="fuhao">~</span>';
					html += '            <div class="input_date">';
					html += '                <input type="text" style="width: 105px;" class="datepicker" name="cEndde">';
					html += '                <button type="button"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></button>';
					html += '            </div>';
					html += '    </td>';
					html += '</tr>';
				});
				
				$('#searchMember').html(html);
				
				initDatapicker();
			}
		});
	};
	
	//대리결재 리스트
	var agncyMember = function(){
		$('#siFrm').attr('action', 'selectAgncyMember.do');
		$('#siFrm [name=se]').val('');
		$('#siFrm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += this.brffcNm  + ' | ' + this.userName + ' | ' + this.bgnde + ' ~ ' + this.endde;
					html += '<button type="button" onclick="javascript:remove(' + this.agncyNo + ');" class="btn normal black ml20"> <i class="fas fa-power-off mr5"></i> 취소</button>';
				});
				
				$('#subSanctner').html(html);
			}
		});
	};
	
	var initDatapicker = function(){
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
	    
	    $('.datepicker').next().click(function(e){
	    	$(this).prev().focus();
	    	e.preventDefault();
	    	return false;
	    });
	}
	
	var regist = function(){
		$('#searchMember [name=cAgncyId]').each(function(){
			console.log($(this).is(":checked"));
			if($(this).is(":checked")){
				$('#siFrm [name=agncyId]').val($(this).val());
				if($.trim($(this).parents('tr').find('[name=cBgnde]').val()) != ""){
					$('#siFrm [name=bgnde]').val($.trim($(this).parents('tr').find('[name=cBgnde]').val()));
				}else{
					alert('대리결재 시작일을 입력하여 주십시오.');
					return;
				}
				if($.trim($(this).parents('tr').find('[name=cEndde]').val()) != ""){
					$('#siFrm [name=endde]').val($.trim($(this).parents('tr').find('[name=cEndde]').val()));
				}else{
					alert('대리결재 종료일을 입력하여 주십시오.');
					return;
				}
				agncy();
				return;
			}			
		});
	}
	
	var remove = function(str){
		if(confirm('대리결재자를 삭제하시겠습니까?')){
			$('[name=agncyNo]').val(str);
			agncy();
		}
	}
	
	//리스트조회 함수
	var agncy = function(){
		$('#siFrm').attr('action', 'agncy.do');
		$('#siFrm').ajaxCwma({
			success:function(res){
				alert('처리 되었습니다');
				$('#frm').attr('action', 'list.do');
				$('#frm').attr('method', 'GET');
				$('#frm').submit();
			}
		});
	}
	
	var goArpv = function(str){
		if(!$('#result [name=docNoList]:checked').size()){
			alert('일괄 처리 할 기안을 선택하여 주십시오.');
			return;
		}
		
		if(confirm((str == '5'?'결재기안':'일괄반려') + '하시겠습니까?')){
			$('#progrs input').remove();
			$('#result [name=docNoList]:checked').each(function(i){
				$('#progrs').append('<input type="hidden" name="sanctnVO['+i+'].sanctnSttus" value="APRV000'+str+'">');
				$('#progrs').append('<input type="hidden" name="sanctnVO['+i+'].docNo" value="'+$(this).val()+'">');
				$('#progrs').append('<input type="hidden" name="sanctnVO['+i+'].sanctnKnd" value="'+$(this).data('knd')+'">');
			});
			
			$('#progrs').ajaxCwma({
				success:function(res){
					alert('처리 되었습니다');
					$('#frm').attr('action', 'list.do');
					$('#frm').attr('method', 'GET');
					$('#frm').submit();
				}
			});
		}
	}
</script>
</head>
<body>
	<form id="progrs" action="progrsList.do" method="post" >
	</form>
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<input type="hidden" name="numOfPage" value="20" />
			<input type="hidden" name="sanctnList" value="WAIT" />
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">서비스구분</th>
						<td colspan="3">
							<input type="radio" id="rad101" name="se" value="" checked> <label for="rad101">전체</label>
							<input type="radio" id="rad104" name="se" value="ARCS0002"> <label for="rad104">기능등급증명서 발급신청</label>
							<input type="radio" id="rad102" name="se" value="CASE0001"> <label for="rad102">경력인정신청</label>
							<input type="radio" id="rad103" name="se" value="CASE0002"> <label for="rad103">근로직종확인신청</label>
							<input type="radio" id="rad106" name="se" value="ARCS0005"> <label for="rad106">보유증명서 발급신청</label>
						</td>
					</tr>
					<tr>
						<th scope="row">기안일</th>
						<td colspan="3">
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="bgnDrftDe">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="시작기안일" /></a>
							</div>
							<span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="endDrftDe">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="종료기안일" /></a>
							</div>
							<button type="button" onClick="dateInput('1', 'DrftDe');" class="btn btn_form ml10">오늘</button>
							<button type="button" onClick="dateInput('2', 'DrftDe');" class="btn btn_form ml10">어제</button> 
							<button type="button" onClick="dateInput('3', 'DrftDe');" class="btn btn_form ml10">1주</button>
							<button type="button" onClick="dateInput('4', 'DrftDe');" class="btn btn_form ml10">1개월</button>
							<button type="button" onClick="dateInput('5', 'DrftDe');" class="btn btn_form ml10">2개월</button>
							<button type="button" onClick="dateInput('6', 'DrftDe');" class="btn btn_form ml10">당해년도</button>
							<button type="button" onClick="dateInput('7', 'DrftDe');" class="btn btn_form ml10">전체</button>
						</td>
					</tr>
					<tr>
						<th scope="row">기안자</th>
						<td>
							<input type="text" class="w100p" name="drfter" />
						</td>
						<th scope="row">지사/센터</th>
						<td>
							<c:if test='${"01100" eq adminLoginInfo.ddcAstcCd }'>
							<select class="w50p" name="chrgBrffc">
								<option value="">전체</option>
								<c:forEach var="ddcAsctList" items="${ddcAsctList }" varStatus="sts">
								<option value="${ddcAsctList.ddcAsctCd }">${ddcAsctList.brffcNm }</option>
								</c:forEach>
							</select>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">신청자</th>
						<td>
							<input type="text" class="w100p" name="nm" />
						</td>
						<th scope="row">주민등록번호</th>
						<td>
							<input type="text" class="w40p" name="jumin1" maxlength="6" number />
							-
							<input type="text" class="w40p" name="jumin2" maxlength="7" number />
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
					<button type="button" id="btnSearch" class="btn btn_search mr10"> <i class="fas fa-search mr5"></i> 조회</button>
					<button type="reset" class="btn normal grey"> <i class="far fa-sticky-note mr5"></i>  초기화</button>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 ${vo.totalCnt} 건 | ${vo.pageNo}/${vo.totalPage} 페이지 </span>
			<div class="fr txt_right">
              	<button type="button" onclick="javascript:goArpv('5');" class="btn normal darkolivegreen mr10"> <i class="fas fa-sign-in-alt mr5"></i> 일괄승인</button>
              	<button type="button" onclick="javascript:goArpv('6');" class="btn normal darkolivegreen mr10"> <i class="fas fa-sign-out-alt mr5"></i> 일괄반려</button>
              	<button type="button" class="btn normal green mr10 btnExcelForm"> <i class="far fa-file-excel mr5"></i> 엑셀다운로드</button>
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
                <col width="7%" />
                <col width="11%" />
                <col width="11%" />
                <col width="11%" />
                <col width="11%" />
                <col width="11%" />
                <col width="11%" />
                <col width="11%" />
                <col width="11%" />
			</colgroup>
			<thead>
				<tr>
				    <th scope="col" rowspan="2"><span><input type="checkbox" id="chkAll" value="0"> <label for="chkAll"></label></span></th>
				    <th scope="col" rowspan="2"><span>상태</span></th>
					<th scope="col" colspan="4"><span>민원</span></th>
					<th scope="col" colspan="5"><span>기안</span></th>
				</tr>
				<tr>
					<th scope="col"><span>구분</span></th>
					<th scope="col"><span>접수일</span></th>
					<th scope="col"><span>접수번호</span></th>
					<th scope="col"><span>신청자</span></th>
					<th scope="col"><span>기안일</span></th>
					<th scope="col"><span>관할지사</span></th>
					<th scope="col"><span>기안자</span></th>
					<th scope="col"><span>결재자</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		<div class="paging">
		</div>
		<div class="search_wrap">
            <form id="diFrm" action="#">
                <table class="tbl tbl_search">
                    <colgroup>
                        <col style="width: 10%;" />
                        <col style="width: 90%;" />
                    </colgroup>
                    <tbody>
                     <tr>
                         <th scope="row" colspan="2" class="fs16">대리결재</th>
                     </tr>
                     <tr>
                         <td class="p10">
                     		<button type="button" onclick="javascript:goApp();" class="btn normal wood mr10"> <i class="fas fa-cog mr5"></i> 결재설정</button>
                         </td>
                         <td id="subSanctner">
                         	현재 설정된 대리결재자가 없습니다.
<!--                          	본회 l 강명근 l 2020-09-22(화) ~ 2020-10-21(수) -->
<!--                   			<a href="javascript:void();" class="btn normal black ml20"> <i class="fas fa-power-off mr5"></i> 취소</a> -->
                         	
                         </td>
                     </tr>
                    </tbody>
                </table>
            </form>
        </div>
	</div>
	
	<div id="mask"></div>
        <div id="layerbox" class="layerpop" style="width: 800px; height: 570px; display: none;">
	        <div class="layerpop_area">
	        
	        	<div class="title">대리결재 설정</div>
	        	<button type="button" onclick="javascript:popupClose();" class="layerpop_close" id="layerbox_close"><i class="far fa-window-close"></i></button> 
	      		
				
		        <div class="pop_content">
		        	<div class="search_wrap">
		        		<form id="siFrm" method="post" onsubmit="return false;">
						<input type="hidden" name="se" value="search" >
						<input type="hidden" name="bgnde" value="" >
						<input type="hidden" name="endde" value="" >
						<input type="hidden" name="agncyId" value="" >
						<input type="hidden" name="agncyNo" value="" >
						<table class="tbl tbl_form">
                            <colgroup>
                                <col width="20%" />
                                <col width="80%" />
                            </colgroup>
                            <tbody>
	                            <tr>
	                                <th scope="row">결재자 성명</th>
	                                <td>		                                	
	                                	<input type="text" class="w100p" maxlength="30" name="agncyNm"/>
	                                </td>
	                            </tr>
                            </tbody>
                        </table>
						<div class="btn_wrap txt_center mt10">
							<button type="button" id="mSearch" class="btn normal black"> <i class="fas fa-search mr5"></i> 조회</button>
						</div>
                        </form>
					</div>
		        	<div class="data_wrap">
						<table class="tbl tbl_data">
                            <colgroup>
                                <col width="5%" />
                                <col width="15%" />
                                <col width="15%" />
                                <col width="20%" />
                                <col width="" />
                            </colgroup>
		                    <thead>
	                            <tr>
	                                <th scope="col"><span>선택</span></th>
	                                <th scope="col"><span>지사/센터</span></th>
	                                <th scope="col"><span>성명</span></th>
	                                <th scope="col"><span>연락처</span></th>
									<th scope="col"><span>대리결재기간</span></th>
	                        	</tr>
							</thead>
							<tbody id="searchMember">
	                            	 
                        	</tbody>
                    	</table>
					</div>
                           
    				<div class="btn_wrap mb20">
                        <div class="txt_center mt20">
                            <button type="button" onclick="javascript:regist();" class="btn normal blue mr10"> <i class="far fa-save mr5"></i> 등록</button>
                            <button type="button" onclick="javascript:popupClose();" class="btn normal black mr10"> <i class="fas fa-power-off mr5"></i> 취소</button>
                        </div>
                    </div>
		        </div>
	        </div>
    	</div>
</body>
</html>
