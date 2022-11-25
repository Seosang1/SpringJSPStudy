<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="isFirst" value="Y" />
<c:set var="upperMenuSn" value="" />

<div id="head">
	<div class="util_wrap">
		<div class="container">
 			<a href="${pageContext.request.contextPath}/admin/index.do" class="logo">
				<img src="${pageContext.request.contextPath}/static/skill/img/common/gnb_logo.png" alt="서울시 독성물질 중독관리센터">
			</a>
			<ul class="util">
				<li>
					<button type="button" class="btn small red">연장</button>
				</li>
				<li style="margin-left: 5px !important;">
					<i class="far fa-clock mr5"></i>로그인 유지시간 :
					<span style="color:#EC0003; font-weight: 600">20:00</span>
				</li>
			<c:forEach var="eo" items="${adminMenuList}" varStatus="sts">
				<c:if test="${eo.depth eq 1}">
					<li id="gnb_m${eo.menuSn }">
						<a href="${pageContext.request.contextPath}${empty eo.url?'#':eo.url }" title="${eo.menuNm}">
							<i class="fas ${eo.css } mr5"></i>
							${eo.menuNm }
						</a>
					</li>
				</c:if>
			</c:forEach>
			</ul>
		</div>
	</div>
	<div class="gnb_wrap" style="display: none;">
		<div class="container">
			<ul class="gnb">
			<c:forEach var="eo" items="${adminMenuList}" varStatus="sts">
				<c:if test="${eo.depth eq 2}">
					<li id="gnb_m${eo.menuSn }">
						<a href="${pageContext.request.contextPath}${empty eo.url?'#':eo.url }" title="${eo.menuNm}" name="topMenu">
							<i class="fas ${eo.css } mr5"></i>
							${eo.menuNm }
						</a>
					</li>
				</c:if>
			</c:forEach>
			</ul>
		</div>
	</div>
	<div class="gnb_sub_wrap">
		<div class="container">
		<c:forEach var="eo" items="${adminMenuList}">
			<c:if test="${eo.depth > 2}">
				<c:if test="${upperMenuSn ne eo.upperMenuSn}">
					<c:if test="${isFirst eq 'N'}">
						</ul>
					</c:if>
					<c:set var="upperMenuSn" value="${eo.upperMenuSn}" />
					<c:set var="isFirst" value="N" />
					<ul id="sub_m${eo.upperMenuSn }" class="gnb_sub">
				</c:if>
				<li data-sn="${eo.menuSn }">
					<a href="${pageContext.request.contextPath}${empty eo.url?'#':eo.url}" title="${eo.menuNm}">
						<i class="fab fa-wpforms mr5"></i>
						${eo.menuNm}
					</a>
				</li>
			</c:if>
		</c:forEach>
		<c:if test="${isFirst eq 'N'}">
			</ul>
		</c:if>
		</div>
		<div id="hiddenMenu" style="display:none">
		<c:forEach var="eo" items="${adminGrantList}">
			<c:if test="${eo.depth > 2 and eo.displayAt eq 'N'}">
				<li style="display:none;" data-upper="${eo.upperMenuSn}">
					<a href="${pageContext.request.contextPath}${empty eo.url?'#':eo.url}" title="${eo.menuNm}">
						${eo.menuNm}
					</a>
				</li>
			</c:if>
		</c:forEach>
		</div>		
	</div>
</div>