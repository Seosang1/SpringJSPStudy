package kr.or.cwma.admin.gradStdr.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.gradStdr.mapper.GradStdrMapper;
import kr.or.cwma.admin.gradStdr.service.GradStdrService;
import kr.or.cwma.admin.gradStdr.vo.GradStdrVO;

/**
 * 등급기준관리 비지니스로직
 * @author sichoi
 */
@Service
public class GradStdrServiceImpl implements GradStdrService{

	@Autowired
	private GradStdrMapper gradStdrMapper;

	public List<GradStdrVO> selectGradStdrList(GradStdrVO vo) throws SQLException{
		return gradStdrMapper.selectGradStdrList(vo);
	}

	public GradStdrVO selectGradStdrView(GradStdrVO vo) throws SQLException{
		return gradStdrMapper.selectGradStdrView(vo);
	}

	public void insertGradStdr(GradStdrVO vo) throws SQLException{
		gradStdrMapper.insertGradStdr(vo);
	}

}
