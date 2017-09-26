package com.wizcm.dao;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Repository;

import com.wizcm.common.CommonDao;
import com.wizcm.vo.tb_file_meta_info;

@Repository("ringDao")
public class RingDao extends CommonDao {
	
	protected Log logger = LogFactory.getLog(this.getClass());

	public List<tb_file_meta_info> getRingInfo(Map param) {
		return ringDBSession.selectList("ring.getRingInfo", param);
	}

	public List<tb_file_meta_info> getRingPageInfo(Map param) {
		return ringDBSession.selectList("ring.getRingPageInfo", param);
	}

	public int getTotalRingPageInfo() {
		return ringDBSession.selectOne("ring.getTotalRingPageInfo");
	}

}
