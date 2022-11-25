package kr.or.cwma.admin.issuAgre.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.issuAgre.mapper.IssuAgreMapper;
import kr.or.cwma.admin.issuAgre.service.IssuAgreService;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;

/**
 * 회원 발급동의신청 비지니스 로직
 */
@Service
public class IssuAgreServiceImpl implements IssuAgreService{
	@Autowired
	IssuAgreMapper issuAgreMapper;
	
	@Override
	public IssuAgreVO selectIssuAgre(IssuAgreVO vo) throws SQLException {
		IssuAgreVO ivo = null;
		vo.setTrmnatAt(StringUtils.isEmpty(vo.getTrmnatAt()) ? "Y" : vo.getTrmnatAt());//공사해지 여부
		
		ivo = issuAgreMapper.selectIssuAgre(vo);
		if(ivo == null) {
			ivo = issuAgreMapper.selectIssuAgreWork(vo);
		}
		return ivo;
	}

	@Override
	public int insertIssuAgre(IssuAgreVO vo) throws SQLException {
		vo.setSptSe(StringUtils.isEmpty(vo.getSptSe()) ? "SPTS0001" : vo.getSptSe());
		return issuAgreMapper.insertIssuAgre(vo);
	}

	@Override
	public int updateIssuAgre(IssuAgreVO vo) throws SQLException {
		return issuAgreMapper.updateIssuAgre(vo);
	}

	@Override
	public int deleteIssuAgre(IssuAgreVO vo) throws SQLException {
		return issuAgreMapper.deleteIssuAgre(vo);
	}

	@Override
	public IssuAgreVO selectIssuAgreView(IssuAgreVO vo) throws SQLException {
		return issuAgreMapper.selectIssuAgreView(vo);
	}

	@Override
	public int selectCntrctListCnt(UserInfoVO vo) throws SQLException {
		vo.setTrmnatAt(StringUtils.isEmpty(vo.getTrmnatAt()) ? "Y" : vo.getTrmnatAt());
		
		return issuAgreMapper.selectCntrctListCnt(vo);
	}

	@Override
	public List<CntrctInfoVO> selectCntrctList(UserInfoVO vo) throws SQLException {
		vo.setTrmnatAt(StringUtils.isEmpty(vo.getTrmnatAt()) ? "Y" : vo.getTrmnatAt());
		vo.setTotalCnt(issuAgreMapper.selectCntrctListCnt(vo));//페이징
		return issuAgreMapper.selectCntrctList(vo);
	}

	@Override
	public IssuAgreVO selectIssuAgreInfo(IssuAgreVO vo) throws SQLException {
		return issuAgreMapper.selectIssuAgreInfo(vo);
	}

	@Override
	public int selectIssuAgreRceptNoCnt(String rceptNo) throws SQLException {
		return issuAgreMapper.selectIssuAgreRceptNoCnt(rceptNo);
	}

	@Override
	public int updateIssuAgreRceptNo(IssuAgreVO vo) throws SQLException {
		return issuAgreMapper.updateIssuAgreRceptNo(vo);
	}
	
}
