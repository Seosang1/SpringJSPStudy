<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	
	//이벤트
	$(function(){
		
		$(document).on("keyup", ".phoneNumber", function() { 
			$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-") ); 
		});

		//등록버튼 이벤트
		$('.btnSubmit').click(function(e){
			var txt = $(this).text().trim();
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
							
					// 선택약관 동의 여부
					if($('[name="qaAgr"]:checked').val() == 'N'){
						alert('개인정보 추가 수집 및 이용에 동의해주세요.');
						return false;
					}
					
					if($('[name="cl"] option:selected').val() == ''){
						alert('유형을 선택해주세요');
						return false;
					}
					
					return confirm('등록하시겠습니까?');
					
				}, success:function(res){
					alert('등록되었습니다');
					location.href="${pageContext.request.contextPath}/index.do";
				}
			});
			e.preventDefault();
			return false;
		});
		
		$('.divMobileNum .active').click();
	});
</script>
</head>
<body>
<form id="frm" action="qnaInsert.do" method="post" enctype="multipart/form-data">
<div id="wrap">
	<div id="contents">

		<div id="subTop" class="bg06">
			<div class="container">
				<h2 class="subTitle">중독상담</h2>
			</div>
			<div class="subNav">
				<div class="container">
					<ul>
						<li>홈</li>
						<li>중독상담</li>
						<li>1:1 문의하기</li>
					</ul>
				</div>
			</div>
		</div><!-- subTop -->
		
		<div id="subCont">
			<div class="container">

				<h4 class="subName">1:1 문의하기</h4>
				
					<div class="qaForm">
						<div class="qaRow">
							<div class="qaCol col1">
								<label for="qaName">이름</label>
								<input type="text" name="rgstNm" id="rgstNm" placeholder="이름을 입력해주세요" title="이름" required maxlength="10"/>
							</div>
						</div><!-- qaRow -->
						<div class="qaRow">
							<div class="qaCol col1">
								<label for="qaPhone">휴대폰</label>
								<input type="text" class="phoneNumber" name="mbtlnum" id="mbtlnum" placeholder="휴대폰번호를 입력해주세요" title="휴대폰" required maxlength="13"/>
							</div>
							<div class="qaCol col1">
								<label for="qaTel">전화번호</label>
								<input type="text" class="phoneNumber" name="callNumber" id="callNumber" placeholder="전화번호를 입력해주세요" title="전화번호" required maxlength="13"/>
							</div>
							<div class="qaCol col1">
								<label for="qaMail">이메일주소</label>
								<input type="text" name="email" id="email" placeholder="이메일을 입력해주세요" title="이메일주소" required maxlength="30"/>
							</div>
						</div><!-- qaRow -->
						<div class="qaRow">
							<div class="qaCol col1">
								<label for="qaCate">문의분류</label>
								<select name="cl" id="cl">
									<option value="">분류를 선택해주세요</option>
									<option value="1">분류1</option>
								</select>
							</div>
						</div><!-- qaRow -->
						<div class="qaRow">
							<div class="qaCol co3">
								<label for="qaTitle">문의제목</label>
								<input type="text" name="sj" id="sj" placeholder="문의제목을 입력해주세요" title="제목" required/>
							</div>
						</div><!-- qaRow -->
						<div class="qaRow">
							<div class="qaCol col3 qaText">
								<label for="qaText">문의내용</label>
								<textarea name="cn" id="cn" cols="30" rows="10" placeholder="내용을 입력해주세요" title="내용" required></textarea>
							</div>
						</div><!-- qaRow -->
					</div><!-- qaForm -->

					<div class="qaInfo">
						<h4>개인정보 수집·이용에 대한 안내</h4>
						<h5>(필수) 개인정보 수집·이용에 대한 안내</h5>
						<p>고려대학교안암병원 서울시 독성물질 중독관리센터"는 이용자 문의를 처리하기 위해 다음과 같이 개인정보를 수집 및 이용하며, 이용자의 개인정보를 안전하게 취급하는데 최선을 다하고 있습니다.</p>
						<table class="subTb">
							<caption>개인정보 수집·이용에 대한 안내 수집항목, 수집목적, 보유기간</caption>
							<thead>
								<tr>
									<th>수집항목</th>
									<th>수집목적</th>
									<th>보유기간</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>이메일 주소, 휴대폰 번호</td>
									<td>문의・요청・불편사항 확인 및 처리결과 회신</td>
									<td>1년간 보관 후 지체없이 파기</td>
								</tr>
							</tbody>
						</table>
						<p>
							위 동의를 거부 할 권리가 있으며, 동의를 거부하실 경우 문의 처리 및 결과 회신이 제한됩니다.<br/>
							더 자세한 내용에 대해서는 "고려대학교안암병원 서울시 독성물질 중독관리센터" 개인정보처리방침을 참고하시기 바랍니다.
						</p>
					</div>

					<ul class="qaAgr">
						<li><input type="radio" name="qaAgr" id="qaAgr01" checked value="Y"/><label for="qaAgr01">위 내용에 동의합니다.</label></li>
						<li><input type="radio" name="qaAgr" id="qaAgr02" value="N"/><label for="qaAgr02">위 내용에 동의하지 않습니다.</label></li>
					</ul>

					<ul class="qaBtn">
						<li><a href="${pageContext.request.contextPath}/index.do">메인으로</a></li>
						<li><a href="#" class="btnSubmit">신청하기</a></li>
					</ul>
				


			</div><!-- container -->
		</div><!-- subCont -->



	</div><!-- contents -->
</div>
</form>
</body>
</html>
