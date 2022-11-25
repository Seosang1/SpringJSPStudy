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
<title>S'Pay 결제 결과 페이지</title>
</head>
<body>
<h2>승인 요청 결과</h2>
<div class="wrapper">
    <div class="tab">응답 파라미터</div>
    <table>
        <tr>
            <td class="left">mchtId</td>
            <td class="right"><%= RES_PARAMS.get("mchtId") %></td>
        </tr>
        <tr>
            <td class="left">outStatCd</td>
            <td class="right"><%= RES_PARAMS.get("outStatCd") %></td>
        </tr>
        <tr>
            <td class="left">outRsltCd</td>
            <td class="right"><%= RES_PARAMS.get("outRsltCd") %></td>
        </tr>
        <tr>
            <td class="left">outRsltMsg</td>
            <td class="right"><%= RES_PARAMS.get("outRsltMsg") %></td>
        </tr>
        <tr>
            <td class="left">method</td>
            <td class="right"><%= RES_PARAMS.get("method") %></td>
        </tr>
        <tr>
            <td class="left">mchtTrdNo</td>
            <td class="right"><%= RES_PARAMS.get("mchtTrdNo") %></td>
        </tr>
        <tr>
            <td class="left">mchtCustId</td>
            <td class="right"><%= RES_PARAMS.get("mchtCustId") %></td>
        </tr>
        <tr>
            <td class="left">trdNo</td>
            <td class="right"><%= RES_PARAMS.get("trdNo") %></td>
        </tr>
        <tr>
            <td class="left">trdAmt</td>
            <td class="right"><%= RES_PARAMS.get("trdAmt") %></td>
        </tr>
        <tr>
            <td class="left">mchtParam</td>
            <td class="right"><%= RES_PARAMS.get("mchtParam") %></td>
        </tr>
        <tr>
            <td class="left">authDt</td>
            <td class="right"><%= RES_PARAMS.get("authDt") %></td>
        </tr>
        <tr>
            <td class="left">authNo</td>
            <td class="right"><%= RES_PARAMS.get("authNo") %></td>
        </tr>
        <tr>
            <td class="left">reqIssueDt</td>
            <td class="right"><%= RES_PARAMS.get("reqIssueDt") %></td>
        </tr>
        <tr>
            <td class="left">intMon</td>
            <td class="right"><%= RES_PARAMS.get("intMon") %></td>
        </tr>
        <tr>
            <td class="left">fnNm</td>
            <td class="right"><%= RES_PARAMS.get("fnNm") %></td>
        </tr>
        <tr>
            <td class="left">fnCd</td>
            <td class="right"><%= RES_PARAMS.get("fnCd") %></td>
        </tr>
        <tr>
            <td class="left">pointTrdNo</td>
            <td class="right"><%= RES_PARAMS.get("pointTrdNo") %></td>
        </tr>
        <tr>
            <td class="left">pointTrdAmt</td>
            <td class="right"><%= RES_PARAMS.get("pointTrdAmt") %></td>
        </tr>
        <tr>
            <td class="left">cardTrdAmt</td>
            <td class="right"><%= RES_PARAMS.get("cardTrdAmt") %></td>
        </tr>
        <tr>
            <td class="left">vtlAcntNo</td>
            <td class="right"><%= RES_PARAMS.get("vtlAcntNo") %></td>
        </tr>
        <tr>
            <td class="left">expireDt</td>
            <td class="right"><%= RES_PARAMS.get("expireDt") %></td>
        </tr>
        <tr>
            <td class="left">cphoneNo</td>
            <td class="right"><%= RES_PARAMS.get("cphoneNo") %></td>
        </tr>
        <tr>
            <td class="left">billKey</td>
            <td class="right"><%= RES_PARAMS.get("billKey") %></td>
        </tr>

        <tr>
            <td colspan="2" style="text-align: center;">
                <input class="button" type="button" value="확인" onclick="sendResult()" /> 
            </td>
        </tr>
    </table>
</div>
</body>
</html>