package com.wizcm.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.wizcm.common.CommonController;

@Controller
@RequestMapping("/")
public class HomeController extends CommonController {

	protected Log logger = LogFactory.getLog(this.getClass());

	@RequestMapping(value = "/", method = { RequestMethod.GET, RequestMethod.POST })
	public String home(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /");
		logger.info("[END] /");
		return "redirect:index.do";
	}
	
	@RequestMapping(value = "/index.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String index(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /index.do");

		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		String formattedDate = dateFormat.format(date);
		logger.info(formattedDate);
		model.addAttribute("serverTime", formattedDate);
		
		logger.info("[END] /index.do");
		
		return "/index";
	}
	
}
