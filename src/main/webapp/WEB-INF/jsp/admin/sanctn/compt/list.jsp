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
			var url, name;
			$('#sfrm input').remove();
			if("ARCS0001" == $(this).data('ty')){
				name= "careerNo"
			}else{
				name= "reqstNo"
			}
			$('#sfrm').attr('action', 'view.do');
			$('#sfrm').attr('methmod', 'post');
			$('#sfrm').append('<input type="hidden" name="'+name+'" value="'+$(this).data('sn')+'" />');
			$('#sfrm').append('<input type="hidden" name="sanctnKnd" value="'+$(this).data('ty')+'" />');
			$('#sfrm').submit();
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
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'list.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '	<td>'+this.seNm+'</td>';
					html += '	<td>'+this.rceptDe+'</td>';
					html += '	<td class="btnView" data-sn="'+this.careerNo+'" data-ty="'+this.sanctnKnd+'">'+this.rceptNo+'</td>';
					html += '	<td class="btnView" data-sn="'+this.careerNo+'" data-ty="'+this.sanctnKnd+'">'+this.nm+'</td>';
					html += '	<td>'+this.draftDe+'</td>';
					html += '	<td>'+this.chrgBrffcNm+'</td>';
					html += '	<td>'+this.drafter+'</td>';
					html += '	<td>'+this.sanctner+'</td>';
					html += '	<td>'+this.sanctnSttusNm+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="9">조회결과가 없습니다</td></tr>';
				
				$('#result').html(html);
				$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo+'/'+res.vo.totalPage+' 페이지 ');
				cwmaList.setPage(res.vo);
			}
		});
	};
</script>
</head>
<body>
	<div class="search_wrap">
		<form action="" id="sfrm" method="post">
		</form>
		<form action="" id="frm" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<input type="hidden" name="numOfPage" value="20" />
			<input type="hidden" name="sanctnList" value="COMPT" />
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
							<input type="radio" id="rad105" name="se" value="ARCS0003"> <label for="rad105">발급동의신청</label>
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
<!-- 					<tr> -->
<!-- 						<th scope="row">결재상태</th> -->
<!-- 						<td colspan="3"> -->
<!-- 							<input type="radio" id="rad201" value="" name="sanctnSttus" checked> <label for="rad201">전체</label> -->
<!-- 							<input type="radio" id="rad202" value="APRV0002" name="sanctnSttus"> <label for="rad202">진행중</label> -->
<!-- 							<input type="radio" id="rad203" value="APRV0003" name="sanctnSttus"> <label for="rad203">회수</label> -->
<!-- 						</td> -->
<!-- 					</tr> -->
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
				<button type="button" class="btn normal green mr10 btnExcelForm"> <i class="far fa-file-excel mr5"></i> 엑셀다운로드</button>
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="13%" />
				<col width="12%" />
				<col width="13%" />
				<col width="12%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
			</colgroup>
			<thead>
				<tr>
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
					<th scope="col"><span>결재상태</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		<div class="paging">
		</div>
	</div>
</body>
</html>
