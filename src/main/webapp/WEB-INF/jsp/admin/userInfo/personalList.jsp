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
		cwmaList = new cwma.list({pageLayer:$('.paging')});
		
		//검색버튼 클릭이벤트
		$('.btn_search').click(function(e){
			$('#frm').attr('action', 'list.do');
			ajaxList(1);
			e.preventDefault();
			return false;
		});
		
		//초기화버튼 클릭이벤트
		$('.btnReset').click(function(){
			$('#frm')[0].reset();
			e.preventDefault();
			return false;
		});
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(e){
			$('#frm').attr('action', 'personalForm.do');
			$('#frm').append('<input type="hidden" name="ihidnum" value="'+$(this).data('sn')+'" />');
			$('#frm').submit();
			e.preventDefault();
			return false;
		});
		
		//엔터이벤트
		$('#frm input').keyup(function(e){
			if(e.keyCode == 13){
				$('.btn_search').click();
				e.preventDefault();
			}
			return false;
		});
		
		//가입일자설정버튼 클릭이벤트
		$('.btn_form').click(function(){
			var date = new Date();
			var val = Number($(this).data('date'))
			if(val<365)
				date.add(val*-1);
			
			else if(val == 365){
				date.setMonth('00');
				date.setDate('01');
				
			}
			
			$('[name="bgnDt"]').val($.datepicker.formatDate('yy-mm-dd', date));
			$('[name="endDt"]').val($.datepicker.formatDate('yy-mm-dd', new Date()));
			
			if(val == 3650){
				$('[name="bgnDt"]').val('');
				$('[name="endDt"]').val('');				
			}

		});
		
		//탭 클릭이벤트
		$('.tab200 li').click(function(){
			$('.tab200 li').removeClass('on');
			$(this).addClass('on');
			$('[name="sttus"]').val($(this).data('sttus'));
			$('.btn_search').click();
		});
		
		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/userInfo/excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), true);
			e.preventDefault();
			return false;
		});
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'list.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			beforeSubmit:function(){
				if(!$('#frm :text').get().map(function(o){return o.value}).join('')){
					alert('검색어를 입력해주세요');
					return false;
				}
				
				if($('#frm [name="ihidnum1"]').val() || $('#frm [name="ihidnum2"]').val()){
					if(($('#frm [name="ihidnum1"]').val()+$('#frm [name="ihidnum2"]').val()).length < 13){
						if($('#frm [name="ihidnum1"]').val().length < 6){
							alert('주민번호를 앞자리를 입력해주세요');
							$('#frm [name="ihidnum1"]').focus();
							return false;
							
						}else if($('#frm [name="ihidnum2"]').val().length < 7){
							alert('주민번호를 뒷자리를 입력해주세요');
							$('#frm [name="ihidnum2"]').focus();
							return false;
						}
					}
				}
			},
			success:function(res){
				var html = '';
				
				if(res.vo.totalCnt == 1){
					$('#frm').attr('action', 'personalForm.do');
					$('#frm').append('<input type="hidden" name="ihidnum" value="'+res.list[0].ihidnum+'" />');
					$('#frm').submit();
					return false;
				}
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '<td>'+((res.vo.pageNo-1)*res.vo.numOfPage+this.rownum)+'</td>';
					html += '<td class="txt_left pl20"><a href="#" class="btnView" data-sn="'+this.ihidnum+'">'+this.nm+'</a></td>';
					html += '<td>'+this.gradNm+'</td>';
					html += '<td>'+this.jssfcNm+'</td>';
					html += '<td>'+(this.workDaycnt+(this.etcWorkDaycnt/2))+'</td>';
					html += '<td>'+this.ihidnum.substring(0,8)+'******'+'</td>';
					html += '<td>'+this.telno+'</td>';
					html += '<td>'+(this.userInfoVO?this.userInfoVO.userId:'')+'</td>';
					html += '<td>'+(this.userInfoVO?this.userInfoVO.rgstDt.formatDate():'')+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					alert('근로자 데이터가 존재하지 않습니다.');
				
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
			<input type="hidden" name="sttus" value="USST0001" />
			<input type="hidden" name="se" value="USSE0001" />
			
			<ul class="tab200" style="display:none">
				<li data-sttus="USST0001">개인회원</li>
				<li data-sttus="USST0003">탈퇴회원</li>
			</ul>

			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">주민등록번호</th>
						<td>
							<input type="text" class="w40p" name="ihidnum1" maxlength="6" hasnext number title="주민번호 앞자리" /> - 
							<input type="text" class="w40p" name="ihidnum2" maxlength="7" number title="주민번호 뒷자리" />
						</td>
						<th scope="row">아이디</th>
						<td><input type="text" class="w100p" name="userId" /></td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="#" class="btn btn_search mr10"><i class="fas fa-search mr5"></i> 조회</a>
				<a href="#" class="btn normal grey btnReset"><i class="far fa-sticky-note mr5"></i> 초기화</a>
			</div>
		</form>
	</div>

	<div class="data_wrap" style="display:none">
		<div class="top_wrap">
			<span class="total"> 전체 0 건 | 1/1 페이지 </span>
			<div class="fr txt_right">
				<a href="#" class="btn normal green mr10 btnExcelForm"><i class="far fa-file-excel mr5"></i> 엑셀다운로드</a>
			</div>
		</div>
		
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="15%" />
				<col width="15%" />
				<col width="10%" />
				<col width="15%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col"><span>성명</span></th>
					<th scope="col"><span>등급</span></th>
					<th scope="col"><span>직종</span></th>
					<th scope="col"><span>환산근로일</span></th>
					<th scope="col"><span>주민등록번호</span></th>
					<th scope="col"><span>휴대폰번호</span></th>
					<th scope="col"><span>회원아이디</span></th>
					<th scope="col"><span>가입일</span></th>
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
