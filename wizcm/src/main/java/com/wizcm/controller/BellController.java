package com.wizcm.controller;

import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.wizcm.common.CommonController;
import com.wizcm.common.CommonUtils;
import com.wizcm.service.BellService;
import com.wizcm.vo.tbl_bellcontent;

@Controller
@RequestMapping("/bell")
public class BellController extends CommonController {

	protected Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired
	private BellService bellService;
	
	@RequestMapping(value = "/bellResult.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String bellResult(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /bell/bellResult.do");
		
		try {
			String text = "벨 DB 조회 결과 페이지";
			model.addAttribute("text", text);
			
			String lid = CommonUtils.replaceXSSCheck(request.getParameter("lid") == null ? "" : request.getParameter("lid"));
			
			if(!lid.equals("")){
				Map param = new Hashtable();
				param.put("lid", lid);
				
				List<tbl_bellcontent> infos = bellService.getBellInfo(param);
				model.addAttribute("infos", infos);
			}
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		
		logger.info("[END] /bell/bellResult.do");
		
		return "/bell/bellResult";
	}

}
