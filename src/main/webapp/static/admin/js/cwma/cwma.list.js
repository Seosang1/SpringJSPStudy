cwma.list = function(param){
	//변수선언
	var frm, pageVO, func, useFunc;

	//변수값 초기화
	this.param = {
		useFunc:true,
		func:'ajaxList',
		pageVO:{},
		frm:$('#frm'),
		pageLayer:$('#pageDiv')
	};
	
	if(param) $.extend(this.param, param);
	
	if(this.param.frm){
		if($(this.param.frm)[0])
			this.param.frm = $(this.param.frm);
		else if(this.param.frm[0])
			this.param.frm = this.param.frm;
		else
			throw '폼을 찾을 수 없음 : ' + this.param.frm;
	}
	
	if(this.param.pageLayer){
		if($(this.param.pageLayer)[0])
			this.param.pageLayer = $(this.param.pageLayer);
		else if(this.param.pageLayer[0])
			this.param.pageLayer = this.param.pageLayer;
//		else
//			throw '페이징 레이어를 찾을 수 없음 : ' + this.param.pageLayer;
	}
	
	pageVO = this.param.pageVO;
	frm = this.param.frm;
	func = this.param.func;
	useFunc = this.param.useFunc;
	
	//페이지버튼 클릭이벤트
	this.param.pageLayer.on('click', 'a', function(){
		var pageNo = 1;
		
		//첫페이지
		if($(this).hasClass('first'))
			pageNo = 1;
			
		//이전페이지
		else if($(this).hasClass('prev'))
			pageNo = pageVO.pageNo>1?pageVO.pageNo-1:1;
			
		//다음페이지
		else if($(this).hasClass('next'))
			pageNo = pageVO.pageNo<pageVO.totalPage?pageVO.pageNo+1:pageVO.totalPage;
		
		//마지막페이지
		else if($(this).hasClass('last'))
			pageNo = pageVO.totalPage;
		
		//페이지번호
		else if($(this).hasClass('btnPage'))
			pageNo = Number($(this).text());
		
		if(useFunc){
			eval(func+'('+pageNo+')')
		}else{
			frm.find('[name="pageNo"]').val(pageNo);
			frm.submit();
		}
		
		event.preventDefault();
		return false;
	});
	
	this.setPage = function(vo){
		//초기화
		var str = '';
		this.param.pageVO = vo;
		pageVO = vo;
		
		//폼 필수값 세팅
		if(!frm.find('[name="pageNo"]')[0])
			frm.append('<input type="hidden" name="pageNo" value="1" />');
		
		if(!frm.find('[name="numOfPage"]')[0])
			frm.append('<input type="hidden" name="numOfPage" value="20" />');
		
		frm.find('[name="numOfPage"]').val(pageVO.numOfPage);

		//페이징
		str += '<a href="#" class="first">First</a>';
		str += '<a href="#" class="prev">Prev</a>';
		
		for(var i=pageVO.startPage;i<=pageVO.endPage;i++)
			str += '<a href="#" class="btnPage '+(i == pageVO.pageNo?'on':'')+'">'+i+'</a>';
		
		str += '<a href="#" class="next">Next</a>';
		str += '<a href="#" class="last">Last</a>';
		
		this.param.pageLayer.html(str);
	}
	
	return this;
};
