package com.wizcm.scheduler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

@Service("batchService")
public class SchedulerService {
	
	protected Log logger = LogFactory.getLog(this.getClass());

	public void schedulerSampleOne() {
		logger.info("execute schedulerSampleOne");
	}

	public void schedulerSampleTwo() {
		logger.info("execute schedulerSampleTwo");
	}
	
}
