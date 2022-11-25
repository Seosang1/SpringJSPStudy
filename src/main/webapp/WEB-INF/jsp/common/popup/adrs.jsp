<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>서울시 독성물질 중독관리센터</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">

<!-- 퍼블영역 -->
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/static/admin/css/style.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery-ui-1.12.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/fancytree/jquery.fancytree-all.js"></script>
<!-- //퍼블영역 -->

<!-- 개발영역 -->
<script type="text/javascript">
	var contextPath = '${pageContext.request.contextPath}';
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.mask.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/zTree/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.form.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/common/js/cwma.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/cwma/init.js"></script>
<script type="text/javascript">
	$(function() {
		var row = $('div.result tbody tr');
		var resizeDone = 0;

		if (7 <= row.length) {
			//row.eq(row.length - 1).children('td').css('border-bottom-width', 0);
		}
		
		$('[name="keyword"]').keyup(function(e){
			if(e.keyCode == 13)
				$('#btnSearch').click();
			
			e.preventDefault();
			return false;
		});
		
		$('.paging').on('click', 'a', function(){
			$('[name="currentPage"]').val($(this).data('page'));
			$('#btnSearch').click();
		});
		
		$('#btnSearch').click(function(e){
			$('[name="frm"]').ajaxCwma({
				dataType:"jsonp",
				success:function(data){
					if(data.results.common.errorCode == '0'){
						var page = data.results.common;
						var numOfPageGrp = Number($('[name="numOfPageGrp"]').val());
						var endPage = Math.ceil(page.currentPage/numOfPageGrp)*numOfPageGrp;
						var startPage = endPage - (numOfPageGrp-1);
						var totalPage = Math.ceil(page.totalCount / page.countPerPage);
						var prevPage = startPage-1;
						var nextPage = endPage+1;
						var str = '', pageStr = ''; 
						
						endPage = endPage>totalPage?totalPage:endPage;
						endPage = endPage<1?1:endPage;
						startPage = startPage<1?1:startPage;
						prevPage = prevPage<1?1:prevPage;
						nextPage = nextPage>totalPage?totalPage:nextPage;
						
						$(data.results.juso).each(function(i){
							str += '<tr data-addr="'+this.roadAddr+'" data-zip="'+this.zipNo+'">';
							str += '	<td class="txt_left pl20"><div>[ 도로명 ]</div><div>[ 지번 ]</div></td>';
							str += '	<td class="txt_left pl20">';
							str += '		<div>'+this.roadAddr+'</div>';
							str += '		<div>'+this.jibunAddr+'</div>';
							str += '	</td>';
							str += '	<td>'+this.zipNo+'</td>';
							str += '</tr>';
						});
						
						
						pageStr = '<a href="#" title="처음" data-page="1" class="first">First</a>';
						pageStr += '<a href="#" title="이전" data-page="'+prevPage+'" class="prev">Prev</a>';
						for(var i=startPage;i<=endPage;i++){
							pageStr += '<a href="#" data-page="'+i+'">';
							pageStr += (i==page.currentPage?'<strong>':'') + i + (i==page.currentPage?'</strong>':'');
							pageStr += '</a>';
						}
						pageStr += '<a href="#" title="다음" data-page="'+nextPage+'" class="next">Next</a>';
						pageStr += '<a href="#" title="마지막" data-page="'+totalPage+'" class="last">Last</a>';
						
						$('.address').html(str);
						$('.paging').html(pageStr);
						$('.searchAddress').hide();
						$('.address').show();
						$('.paging').show();
							
					}else{
						$('.address').hide();
						$('.paging').hide();
						$('.tableHeadNote').hide();
						$('.dataInput').hide();
						$('.blue').hide();
						$('.searchAddress').text(data.results.common.errorMessage);
						$('.searchAddress').show();
					}
					
			    }
			});
			
			e.preventDefault();
			return false;
		});
		
		$('.address').on('click', 'tr', function(){
			$('.dataInput tr:eq(1) td:eq(0)').text($(this).data('addr'));
			$('.dataInput tr:eq(1) td:eq(0)').data('zip', $(this).data('zip'));
			$('.tableHeadNote').show();
			$('.dataInput').show();
			$('.blue').show();
			if(resizeDone != 1){
				window.resizeBy(0, 199);
				resizeDone = 1;
			}
			
			$('[name="dtlAdrs"]').focus();
		});
		
		$('[name="dtlAdrs"]').keyup(function(e){
			if(e.keyCode == 13)
				$('.blue').click();
			
			e.preventDefault();
			return false;
		});
		
		$('.blue').click(function(){
			opener.window.postMessage({callback:'${param.cb}', zip:$('.dataInput tr:eq(1) td:eq(0)').data('zip'), adrs:$('.dataInput tr:eq(1) td:eq(0)').text() + ' ' + $('[name="dtlAdrs"]').val()}, '*');
			self.close();
		});
		
		$('[name="keyword"]').focus();
	});
</script>
</head>
<body>
	 <div class="layerpop_area">
        <div class="title">주소검색</div>
			 <div class="pop_content">
       			<div style="padding: 0 10px 10px 10px;">
       				찾으시려는 도로명주소+건물번호/건물명 혹은 지번주소+번지수/건물명을 입력해주세요. <Br>
					예) 도로명 : 남대문로 109 / 지번 : 다동 111 , 국제빌딩 <Br><Br>
					
					* 단, 도로명 혹은 동(읍/면/리)만 검색하시는 경우 정확한 검색결과가 나오지 않을 수 있습니다										        				
       			</div>
       			
				<div class="cont_wrap">
					<form action="//www.juso.go.kr/addrlink/addrLinkApiJsonp.do" method="post" name="frm">
						<div class="cont_wrap" style="padding: 8px 20px; border-top: 2px solid #818181; border-bottom: 2px solid #818181;">
							<input type="hidden" name="currentPage" value="1" />
							<input type="hidden" name="countPerPage" value="10" />
							<input type="hidden" name="numOfPageGrp" value="10" />
							<input type="hidden" name="resultType" value="json" />
							<input type="hidden" name="confmKey" value="<spring:eval expression="@prop.getProperty('juso.key')" />" />
							<input type="text" name="keyword" title="주소" class="w80p" data-replace="예) 남대문로 109" requered>
							<button type="submit" id="btnSearch" class="btn normal black mr10"><i class="fas fa-search"></i></button>
						</div>
					</form>

					<p class="pop_content searchAddress" style="display:none"></p>

					<div class="cont_wrap mt10" style="width:100%; height: 330px; overflow-y:auto;overflow-x:hidden;">
                    	<table class="tbl tbl_data mt0">
                            <colgroup>
                                <col width="15%" />
                                <col />
                                <col width="10%" />
                            </colgroup>
                            <tbody class="address">
                            </tbody>
						</table>
					</div>
					<div class=paging style="display: none"></div>
					
					<table class="tbl tbl_form dataInput" style="display:none">
		                <colgroup>
		                    <col width="15%" />
		                    <col width="" />
		                </colgroup>
		                <tbody>
		                <tr>
		                    <th scope="row" colspan="2">상세 주소를 추가로 입력해 주신 후 ‘확인’ 버튼을 눌러주세요.</th>
		                </tr>
		                <tr>
		                    <th scope="row">기본주소</th>
		                    <td></td>                            
		                </tr>
		                <tr>
		                    <th scope="row">상세주소</th>
		                    <td>
		                        <input type="text" class="w100p" name="dtlAdrs" title="상세주소">
		                    </td>
		                </tr>
		                </tbody>
		            </table>
				
					<div class="btn_wrap mb20">
						<div class="txt_center mt20">
							<button type="submit" class="btn normal blue mr10" style="display:none"> <i class="far fa-save mr5"></i> 확인</button>
							<button type="button" onClick="window.close()" class="btn normal black mr10"> <i class="fas fa-power-off mr5"></i> 닫기</button>
						</div>
					</div>
				</div>
			</div>
        </div>
   	</div>
</body>
</html>
