cwma = {
	showLoader : function(){
        $('.loader').css({
            'width' : $(window).width(),
            'height' : $(document).height()
        });
        $('.loader div').css('top', $(window).height()/2+$(document).scrollTop()-125);
		$('.loader').show();
	},
	hideLoader : function(){
		$('.loader').hide();
	},
	showMask : function(){
        $('#mask').css({
            'width' : $(window).width(),
            'height' : $(document).height()
        });
        $('#mask').fadeTo("slow", 0.8);
		$('#mask').show();
	},
	hideMask : function(){
		$('#mask').hide();
	},
	//덱셀다운로드 팝업 오픈
	showExcelPop : function(url, isJumin){
		$('#excelLayer textarea').val('');
		$('#excelLayer [type="checkbox"]').prop('checked', false);
		$('#excelLayer [name="url"]').val(contextPath+url);
		
		if(isJumin)
			$('#excelLayer [type="checkbox"]').parent().show();
		else
			$('#excelLayer [type="checkbox"]').parent().hide();
		
		cwma.showMask();
        $('#excelLayer').css("top",(($(window).height() - $('#excelLayer').outerHeight()) / 2) + $(window).scrollTop());
        $('#excelLayer').css("left",(($(window).width() - $('#excelLayer').outerWidth()) / 2) + $(window).scrollLeft());
        $('#excelLayer').draggable();
        $('#excelLayer').show();
	},
	parseQueryString : function(str){
	    var params = {};
	    str.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(str, key, val){
	    	params[key] = val;
	    });
	    return params;
	},
	queryStringToInput : function(str, frm){
		var params = cwma.parseQueryString(str);
		for(var key in params){
			frm.append('<input type="hidden" name="'+key+'" value="'+params[key]+'">');
		}
	},
	niceAuthPop : function(frm){
		var type = $(frm).find('[name="type"]').val();
		window.name ="CWMA_SKILL_WINDOW";
		window.open('', 'niceAuthPop', 'width='+(type=='I'?'450':'500')+', height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
		frm.attr('action', contextPath+'/skill/user/niceAuth.do');
		frm.attr('target', 'niceAuthPop');
		
		if(cwma.isMobile() && type == 'M'){
			if(!frm.find('[name="mobileAt"]')[0])
				frm.append('<input type="hidden" name="mobileAt" value="" />');
			
			frm.find('[name="mobileAt"]').val('Mobile');
		}
		
		frm.submit();
	},
	isMobile : function(){
		var ret = false;
		var filter = 'win16|win32|win64|mac|macintel';

		if(navigator.platform){
			if(0 > filter.indexOf(navigator.platform.toLowerCase()))
				ret = true;
		}
		
		if($(window).outerWidth() < 768)
			ret = true;
		
		return ret;
	},
	isBrowser : function(){
		var browser;
		var agent = navigator.userAgent.toLowerCase();
		if(agent.indexOf("chrome") != -1){
			browser = "chrome";
		}else if(agent.indexOf("firefox") != -1){
			browser = "firefox";
		}else if((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)){
			browser = "explorer";
		}
		return browser;
	}
	/*
	 * PG 결제
	 * */
	,fn_pgPay : function(frm){
		var result = false;
		frm.attr('action', contextPath+'/common/pgPay/pgPayEnc.do');
		$(frm).ajaxCwma({
			 success:function(res){
				 $(frm).find("[name=mchtId]").val(res.pgMid);
//				 document.write("<script src='b.js'></script>");
		            //가맹점 -> 세틀뱅크로 결제 요청
		            SETTLE_PG.pay({
		            	//=====필수===========
		                env : res.paymentServer,   //결제서버 URL
		                mchtId : $(frm).find("[name=mchtId]").val(),
		                method : $(frm).find("[name=method]").val(),
		                trdDt : $(frm).find("[name=trdDt]").val(),							/* 요청일자(yyyyMMdd) */
		                trdTm : $(frm).find("[name=trdTm]").val(),						/* 요청시간(HHmmss) */
		                mchtTrdNo : $(frm).find("[name=mchtTrdNo]").val(),		/* 상점주문번호 */
		                mchtName : $(frm).find("[name=mchtName]").val(),				/* 상점한글명 */
		                mchtEName : $(frm).find("[name=mchtEName]").val(),	/* 상점영문명 */
		                pmtPrdtNm : $(frm).find("[name=pmtPrdtNm]").val(),		/* 상품명 */
		                notiUrl : 'http://110.45.239.169:8080:'+contextPath+'/common/pgPay/pgPayNoti.do',				/* 결과처리 URL */
		                nextUrl : 'http://110.45.239.169:8080:'+contextPath+'/common/pgPay/pgPayNext.do',			/* 결과화면 URL */
		                cancUrl : 'http://110.45.239.169:8080:'+contextPath+'/common/pgPay/pgPayCancel.do',				/* 결제취소 URL */
		                trdAmt : res.encParams.trdAmt,					/* 거래금액(암호문) */
		                mchtCustNm : res.encParams.mchtCustNm,	/* 상점고객이름(암호문) */
		               //=========================
		                //=========옵션=========
//		                expireDt : $('#STPG_payForm [name="expireDt"]').val(),			/*	입금만료일시(yyyyMMddHHmmss) */	
//		                custAcntSumry : $('#STPG_payForm [name="custAcntSumry"]').val(),	/* 통장인자내용 */
//		                mchtParam : $('#STPG_payForm [name="mchtParam"]').val(),	/* 상점예약필드 */
//		                cphoneNo : $('#STPG_payForm [name="cphoneNo"]').val(),		/* 휴대폰번호(암호문) */
//		                email : $('#STPG_payForm [name="email"]').val(),						/* 이메일주소(암호문) */
//		                telecomCd : $('#STPG_payForm [name="telecomCd"]').val(),		/* 통신사코드 */
//		                prdtTerm : $('#STPG_payForm [name="prdtTerm"]').val(),			/* 상품제공기간 */
//		                mchtCustId : $('#STPG_payForm [name="mchtCustId"]').val(),	/* 상점고객아이디(암호문) */
//		                taxTypeCd : $('#STPG_payForm [name="taxTypeCd"]').val(),		/* 면세여부(Y:면세, N:과세, G:복합과세) */
//		                taxAmt : $('#STPG_payForm [name="taxAmt"]').val(),				/* 과세금액(암호문) */
//		                vatAmt : $('#STPG_payForm [name="vatAmt"]').val(),				/* 부가세금액(암호문) */
//		                taxFreeAmt : $('#STPG_payForm [name="taxFreeAmt"]').val(),	/* 면세금액(암호문) */
//		                svcAmt : $('#STPG_payForm [name="svcAmt"]').val(),				/* 봉사료(암호문) */
//		                cardType : $('#STPG_payForm [name="cardType"]').val(),			/* 카드결제타입 */
//		                chainUserId : $('#STPG_payForm [name="chainUserId"]').val(),	/* 현대카드Payshot ID */
//		                cardGb : $('#STPG_payForm [name="cardGb"]').val(),					/* 특정카드사코드 */
//		                clipCustNm : $('#STPG_payForm [name="clipCustNm"]').val(),		/* 클립포인트고객명(암호문) */
//		                clipCustCi : $('#STPG_payForm [name="clipCustCi"]').val(),			/* 클립포인트고객CI(암호문) */
//		                clipCustPhoneNo : $('#STPG_payForm [name="clipCustPhoneNo"]').val(),	/* 클립포인트고객휴대폰번호(암호문) */
//		                certNotiUrl : $('#STPG_payForm [name="certNotiUrl"]').val(),		/* 인증결과URL  */
//		                skipCd : $('#STPG_payForm [name="skipCd"]').val(),					/* 스킵여부 */
//		                multiPay : $('#STPG_payForm [name="multiPay"]').val(),				/* 포인트복합결제 */
//		                autoPayType : $('#STPG_payForm [name="autoPayType"]').val(),	/* 자동결제 타입(공백:일반결제, M:월자동 1회차) */
//		                linkMethod : $('#STPG_payForm [name="linkMethod"]').val(),		/* 연동방식 */
//		                appScheme : $('#STPG_payForm [name="appScheme"]').val(),	/* 앱스키마 */
//		                custIp : $('#STPG_payForm [name="custIp"]').val(),					/* 고객IP주소 */
		                pktHash : res.hashCipher,   //SHA256 처리된 해쉬 값 세팅
		                
		                ui :{
		                    type:"popup",   //popup, iframe, self, blank
		                    width: "430",   //popup창의 너비
		                    height: "660"   //popup창의 높이
		                }
		            }, function(rsp){   
		                //iframe인 경우 전달된 결제 완료 후 응답 파라미터 처리
		                console.log("rsp::"+rsp);
		                result=true;
		                return result;
		            });
			 }
		
		});
	}
};



