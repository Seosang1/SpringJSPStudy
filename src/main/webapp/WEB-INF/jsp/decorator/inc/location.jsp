<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="location_wrap">
	<div class="container">
		<div class="location_wrap-inner d-flex justify-content-between">
			
			<div class="btn-group" role="group" >
				<button type="button" class="btn btn-outline-secondary location-home" onclick="location.href='${pageContext.request.contextPath}/';"><i class="fas fa-home"></i></button>
				<div class="btn-group depth1" role="group">
					<button id="btnGroupDrop1" type="button" class="btn btn-outline-secondary dropdown-toggle location-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">건설근로자 제도안내</button>
					<div class="dropdown-menu location-dropdown-menu" aria-labelledby="btnGroupDrop1">
					</div>
				</div>
				<div class="btn-group depth2" role="group">
					<button id="btnGroupDrop2" type="button" class="btn btn-outline-secondary dropdown-toggle location-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">제도소개</button>
					<div class="dropdown-menu location-dropdown-menu" aria-labelledby="btnGroupDrop2">
					</div>
				</div>
			</div>
			
			<div class="btn-group" role="group" >
				<button type="button" class="btn btn-outline-secondary location-home" onclick="javascript:zoomIn();"><i class="fas fa-plus"></i></button>
				<button type="button" class="btn btn-outline-secondary location-home" onclick="javascript:zoomOut();"><i class="fas fa-minus" ></i></button>
				<button type="button" class="btn btn-outline-secondary location-home" onClick="window.print();"><i class="fas fa-print"></i></button>
			</div>
		</div>	
	</div>
</div>
