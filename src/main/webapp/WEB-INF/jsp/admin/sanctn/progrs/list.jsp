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
		
		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/sanctnProgrs/excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'));
			e.preventDefault();
			return false;
		});
		
		//결재/반려 클릭 이벤트 - 팝업오픈
		$('.btnPop').click(function(e){
			if(!$('#result [name="docNoList"]:checked').size()){
				alert('일괄 처리 할 기안을 선택하여 주십시오.');
				return;
			}
			
			$('#frmPop [name="sanctnSttus"]').val($(this).text().trim() == '결재기안'?'APRV0002':'APRV0003');
			$('#frmPop [name="agncyNm"]').val('');
			$('#sanctnLayer .tbl_data').parent().hide();
			$('#sanctnLayer .btn_wrap').hide();
			
			cwma.showMask();
			$('#sanctnLayer').css('height', '170px');
	        $('#sanctnLayer').css("top",(($(window).height() - $('#sanctnLayer').outerHeight()) / 2) + $(window).scrollTop());
	        $('#sanctnLayer').css("left",(($(window).width() - $('#sanctnLayer').outerWidth()) / 2) + $(window).scrollLeft());
	        
			if($('.data_wrap .layerpop')[0]){
				$('#sanctnLayer').draggable();
				$('body').append($('.data_wrap .layerpop'));
			}

			$('#sanctnLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//팝업닫기 버튼 클릭이벤트
		$('.layerpop_close, .btnClose').click(function(e){
			cwma.hideMask();
			$('#sanctnLayer').hide();
			
			e.preventDefault();
			return false;			
		});
		
		//팝업 - 검색버튼 클릭
		$('.btnAgncyMember').click(function(){
			$('#frmPop').ajaxCwma({
				success:function(res){
					var html = '';
					var height = 100;
					
					$(res.list).each(function(){
						html += '<tr>';
						html += '<td><input type="radio" name="sanctnId" value="'+this.userId+'" /></td>';
						html += '<td>'+this.brffcNm+'</td>';
						html += '<td>'+this.userName+'</td>';
						html += '<td>'+this.email+'</td>'
						html += '</tr>';
					});
					
					height = Math.min(res.list.length+1, 5) * 45 + 20;
					$('#sanctnLayer .tbl_data').parent().css('height', height+'px');
					$('#sanctnLayer').css('height', (height + 220)+'px');
			        $('#sanctnLayer').css("top",(($(window).height() - $('#sanctnLayer').outerHeight()) / 2) + $(window).scrollTop());
			        $('#sanctnLayer').css("left",(($(window).width() - $('#sanctnLayer').outerWidth()) / 2) + $(window).scrollLeft());
					
					$('#sanctnLayer .tbl_data').parent().show();
					$('#sanctnLayer .btn_wrap').show();
					$('#memberResult').html(html);
				}
			});
		});
		
		//팝업 - 엔터이벤트
		$('#frmPop').submit(function(e){
			$('.btnAgncyMember').click();
			e.preventDefault();
			return false;
		});

		//전체선택 클릭
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
		
		//결재기안버튼 클릭
		$('.btnSubmit').click(function(e){
			if(!$('[name="sanctnId"]:checked').size()){
				alert('결재자를 선택해주세요');
				return false;
			}
			
			if(confirm(($('#frmPop [name="sanctnSttus"]').val() == 'APRV0002'?'결재기안':'일괄반려') + '하시겠습니까?')){
				$('#progrs input').remove();
				$('#result [name="docNoList"]:checked').each(function(i){
					$('#progrs').append('<input type="hidden" name="sanctnVO['+i+'].sanctnId" value="'+$('#sanctnLayer [name="sanctnId"]:checked').val()+'">');
					$('#progrs').append('<input type="hidden" name="sanctnVO['+i+'].sanctnSttus" value="'+$('#frmPop [name="sanctnSttus"]').val()+'">');
					$('#progrs').append('<input type="hidden" name="sanctnVO['+i+'].docNo" value="'+$(this).val()+'">');
					$('#progrs').append('<input type="hidden" name="sanctnVO['+i+'].sanctnKnd" value="'+$(this).data('knd')+'">');
				});
				
				$('#progrs').ajaxCwma({
					success:function(res){
						alert('처리 되었습니다');
						$('.btnClose').click();
						$('#btnSearch').click();
					}
				});
			}
			
			e.preventDefault();
			return false;
		});
		
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
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'list.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					if("APRV0001,APRV0004".indexOf(this.sanctnSttus) > -1)
					html += '	<td><input type="checkbox" name="docNoList" data-knd="'+this.sanctnKnd+'" value="'+this.careerNo+'"> <label for="aa"></label></td>';
					else
					html += '	<td>&nbsp;</td>';
					html += '	<td>'+this.seNm+'</td>';
					html += '	<td>'+this.progrsSttus+'</td>';
					html += '	<td>'+(this.rceptDe?this.rceptDe:'')+'</td>';
					html += '	<td class="btnView" data-sn="'+this.careerNo+'" data-knd="'+this.sanctnKnd+'">'+(this.rceptNo?this.rceptNo:'')+'</td>';
					html += '	<td class="btnView" data-sn="'+this.careerNo+'" data-knd="'+this.sanctnKnd+'">'+this.nm+'</td>';
					html += '	<td>'+(this.draftDe?this.draftDe:'')+'</td>';
					html += '	<td>'+this.chrgBrffcNm+'</td>';
					html += '	<td>'+(this.drafter?this.drafter:'')+'</td>';
					html += '	<td>'+(this.sanctner?this.sanctner:'')+'</td>';
					html += '	<td>'+this.sanctnSttusNm+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="12">조회결과가 없습니다</td></tr>';
				
				$('#result').html(html);
				$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo+'/'+res.vo.totalPage+' 페이지 ');
				cwmaList.setPage(res.vo);
			}
		});
	};
</script>
</head>
<body>
	<form id="progrs" action="progrsList.do" method="post">
	</form>
	
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<input type="hidden" name="numOfPage" value="20" />
			<input type="hidden" name="sanctnList" value="PROGRS" />
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
							<input type="radio" id="rad101" name="se" value="" ${empty param.se?'checked':''}> <label for="rad101">전체</label>
							<input type="radio" id="rad104" name="se" value="ARCS0002" ${param.se eq 'ARCS0002'?'checked':''}> <label for="rad104">기능등급증명서 발급신청</label>
							<input type="radio" id="rad102" name="se" value="CASE0001" ${param.se eq 'CASE0001'?'checked':''}> <label for="rad102">경력인정신청</label>
							<input type="radio" id="rad103" name="se" value="CASE0002" ${param.se eq 'CASE0002'?'checked':''}> <label for="rad103">근로직종확인신청</label>
							<input type="radio" id="rad106" name="se" value="ARCS0005" ${param.se eq 'ARCS0005'?'checked':''}> <label for="rad106">보유증명서 발급신청</label>
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
					<tr>
						<th scope="row">결재상태</th>
						<td colspan="3">
							<input type="radio" id="rad201" value="" name="sanctnSttus" checked> <label for="rad201">전체</label>
							<input type="radio" id="rad202" value="APRV0002" name="sanctnSttus"> <label for="rad202">진행중</label>
							<input type="radio" id="rad203" value="APRV0004" name="sanctnSttus"> <label for="rad203">회수</label>
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
				<button type="button" class="btn normal darkolivegreen mr10 btnPop"> <i class="fas fa-sign-in-alt mr5"></i> 결재기안</button>
              	<button type="button" class="btn normal darkolivegreen mr10 btnPop"> <i class="fas fa-sign-out-alt mr5"></i> 일괄반려</button>
				<button type="button" class="btn normal green mr10 btnExcelForm"> <i class="far fa-file-excel mr5"></i> 엑셀다운로드</button>
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="8%" />
				<col width="10%" />
				<col width="9%" />
				<col width="8%" />
				<col width="8%" />
				<col width="10%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col" rowspan="2"><span><input type="checkbox" id="chkAll" value="0"> <label for="chkAll"></label></span></th>
					<th scope="col" colspan="4"><span>민원</span></th>
					<th scope="col" colspan="6"><span>기안</span></th>
				</tr>
				<tr>
					<th scope="col"><span>구분</span></th>
					<th scope="col"><span>처리상태</span></th>
					<th scope="col"><span>접수일</span></th>
					<th scope="col"><span>접수번호</span></th>
					<th scope="col"><span>신청자</span></th>
					<th scope="col"><span>기안일</span></th>
					<th scope="col"><span>관할지사</span></th>
					<th scope="col"><span>기안자</span></th>
					<th scope="col"><span>결재자</span></th>
					<th scope="col"><span>결재상태</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		<div class="paging">
		</div>
		
		<div id="sanctnLayer" class="layerpop" style="width: 500px; height: 350px; display: none; position:absolute; z-index:99999">
			<div class="layerpop_area">
				<div class="title">결재자 선택</div>
				<a href="#" class="layerpop_close">
					<i class="far fa-window-close"></i>
				</a>
	
				<div class="pop_content">
					<form id="frmPop" action="../sanctnWait/selectAgncyMember.do" method="post">
						<input type="hidden" name="se" value="search" />
						<input type="hidden" name="sanctnSttus" value="" />
						<table class="tbl tbl_form">
							<colgroup>
								<col width="25%">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">결재자 성명</th>
									<td><input type="text" class="w100p" maxlength="30" title="결재자 성명" name="agncyNm" required></td>
								</tr>
							</tbody>
						</table>
						<div class="mt10 txt_center">
							<button type="button" class="btn normal blue btnAgncyMember">조회</button>
						</div>
					</form>
					
					<div style="height:100px;overflow-y: auto;">
						<table class="tbl tbl_data">
							<colgroup>
								<col style="width:10%">
								<col style="width:30%">
								<col>
								<col style="width:30%">
							</colgroup>
							<thead>
								<tr>
									<th scope="col"><span>선택</span></th>
									<th scope="col"><span>지사/센터</span></th>
									<th scope="col"><span>결재자 성명</span></th>
									<th scope="col"><span>이메일</span></th>
								</tr>
							</thead>
							<tbody id="memberResult"></tbody>
						</table>
					</div>
					
					<div class="btn_wrap mb20" style="display:none">
						<div class="txt_center mt20">
							<a href="insert.do" class="btn normal blue mr10 btnSubmit"><i class="far fa-save mr5"></i> 결재기안</a>
							<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 취소</a>
						</div>
					</div>
	
				</div>
			</div>
		</div>
	</div>
	
</body>
</html>
