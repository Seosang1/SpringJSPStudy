package kr.or.cwma.admin.batchLog.service.impl;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.batchLog.mapper.BatchLogMapper;
import kr.or.cwma.admin.batchLog.service.BatchLogService;
import kr.or.cwma.admin.batchLog.vo.BatchLogVO;

@Service
public class BatchLogServiceImpl implements BatchLogService{

	@Autowired
	private BatchLogMapper batchLogMapper;

	public List<BatchLogVO> selectBatchLogList(BatchLogVO vo) throws SQLException{
		vo.setTotalCnt(batchLogMapper.selectBatchLogListCnt(vo));
		return batchLogMapper.selectBatchLogList(vo);
	}

	public BatchLogVO selectBatchLogView(BatchLogVO vo) throws SQLException{
		return batchLogMapper.selectBatchLogView(vo);
	}

	public List<BatchLogVO> selectBatchCdList() throws SQLException{
		return batchLogMapper.selectBatchCdList();
	}

	@Override
	public List<Map<String, Object>> selectBatchLogListXls(BatchLogVO vo) throws SQLException{
		return batchLogMapper.selectBatchLogListXls(vo);
	}

}
