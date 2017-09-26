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
import com.wizcm.service.RingService;
import com.wizcm.vo.PageNavigator;
import com.wizcm.vo.tb_file_meta_info;

@Controller
@RequestMapping("/ring")
public class RingController extends CommonController {

	protected Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired
	private RingService ringService;
	
	@RequestMapping(value = "/ringResult.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String ringResult(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /ring/ringResult.do");

		try {
			String text = "링 DB 조회 결과 페이지";
			model.addAttribute("text", text);
			
			String lid = CommonUtils.replaceXSSCheck(request.getParameter("lid") == null ? "" : request.getParameter("lid"));
			
			if(!lid.equals("")){
				Map param = new Hashtable();
				param.put("lid", lid);
				
				List<tb_file_meta_info> infos = ringService.getRingInfo(param);
				model.addAttribute("infos", infos);
			}
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		
		logger.info("[END] /ring/ringResult.do");
		
		return "/ring/ringResult";
	}
	
	@RequestMapping(value = "/ajaxResult.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String ajaxResult(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /ring/ajaxResult.do");

		try {
			String text = "링 DB 조회 ajax 페이지";
			model.addAttribute("text", text);
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		
		logger.info("[END] /ring/ajaxResult.do");
		
		return "/ring/ajaxResult";
	}
	
	@RequestMapping(value = "/fileForm.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String fileForm(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /ring/fileForm.do");

		try {
			String text = "파일 업로드 폼 페이지";
			model.addAttribute("text", text);
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		
		logger.info("[END] /ring/fileForm.do");
		
		return "/ring/fileForm";
	}
	
	@RequestMapping(value = "/webSql.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String webSql(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /ring/webSql.do");

		try {
			String text = "Web SQL 페이지";
			
			String tmpPageNo = CommonUtils.replaceXSSCheck(request.getParameter("pageNo") == null ? "1" : request.getParameter("pageNo"));
			int pageNo = Integer.parseInt(tmpPageNo);

			int totalCount = ringService.getTotalRingPageInfo();

			PageNavigator pageNavigator = new PageNavigator();
			pageNavigator.setTotalCount(totalCount);
			pageNavigator.setPageNo(pageNo);
			pageNavigator.setPageSize(10);
			pageNavigator.makePaging();
			
			Map param = new Hashtable();
			param.put("startRow", pageNavigator.getStartRow());
			param.put("endRow", pageNavigator.getEndRow());
			
			List<tb_file_meta_info> infos = ringService.getRingPageInfo(param);
			
			model.addAttribute("text", text);
			model.addAttribute("pageNavigator", pageNavigator);
			model.addAttribute("infos", infos);
			
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		
		logger.info("[END] /ring/webSql.do");
		
		return "/ring/webSql";
	}

}
