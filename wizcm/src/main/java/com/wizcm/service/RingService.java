package com.wizcm.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wizcm.common.CommonUtils;
import com.wizcm.dao.RingDao;
import com.wizcm.vo.tb_file_meta_info;

@Service("ringService")
public class RingService {
	
	protected Log logger = LogFactory.getLog(this.getClass());

	@Autowired
	private RingDao ringDao;

	@Transactional(readOnly = true)
	public List<tb_file_meta_info> getRingInfo(Map param) {
		return ringDao.getRingInfo(param);
	}

	@Transactional(readOnly = true)
	public List<tb_file_meta_info> getRingPageInfo(Map param) {
		List<tb_file_meta_info> tmp = ringDao.getRingPageInfo(param);
		List<tb_file_meta_info> infos = new ArrayList<tb_file_meta_info>();
		for (tb_file_meta_info info : tmp) {
			info.setTitle(CommonUtils.replaceCharView(info.getTitle()));
			info.setSinger(CommonUtils.replaceCharView(info.getSinger()));
			infos.add(info);
		}
		return infos;
	}

	@Transactional(readOnly = true)
	public int getTotalRingPageInfo() {
		return ringDao.getTotalRingPageInfo();
	}

}
