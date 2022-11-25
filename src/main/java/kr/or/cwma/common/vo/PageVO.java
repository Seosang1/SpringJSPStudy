package kr.or.cwma.common.vo;

import java.io.Serializable;

public class PageVO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	//순번
	private int rownum = 1;
	//페이징시작번호
	private int sNum = 1;
	//페이징끝번호
	private int eNum = Integer.MAX_VALUE;
	//페이지번호
	private int pageNo = 1;
	//시작페이지
	private int startPage = 0;
	//끝페이지
	private int endPage = 0;
	//이전페이지
	private int prevPage = 1;
	//다음페이지
	private int nextPage = 1;
	//페이지당 게시물갯수
	private int numOfPage = 10;
	//페이지당 페이징그룹갯수
	private int numOfPageGroup = 10;
	//게시물갯수
	private int totalCnt = 0;
	//총페이지수
	private int totalPage = 0;
	//페이징 쿼리 스트링
	private String queryStr;
	//검색어
	private String searchWord;
	//검색키
	private String searchKey;
	//주민등록번호 뒷자리 표기여부
	private String ihidnumIndictAt;
	
	public int getRownum(){
		return rownum;
	}
	public void setRownum(int rownum){
		this.rownum = rownum;
	}
	public int getPrevPage() {
		return prevPage;
	}
	public void setPrevPage(int prevPage) {
		this.prevPage = prevPage;
	}
	public int getNextPage() {
		return nextPage;
	}
	public void setNextPage(int nextPage) {
		this.nextPage = nextPage;
	}
	public String getQueryStr() {
		return queryStr;
	}
	public void setQueryStr(String queryStr) {
		this.queryStr = queryStr;
	}
	public int getsNum() {
		return sNum;
	}
	public void setsNum(int sNum) {
		this.sNum = sNum;
	}
	public int geteNum() {
		return eNum;
	}
	public void seteNum(int eNum) {
		this.eNum = eNum;
	}
	public int getPageNo() {
		return pageNo;
	}
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	public int getStartPage() {
		return startPage;
	}
	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	public int getNumOfPage() {
		return numOfPage;
	}
	public void setNumOfPage(int numOfPage) {
		this.numOfPage = numOfPage;
	}
	public int getNumOfPageGroup() {
		return numOfPageGroup;
	}
	public void setNumOfPageGroup(int numOfPageGroup) {
		this.numOfPageGroup = numOfPageGroup;
	}
	public int getTotalCnt() {
		return totalCnt;
	}
	public void setTotalCnt(int totalCnt) {
		totalPage = (int)Math.ceil((float)totalCnt / (float)numOfPage);
		totalPage = totalPage<1?1:totalPage;
		endPage = (int)Math.ceil((float)pageNo/(float)numOfPageGroup)*numOfPageGroup;
		startPage = endPage - (numOfPageGroup-1);
		endPage = endPage > totalPage?totalPage:endPage;
		sNum = (pageNo-1)*numOfPage+1;
		eNum = pageNo*numOfPage;
		this.totalCnt = totalCnt;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public String getSearchWord(){
		return searchWord;
	}
	public void setSearchWord(String searchWord){
		this.searchWord = searchWord;
	}
	public String getSearchKey(){
		return searchKey;
	}
	public void setSearchKey(String searchKey){
		this.searchKey = searchKey;
	}
	public String getIhidnumIndictAt(){
		return ihidnumIndictAt;
	}
	public void setIhidnumIndictAt(String ihidnumIndictAt){
		this.ihidnumIndictAt = ihidnumIndictAt;
	}
}
