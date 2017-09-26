package com.wizcm.controller;

import java.io.File;
import java.util.Hashtable;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wizcm.common.CommonConstant;
import com.wizcm.common.CommonController;
import com.wizcm.common.CommonUtils;

@Controller
@RequestMapping("/file")
public class FileController extends CommonController {

	protected Log logger = LogFactory.getLog(this.getClass());
	
	@RequestMapping(value = "/fileForm.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String fileForm(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /file/fileForm.do");

		try {
			String text = "폴더 업로드 페이지";
			model.addAttribute("text", text);
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		
		logger.info("[END] /file/fileForm.do");
		
		return "/file/fileForm";
	}
	
	@RequestMapping(value = "/fileUpload.do", method = { RequestMethod.GET, RequestMethod.POST })
	public void fileUpload(HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /file/fileUpload.do");
		Map result = new Hashtable();

		try {
			String path = CommonUtils.replaceXSSCheck(request.getParameter("path") == null ? "" : request.getParameter("path"));
			String timeStamp = CommonUtils.replaceXSSCheck(request.getParameter("timeStamp") == null ? "" : request.getParameter("timeStamp"));
			result.put("path", path);
			result.put("timeStamp", timeStamp);
			logger.info("[" + timeStamp + "] " + path);

			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
			
			java.util.Iterator<String> fileNames = multipartRequest.getFileNames();
			while (fileNames.hasNext()) {
				String filePath = CommonConstant.TEMP_FOLDER_PATH;
				MultipartFile uploadfile = multipartRequest.getFile(fileNames.next());
				String fileName = uploadfile.getOriginalFilename();
				
				path = path.replaceAll(fileName, "");
				File targetDir = new File(filePath + path);
				if (!targetDir.exists()) {
					// 디렉토리 없으면 생성.
					targetDir.mkdirs();
				}
				logger.info("PATH : " + filePath + path + fileName);
				File convFile = new File(filePath + path + fileName);
				uploadfile.transferTo(convFile);
			}

			result.put("result", "success");
			result.put("msg", "success file upload");
		} catch (Exception e) {
			logger.error(e.getClass() + ": " + e.getMessage(), e);
			result.put("result", "fail");
			result.put("msg", "fail file upload ");
		}
		logger.info("[END] /file/fileUpload.do");
		this.outputJSON(request, response, result);
	}

	@RequestMapping(value = "/excelForm.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String excelForm(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /file/excelForm.do");

		try {
			String text = "엑셀 파싱 페이지";
			model.addAttribute("text", text);
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		
		logger.info("[END] /file/excelForm.do");
		
		return "/file/excelForm";
	}
	
	@RequestMapping(value = "/excelFileUploadForm.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String excelFileUploadForm(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /file/excelFileUploadForm.do");

		try {
			String text = "엑셀 파싱 + 폴더 업로드 페이지";
			model.addAttribute("text", text);
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		
		logger.info("[END] /file/excelFileUploadForm.do");
		
		return "/file/excelFileUploadForm";
	}
	
	@RequestMapping(value = "/iphoneBellForm.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String iphoneBellForm(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /file/iphoneBellForm.do");

		try {
			String text = "아이폰벨 업로드 페이지";
			model.addAttribute("text", text);
		} catch (Exception e) {
			logger.error(e.getClass() + ": " +  e.getMessage(), e);
		}
		
		logger.info("[END] /file/iphoneBellForm.do");
		
		return "/file/iphoneBellForm";
	}
}
