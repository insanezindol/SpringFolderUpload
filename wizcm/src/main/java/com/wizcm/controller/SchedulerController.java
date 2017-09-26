package com.wizcm.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.wizcm.scheduler.SchedulerService;

@Controller
@RequestMapping("/scheduler")
public class SchedulerController {
	
	protected Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired
	private SchedulerService schedulerService;
	
	@RequestMapping(value = "/schedulerSampleOne.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String schedulerSampleOne(Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] schedulerSampleOne()");
		String msg = "";
		try {
			schedulerService.schedulerSampleOne();
			msg = "SUCCESS [schedulerSampleOne]";
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
			msg = "FAIL [schedulerSampleOne]";
		}
		model.addAttribute("msg", msg);
		logger.info("[END] schedulerSampleOne()");
		return "message";
	}
	
	@RequestMapping(value = "/schedulerSampleTwo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String schedulerSampleTwo(Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] schedulerSampleTwo()");
		String msg = "";
		try {
			schedulerService.schedulerSampleTwo();
			msg = "SUCCESS [schedulerSampleTwo]";
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
			msg = "FAIL [schedulerSampleTwo]";
		}
		model.addAttribute("msg", msg);
		logger.info("[END] schedulerSampleTwo()");
		return "message";
	}
	
}
