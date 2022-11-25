package kr.or.cwma.admin.careerStdr.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.careerStdr.mapper.CareerStdrMapper;
import kr.or.cwma.admin.careerStdr.service.CareerStdrService;
import kr.or.cwma.admin.careerStdr.vo.CareerStdrVO;

/**
 * 경력기준관리 비지니스로직
 * @author sichoi
 */
@Service
public class CareerStdrServiceImpl implements CareerStdrService{

	@Autowired
	private CareerStdrMapper careerStdrMapper;

	public List<CareerStdrVO> selectCareerStdrList(CareerStdrVO vo) throws SQLException{
		return careerStdrMapper.selectCareerStdrList(vo);
	}

	public CareerStdrVO selectCareerStdrView(CareerStdrVO vo) throws SQLException{
		return careerStdrMapper.selectCareerStdrView(vo);
	}

	public void insertCareerStdr(CareerStdrVO vo) throws SQLException{
		if(vo.getVoList() != null && vo.getVoList().size() > 0){
			for(CareerStdrVO cvo : vo.getVoList()){
				cvo.setApplcDe(vo.getApplcDe());
				cvo.setRgstId(vo.getRgstId());
				careerStdrMapper.insertCareerStdr(cvo);
			}
		}else
			careerStdrMapper.insertCareerStdr(vo);
	}

}
