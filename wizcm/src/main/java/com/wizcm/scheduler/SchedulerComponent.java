package com.wizcm.scheduler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class SchedulerComponent {
	protected Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired
	private SchedulerService schedulerService;
	
	// 초 분 시 일 월 요일
	// 매일 0,6,12,18시 00분 00초 호출
	@Scheduled(cron = "0 0 0,6,12,18 * * *")
	public void schedulerSampleOne() {
		logger.info("[BEG] schedulerSampleOne()");
		try {
			schedulerService.schedulerSampleOne();
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		logger.info("[END] schedulerSampleOne()");
	}
	
	// 5분 마다 주기적으로 실행
	@Scheduled(fixedDelay=300000)
	public void schedulerSampleTwo() {
		logger.info("[BEG] schedulerSampleTwo()");
		try {
			schedulerService.schedulerSampleTwo();
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		logger.info("[END] schedulerSampleTwo()");
	}

}
