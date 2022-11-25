package kr.or.cwma.admin.bbs.service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.or.cwma.admin.bbs.vo.BbsVO;

/**
 * 게시판 서비스
 * @author sichoi
 */
public interface BbsService{

	/**
	 * 목록갯수조회
	 * @param vo 
	 * @return List<BbsVO> 
	 * @throws SQLException 
	 */
	public int selectBbsListCnt(BbsVO vo) throws SQLException;
	
	/**
	 * 목록조회
	 * @param vo 
	 * @return List<BbsVO> 
	 * @throws SQLException 
	 */
	public List<BbsVO> selectBbsList(BbsVO vo) throws SQLException;
	
	/**
	 * 상세조회
	 * @param vo 
	 * @return BbsVO 
	 * @throws SQLException 
	 */
	public BbsVO selectBbsView(BbsVO vo) throws SQLException;

	/**
	 * 등록
	 * - 첨부파일 정보와 함께 등록
	 * @param vo
	 * @param req
	 * @return String
	 * @throws SQLException
	 * @throws IOException
	 */
	public void insertBbs(BbsVO vo, HttpServletRequest req) throws SQLException, IOException;

	/**
	 * 수정
	 * - 추가요청한 첨부파일 등록
	 * - 삭제요청한 첨부파일 삭제
	 * @param vo
	 * @param req  
	 * @throws SQLException
	 * @throws IOException 
	 */
	public void updateBbs(BbsVO vo, HttpServletRequest req) throws SQLException, IOException;

	/**
	 * 답변
	 * -답변, 답변자, 답변일정보 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateBbsAnswer(BbsVO vo) throws SQLException;
	
	/**
	 * 답변 메세지 발송
	 * @param vo 
	 * @throws SQLException 
	 */
	public void executeSms(BbsVO vo) throws SQLException;	

	/**
	 * 삭제
	 * @return BbsVO 
	 * @throws SQLException 
	 */
	public void deleteBbs(BbsVO vo) throws SQLException;
	
	/**
	 * 조회수 증가
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateBbsRdcnt(BbsVO vo) throws SQLException;
	
	/**
	 * 다운로드수 증가
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateBbsDwldCo(BbsVO vo) throws SQLException;
	
	/**
	 * 이전글 다음글조회
	 * @param vo 
	 * @return List<BbsVO> 
	 * @throws SQLException 
	 */
	public List<BbsVO> selectBbsPrevNextList(BbsVO vo) throws SQLException;

}
