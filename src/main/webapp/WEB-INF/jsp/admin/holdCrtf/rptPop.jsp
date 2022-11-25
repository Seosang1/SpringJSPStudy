<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    	<title>${param.title}</title>
    	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <script src="${ozServer }/oz60/ozhviewer/jquery-2.0.3.min.js"></script>
		<link rel="stylesheet" href="${ozServer }/oz60/ozhviewer/jquery-ui.css" type="text/css"/>
		<script src="${ozServer }/oz60/ozhviewer/jquery-ui.min.js"></script>
		<link rel="stylesheet" href="${ozServer }/oz60/ozhviewer/ui.dynatree.css" type="text/css"/>
		<script type="text/javascript" src="${ozServer }/oz60/ozhviewer/jquery.dynatree.js" charset="utf-8"></script>
		<script type="text/javascript" src="${ozServer }/oz60/ozhviewer/OZJSViewer.js" charset="utf-8"></script>
		<!-- OZ Form -->
		<script type="text/javascript" src="${ozServer }/oz60/ozhviewer/ozviewer_browers.js" charset="utf-8"></script>
		<script type="text/javascript" src="${ozServer }/oz60/ozhviewer/ztransferx_browers.js" charset="utf-8"></script>
    </head>
    <body>
		<div id="OZViewer" style="width:100%;height:100%"></div>
		<script type="text/javascript" >
		var browser = cwma.isBrowser();
		
		if(browser == "chrome"){
			function SetOZParamters_OZViewer(){
				var oz;
				oz = document.getElementById("OZViewer");
				oz.sendToActionScript("information.debug","false");//디버그
				oz.sendToActionScript("connection.servlet","/oz60/server");
				oz.sendToActionScript("connection.reportname","grade/${param.title}.ozr");
				oz.sendToActionScript("connection.pcount", "1");
				oz.sendToActionScript("connection.args1", "no=${vo.sn}");
				oz.sendToActionScript("export.format","pdf");
				oz.sendToActionScript("eform.signpad_type", "dialog");          //그룹 서명
				
				oz.sendToActionScript("export.filename","${param.title}"+'_${brffcNm}');
				return true;
			}
			var opt = [];
// 			opt["mstyle"] = true;
			opt["signpad_dialog_fullscreen"] = "browser"; // browser, 서명 Dialog를 Viewer Div 영역 기준으로 띄울 경우
			start_ozjs("OZViewer","/oz60/ozhviewer/", opt);
		}else if(browser == "explorer"){
			function ZTInstallEndCommand_ZTransferX(param1,param2) { 
				Create_Div();
	            Initialize_OZViewer("OZReportViewer","clsid:0DEF32F8-170F-46f8-B1FF-4BF7443F5F25","98%","98%","application/OZRViewer");
	            Insert_OZViewer_Param("connection.servlet","${ozServer }/oz60/server");
	            Insert_OZViewer_Param("connection.reportname", '${param.title}');
	            Insert_OZViewer_Param("connection.pcount","1");
	            Insert_OZViewer_Param("connection.args1","no=${vo.sn}");
	// 			Insert_OZViewer_Param("connection.args2","rptSign=" +  "Y");
			   	var aw = screen.availWidth;
			   	var ah = screen.availHeight;
				
				if("Y" == "Y"){
					Insert_OZViewer_Param("eform.usemultiscreen","true");
					//Insert_OZViewer_Param("multiscreen.extraparam","tablet=wacom_wintab,tablet_number=3");
	//					Insert_OZViewer_Param("multiscreen.extraparam","tablet=wacom_wintab,tablet_number=3,updatenow=true");
					//Insert_OZViewer_Param("multiscreen.signpad_window_transparency","255");
					if("" == "size"){
	//						Insert_OZViewer_Param("multiscreen.extraparam","tablet=wacom_wintab,tablet_size=1600/900,updatenow=true");
						Insert_OZViewer_Param("multiscreen.extraparam","tablet=wacom_wintab,tablet_size=1366/768,updatenow=true");
					} else if("" == "no"){
	//						Insert_OZViewer_Param("multiscreen.extraparam","tablet=wacom_wintab,tablet_number=2,updatenow=true");
	 					Insert_OZViewer_Param("multiscreen.extraparam","tablet=wacom_wintab,tablet_number=3,updatenow=true");
					} else {
						Insert_OZViewer_Param("multiscreen.extraparam","tablet=wacom_wintab,tablet_size=1366/768,updatenow=true");
// 	 					Insert_OZViewer_Param("multiscreen.extraparam","tablet=wacom_wintab,tablet_number=3,updatenow=true");
					}
				}
				Insert_OZViewer_Param("multiscreen.signpad_type","keypad");
				Insert_OZViewer_Param("multiscreen.signpad_viewtype","fittoframe");
				Insert_OZViewer_Param("viewer.namespace","cwma\\ozviewer");
				Insert_OZViewer_Param("information.debug","debug");
				Insert_OZViewer_Param("viewer.isframe","true");
				Insert_OZViewer_Param("export.uac","true");
				
	            Start_OZViewer();
			}
		}
		</script>
		<!-- 오즈뷰어 설치 -->
        <div id= "InstallOZViewer">
            <script language="JavaScript">
            if(browser == "explorer"){
                Initialize_ZT("ZTransferX","clsid:C7C7225A-9476-47AC-B0B0-FF3B79D55E67","0","0","${ozServer }/oz60/ozrviewer/ZTransferX_2,2,5,3.cab#version=2,2,5,3","application/OZTransferX_1010");
                Insert_ZT_Param("download.server","${ozServer }/oz60/ozrviewer");
                Insert_ZT_Param("download.port","80");
                Insert_ZT_Param("download.instruction","ozrviewer.idf");
                Insert_ZT_Param("install.base","<PROGRAMS>/Forcs");
                Insert_ZT_Param("install.nameSpace","cwma");
                Start_ZT();


				function savePDF() { //pdf 파일로 저장
					//2020.03.24 at kjh 오즈 리포트 PDF 파일 다운로드시 파일 위치 안내 를 위한 추가 alert
				    alert("PDF 파일 다운로드 후 파일이 저장 위치에서 보이지 않을경우\n"
				    	  +"C:/Users/AppData/Local/Microsoft/Windows/INetCache\n"
				    	  +"경로에  저장 파일이 있습니다 ."
				    		);
						  
					OZReportViewer.ScriptEx("save","export.format=pdf;export.path=C:\\temp;export.mode=normal;export.filename=${param.title}_${brffcNm}.pdf;export.confirmsave=false",";")
				}
				
				function check() {
					//개발신청서 보고서에 대해 필수값을 체크 함(버튼의 OnCheckValidity 이벤트를 실행)
					var chkResult = OZReportViewer.GetInformation("INPUT_CHECK_VALIDITY");
					if(chkResult != "valid"){
						alert("chkResult ===> " + chkResult);	
					}
				}
            }
			</script>
		</div>
    </body>
</html>
<head>
