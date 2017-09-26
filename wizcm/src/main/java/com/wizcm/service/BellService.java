package com.wizcm.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wizcm.dao.BellDao;
import com.wizcm.vo.tbl_bellcontent;

@Service("bellService")
public class BellService {
	
	protected Log logger = LogFactory.getLog(this.getClass());

	@Autowired
	private BellDao bellDao;

	@Transactional(readOnly = true)
	public List<tbl_bellcontent> getBellInfo(Map param) {
		return bellDao.getBellInfo(param);
	}

}
