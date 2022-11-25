package kr.or.cwma.admin.bbs.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.bbs.vo.BbsVO;

/**
 * 게시판 매퍼
 * @author sichoi
 */
@Repository
public interface BbsMapper{

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
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertBbs(BbsVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateBbs(BbsVO vo) throws SQLException;

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
	 * 발송여부 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateBbsSndngAt(BbsVO vo) throws SQLException;
	
	/**
	 * 답변
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateBbsAnswer(BbsVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteBbs(BbsVO vo) throws SQLException;
	
	/**
	 * 이전글 다음글조회
	 * @param vo 
	 * @return List<BbsVO> 
	 * @throws SQLException 
	 */
	public List<BbsVO> selectBbsPrevNextList(BbsVO vo) throws SQLException;

}
