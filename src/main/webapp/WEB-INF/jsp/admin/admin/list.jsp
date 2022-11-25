<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var cwmaList;
	
	$(function(){
		
		$(document).on("keyup", ".phoneNumber", function() { 
			$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-") ); 
		});
			
		cwmaList = new cwma.list({pageLayer:$('.paging')});
		
		//검색버튼 클릭이벤트
		$('.btn_search').click(function(e){
			$('#frm').attr('action', 'list.do');
			ajaxList(1);
			e.preventDefault();
			return false;
		});
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(){
			$('#frm').attr('action', 'form.do');
			$('#frm').append('<input type="hidden" name="userId" value="'+$(this).data('seq')+'" />');
			$('#frm').submit();
		});
		
		//등록버튼 클릭 이벤트 - 팝업오픈
		$('.btnReg').click(function(e){
			$('#frmPop [name="userId"]').val('');
			$('#frmPop [name="userName"]').val('');
			$('#frmPop [name="password"]').val('');
			$('#frmPop [name="password2"]').val('');
			$('#frmPop [name="compPhoneNum"]').val('');
			$('#frmPop [name="phoneNum"]').val('');
			$('#frmPop [name="email"]').val('');
			
			$('#frmPop [name="userId"]').prop('readonly', false);
		    $('#cmmnCdLayer .blue').show();
		    $('#cmmnCdLayer .green').hide();
			
			cwma.showMask();
	        $('#cmmnCdLayer').css("top",(($(window).height() - $('#cmmnCdLayer').outerHeight()) / 2) + $(window).scrollTop());
	        $('#cmmnCdLayer').css("left",(($(window).width() - $('#cmmnCdLayer').outerWidth()) / 2) + $(window).scrollLeft());
	        
			if($('.data_wrap .layerpop')[0]){
				$('#cmmnCdLayer').draggable();
				$('body').append($('.data_wrap .layerpop'));
			}

			$('#cmmnCdLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//수정 버튼 클릭 이벤트 - 팝업오픈
		$('.btnUpd').click(function(e){
			if($('#result [name="userId"]:checked').length){
				var tr = $('#result [name="userId"]:checked').parents('tr');
				$('#frmPop [name="userId"]').val(tr.find('td:eq(3)').text());
				$('#frmPop [name="userId"]').prop('readonly', true);
				$('#frmPop [name="userName"]').val(tr.find('td:eq(4)').text());
				$('#frmPop [name="password"]').val('');
				$('#frmPop [name="password2"]').val('');
				$('#frmPop [name="compPhoneNum"]').val(tr.find('td:eq(5)').text());
				$('#frmPop [name="phoneNum"]').val(tr.find('td:eq(6)').text());
				$('#frmPop [name="email"]').val(tr.find('td:eq(7)').text());
				
				$('#cmmnCdLayer .blue').hide();
				$('#cmmnCdLayer .green').show();
			    
			}else{
			    alert('수정할 사용자를 선택해주세요');
				e.preventDefault();
				return false;			    
			}
			
			cwma.showMask();
			$('#cmmnCdLayer').css("top",(($(window).height() - $('#cmmnCdLayer').outerHeight()) / 2) + $(window).scrollTop());
			$('#cmmnCdLayer').css("left",(($(window).width() - $('#cmmnCdLayer').outerWidth()) / 2) + $(window).scrollLeft());
			
			if($('.data_wrap .layerpop')[0]){
				$('#cmmnCdLayer').draggable();
				$('body').append($('.data_wrap .layerpop'));
			}
			
	        $('#cmmnCdLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//팝업닫기 버튼 클릭이벤트
		$('.layerpop_close, .btnClose').click(function(e){
			cwma.hideMask();
			$('#cmmnCdLayer').hide();
			
			e.preventDefault();
			return false;			
		});
		
		//등록/수정버튼 이벤트 - submit
		$('.btnSubmit').click(function(e){
			if($('#frmPop [name="password"]').val() != $('#frmPop [name="password2"]').val()){
				alert("비밀번호를 확인해주세요.");
				return false;
			}
			
			if($('#frmPop [name="deptCd"]:checked').val() == null){
				alert("사용자구분을 선택해주세요.");
				return false;				
			}
			
			var txt = $(this).text().trim();
			$('#frmPop').attr('action', $(this).attr('href'));
			$('#frmPop').ajaxCwma({
				success:function(res){
					if(res.errors){
					    alert(res.errors);   
					}else{
						alert(txt+'되었습니다');
						$('.btn_search').click();
						$('.btnClose').click();
					}
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//삭제버튼 이벤트
		$('.btnDel').click(function(e){
			if($('#result [name="userId"]:checked').length){
			    $('#frmPop [name="userId"]').val($('#result [name="userId"]:checked').parents('tr').find('td:eq(3)').text());
			    
			}else{
			    alert('삭제할 사용자를 선택해주세요');
				e.preventDefault();
				return false;			    
			}
			
			if(!confirm('삭제하시겠습니까?')){
				e.preventDefault();
				return false;
			}
			
			$('#frmPop').attr('action', $(this).attr('href'));
			$('#frmPop').ajaxCwma({
				beforeValid:false,
				success:function(res){
					alert('삭제되었습니다');
					$('.btn_search').click();
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		$('#frm').submit(function(e){
			$('.btn_search').click();
			e.preventDefault();
			return false;
		});
		
		$('.btn_search').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'list.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '<td><input type="radio" name="userId" value="'+this.userId+'"></td>';
					html += '<td>'+this.rownum+'</td>';
					html += '<td>'+this.deptName+'</td>';
					html += '<td>'+this.userId+'</td>';
					html += '<td>'+this.userName+'</td>';
					html += '<td>'+this.compPhoneNum+'</td>';
					html += '<td>'+this.phoneNum+'</td>';
					html += '<td>'+this.email+'</td>';
					html += '<td>'+this.updDt.formatDate()+'</td>';
					html += '<td>'+this.rgstDt.formatDate()+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="8">조회결과가 없습니다</td></tr>';
				
				$('#result').html(html);
				$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo.formatMoney()+'/'+res.vo.totalPage.formatMoney()+' 페이지 ');
				cwmaList.setPage(res.vo);
			}
		});
	};
</script>
</head>
<body>
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<input type="hidden" name="numOfPage" value="10" />
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;">
					<col style="">
				</colgroup>
				<tbody>
					<tr>
						<td colspan="2" class="pl20">시스템에 등록되어 있는 세부사용자를 관리할 수 있습니다.</td>
					</tr>
					<tr>
						<th scope="row">검색대상</th>
						<td>
							<input type="radio" id="rad99" name="deptCd" value="" checked>
							<label for="rad99">전체</label>
								
							<c:forEach var="ceo" items="${clList}" varStatus="status">
								<input type="radio" id="rad10${status.index}" name="deptCd" value="${ceo.cdId}">
								<label for="rad10${status.index}">${ceo.cdNm}</label>
							</c:forEach>
						</td>
					</tr>
					<tr>
						<th scope="row">ID</th>
						<td>
							<input type="text" class="w10p" name="userId" title="검색어">
						</td>
					</tr>
					<tr>
						<th scope="row">휴대폰번호</th>
						<td>
 							<input type="text" class="w10p phoneNumber" name="phoneNum" title="검색어" maxlength=13>
						</td>
					</tr>
					<tr>
						<th scope="row">이름</th>
						<td>
							<input type="text" class="w10p" name="userName" title="검색어">
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="#" class="btn btn_search"><i class="fas fa-search mr5"></i>조회</a>
			</div>
		</form>
	</div>
	
	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 0 건 | 1/1 페이지 </span>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col style="width: 5%;">
				<col style="width: 5%;">
				<col style="width: 9%;">
				<col style="width: 9%;">
				<col style="width: 9%;">
				<col style="width: 9%;">
				<col style="width: 9%;">
				<col style="width: 15%;">
				<col style="width: 15%;">
				<col style="width: 15%;">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">선택</th>
					<th scope="col"><span>No</span></th>
					<th scope="col"><span>사용자구분</span></th>
					<th scope="col"><span>사용자ID</span></th>
					<th scope="col"><span>사용자명</span></th>
					<th scope="col"><span>사무실번호</span></th>
					<th scope="col"><span>휴대폰번호</span></th>
					<th scope="col"><span>이메일</span></th>
					<th scope="col"><span>암호변경일</span></th>
					<th scope="col"><span>가입일</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		
		<div class="paging">
		</div>

		<div class="fr txt_right">
			<a href="#" class="btn normal blue mr10 btnReg"><i class="far fa-save mr5"></i>등록</a>
			<a href="#" class="btn normal green mr10 btnUpd"><i class="far fa-edit mr5"></i>수정</a>
			<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i>삭제</a>
		</div>
		
		<div id="cmmnCdLayer" class="layerpop" style="width: 900px; display: none; position:absolute; z-index:99999">
			<div class="layerpop_area">
				<div class="title">사용자 등록 / 수정</div>
				<a href="#" class="layerpop_close">
					<i class="far fa-window-close"></i>
				</a>
	
				<div class="pop_content">
					<form id="frmPop" action="insert.do" method="post">
						<table class="tbl tbl_form">
							<colgroup>
								<col width="16%">
								<col width="34%">
								<col width="16%">
								<col width="34%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">사용자ID</th>
									<td><input type="text" class="w100p" maxlength="8" name="userId" title="사용자ID" required></td>
									<th scope="row">이름</th>
									<td><input type="text" class="w100p" maxlength="5" name="userName" title="이름" required></td>
								</tr>
								<tr>
									<th scope="row">비밀번호</th>
									<td><input type="password" class="w100p" maxlength="30" title="비밀번호" name="password" required></td>
									<th scope="row">비밀번호 확인</th>
									<td><input type="password" class="w100p" maxlength="30" title="비밀번호 확인" name="password2" required></td>
								</tr>
								<tr>
									<th scope="row">사무실 전화번호</th>
									<td><input type="text" class="w100p phoneNumber" maxlength="13" name="compPhoneNum" title="사무실 전화번호" required></td>
									<th scope="row">휴대폰번호</th>
									<td><input type="text" class="w100p phoneNumber" maxlength="13" name="phoneNum" title="핸드폰번호" required></td>
								</tr>
								<tr>
									<th scope="row">사용자구분</th>
									<td>
										<c:forEach var="ceo" items="${clList}" varStatus="status">
											<input type="radio" id="rad20${status.index}" name="deptCd" value="${ceo.cdId}">
											<label for="rad20${status.index}">${ceo.cdNm}</label>
										</c:forEach>
									</td>
									<th scope="row">이메일</th>
									<td><input type="text" class="w100p" maxlength="30" name="email" title="이메일" required></td>
								</tr>
							</tbody>
						</table>
					</form>
					
					<div class="btn_wrap mb20">
						<div class="txt_center mt20">
							<a href="insert.do" class="btn normal blue mr10 btnSubmit"><i class="far fa-save mr5"></i> 등록</a>
							<a href="update.do" class="btn normal green mr10 btnSubmit"><i class="far fa-edit mr5"></i> 수정</a>
							<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 취소</a>
						</div>
					</div>
	
				</div>
			</div>
		</div>
	</div>

</body>
</html>
