package kr.or.cwma.admin.fee.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.fee.mapper.FeeMapper;
import kr.or.cwma.admin.fee.service.FeeService;
import kr.or.cwma.admin.fee.vo.FeeVO;

/**
 * 수수료 관리 비지니스 로직
 * @author sichoi
 */
@Service
public class FeeServiceImpl implements FeeService{

	@Autowired
	private FeeMapper feeMapper;

	@Override
	public List<FeeVO> selectFeeList(FeeVO vo) throws SQLException{
		return feeMapper.selectFeeList(vo);
	}
	
	public FeeVO selectFeeView(FeeVO vo) throws SQLException{
		return feeMapper.selectFeeView(vo);
	}

	public void insertFee(FeeVO vo) throws SQLException{
		feeMapper.insertFee(vo);
	}

}
