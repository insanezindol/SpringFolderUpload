package com.wizcm.dao;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Repository;

import com.wizcm.common.CommonDao;
import com.wizcm.vo.tbl_bellcontent;

@Repository("bellDao")
public class BellDao extends CommonDao {
	
	protected Log logger = LogFactory.getLog(this.getClass());

	public List<tbl_bellcontent> getBellInfo(Map param) {
		return bellDBSession.selectList("bell.getBellInfo", param);
	}

}
