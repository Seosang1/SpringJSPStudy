package kr.or.cwma.skill.mypage.service.impl;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.clmserEdu.mapper.ClmserEduMapper;
import kr.or.cwma.admin.clmserEdu.vo.UserClmserEduRelVO;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserMainJssfcVO;
import kr.or.cwma.common.util.CryptUtil;
import kr.or.cwma.skill.common.kisa.Seed128;
import kr.or.cwma.skill.customer.vo.SurveyAnswerVO;
import kr.or.cwma.skill.customer.vo.SurveyAnswrrVO;
import kr.or.cwma.skill.mypage.mapper.MypageMapper;
import kr.or.cwma.skill.mypage.service.MypageService;
import kr.or.cwma.skill.mypage.vo.CorpCrtfIssuVO;

@Service
public class MypageServiceImpl implements MypageService{
	
	@Autowired
	private MypageMapper mypageMapper;
	
	@Autowired
	private ClmserEduMapper clmserEduMapper;

	@Override
	public BbsVO selectQnaView(BbsVO vo) throws SQLException{
		return mypageMapper.selectQnaView(vo);
	}

	@Override
	public void updateUserPassword(UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		vo.setPassword(CryptUtil.encriptSHA512(vo.getPassword()));
		mypageMapper.updateUserPassword(vo);
	}

	@Override
	public void updateUserIhidnum(UserInfoVO vo) throws SQLException{
		mypageMapper.updateUserIhidnum(vo);
	}

	@Override
	public List<UserMainJssfcVO> selectUserWorkDay(UserInfoVO vo) throws SQLException{
		return mypageMapper.selectUserWorkDay(vo);
	}

	@Override
	public Map<String, String> selectUserBasicInfo(UserInfoVO vo) throws SQLException{
		return mypageMapper.selectUserBasicInfo(vo);
	}

	@Override
	public List<Map<String, String>> selectGradList(UserInfoVO vo) throws SQLException{
		return mypageMapper.selectGradList(vo);
	}

	@Override
	public int selectCntrctListCnt(UserInfoVO vo) throws SQLException {
		return mypageMapper.selectCntrctListCnt(vo);
	}
	
	@Override
	public List<CntrctInfoVO> selectCntrctList(UserInfoVO vo) throws SQLException{
		vo.setTotalCnt(mypageMapper.selectCntrctListCnt(vo));//페이징_사업주
		return mypageMapper.selectCntrctList(vo);
	}

	@Override
	public List<Map<String, String>> selectGradListForDminstt(UserInfoVO vo) throws SQLException{
		return mypageMapper.selectGradListForDminstt(vo);
	}
	
	@Override
	public int selectCntrctListForDminsttCnt(UserInfoVO vo) throws SQLException{
		return mypageMapper.selectCntrctListForDminsttCnt(vo);
	}

	@Override
	public List<CntrctInfoVO> selectCntrctListForDminstt(UserInfoVO vo) throws SQLException{
		vo.setTotalCnt(mypageMapper.selectCntrctListForDminsttCnt(vo));//페이징_수요기관
		return mypageMapper.selectCntrctListForDminstt(vo);
	}

	@Override
	public List<CorpCrtfIssuVO> selectCrtfIssuConsList(CorpCrtfIssuVO vo) throws SQLException {
		// TODO Auto-generated method stub
		vo.setTotalCnt(mypageMapper.selectCrtfIssuConsListCnt(vo));
		return mypageMapper.selectCrtfIssuConsList(vo);
	}

	@Override
	public Map<String, Object> selectCrtfIssuConsMenStaticInfo(CorpCrtfIssuVO vo) throws SQLException {
		// TODO Auto-generated method stub
		return mypageMapper.selectCrtfIssuConsMenStaticInfo(vo);
	}

	@Override
	public CorpCrtfIssuVO selectCrtfIssuConsMenInfo(CorpCrtfIssuVO vo) throws SQLException {
		// TODO Auto-generated method stub
		return mypageMapper.selectCrtfIssuConsMenInfo(vo);
	}

	@Override
	public List<CorpCrtfIssuVO> selectCrtfIssuConsMenList(CorpCrtfIssuVO vo) throws SQLException {
		// TODO Auto-generated method stub
		vo.setTotalCnt(mypageMapper.selectCrtfIssuConsMenListCnt(vo));
		List<CorpCrtfIssuVO> list = mypageMapper.selectCrtfIssuConsMenList(vo);
		for(CorpCrtfIssuVO lvo : list) {
			//암/복호화에 16자리 키값이 필요함 = CwmaGradeIhidnum
			Seed128 seed = new Seed128("CwmaGradeIhidnum");
			lvo.setIhidnum(seed.encrypt(lvo.getIhidnum()));
			if(StringUtils.isNotEmpty(lvo.getGrad()))
				lvo.setGrad(seed.encrypt(lvo.getGrad()));
		}
		return list;
	}
	
	@Override
	public void insertClmserEduSurveyAnswer(SurveyAnswrrVO vo, UserClmserEduRelVO evo) throws SQLException{
		mypageMapper.insertClmserEduSurveyAnswrr(vo);
		
		for(SurveyAnswerVO avo : vo.getAnswerVO()){
			avo.setAnswrrSn(vo.getAnswrrSn());
			mypageMapper.insertClmserEduSurveyAnswer(avo);
		}
		
		clmserEduMapper.insertUserClmserEduRel(evo);
	}
	
	@Override
	public CntrctInfoVO selectCntrctInfo(UserInfoVO vo) throws SQLException{
		return mypageMapper.selectCntrctInfo(vo);
	}

	@Override
	public CntrctInfoVO selectCntrctWorkInfo(UserInfoVO vo) throws SQLException {
		return mypageMapper.selectCntrctWorkInfo(vo);
	}
	
}
