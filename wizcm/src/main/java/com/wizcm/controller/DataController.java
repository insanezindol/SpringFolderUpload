package com.wizcm.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.wizcm.common.CommonConstant;
import com.wizcm.common.CommonController;
import com.wizcm.common.CommonUtils;
import com.wizcm.service.RingService;
import com.wizcm.vo.tb_file_meta_info;

@Controller
@RequestMapping("/data")
public class DataController extends CommonController {
	
	protected Log logger = LogFactory.getLog(this.getClass());

	@Autowired
	private RingService ringService;

	@RequestMapping(value = "/getRingData.do", method = { RequestMethod.GET, RequestMethod.POST })
	public void getRingData(HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /data/getRingData.do");
		List<tb_file_meta_info> infos = new ArrayList<tb_file_meta_info>();

		try {
			String lid = CommonUtils.replaceXSSCheck(request.getParameter("lid") == null ? "" : request.getParameter("lid"));

			if (!lid.equals("")) {
				Map param = new Hashtable();
				param.put("lid", lid);
				infos = ringService.getRingInfo(param);
			}
		} catch (Exception e) {
			logger.error(e.getClass() + ": " + e.getMessage(), e);
		}
		logger.info("[END] /data/getRingData.do");
		this.outputJSON(request, response, infos);
	}

	@RequestMapping(value = "/dataUpload.do", method = { RequestMethod.GET, RequestMethod.POST })
	public void dataUpload(HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /data/dataUpload.do");
		Map output = new Hashtable();
		
		try {
			String rootPath = request.getParameter("rootPath") == null ? "" : request.getParameter("rootPath");
			String lid = request.getParameter("lid") == null ? "" : request.getParameter("lid");
			String singer = request.getParameter("singer") == null ? "" : request.getParameter("singer");
			String title = request.getParameter("title") == null ? "" : request.getParameter("title");
			String album = request.getParameter("album") == null ? "" : request.getParameter("album");
			String songcode = request.getParameter("songcode") == null ? "" : request.getParameter("songcode");
			String filename = request.getParameter("filename") == null ? "" : request.getParameter("filename");
			String lyrics1 = CommonUtils.convertLyrics(request.getParameter("lyrics1") == null ? "" : request.getParameter("lyrics1"));
			String lyrics2 = CommonUtils.convertLyrics(request.getParameter("lyrics2") == null ? "" : request.getParameter("lyrics2"));
			String lyrics3 = CommonUtils.convertLyrics(request.getParameter("lyrics3") == null ? "" : request.getParameter("lyrics3"));
			
			try {
				logger.info("[BEGIN] DB INSERT");
				logger.info("[lid] " + lid);
				logger.info("[singer] " + singer);
				logger.info("[title] " + title);
				logger.info("[album] " + album);
				logger.info("[songcode] " + songcode);
				logger.info("[filename] " + filename);
				logger.info("[lyrics1] " + lyrics1);
				logger.info("[lyrics2] " + lyrics2);
				logger.info("[lyrics3] " + lyrics3);
				logger.info("[END] DB INSERT");
				
				output.put("dbResult", "success");
				output.put("dbMsg", "success db insert");
			} catch (Exception e) {
				logger.error(e.getClass() + ": " + e.getMessage(), e);
				output.put("dbResult", "fail");
				output.put("dbMsg", "fail db insert");
			}
			
			try {
				logger.info("[BEGIN] COPY");
				String source = CommonConstant.TEMP_FOLDER_PATH+rootPath+"/"+lid;
			    String destination = CommonConstant.REAL_FOLDER_PATH+rootPath+"/"+lid;
				File srcDir = new File(source);
				File destDir = new File(destination);
				if (srcDir.exists() && srcDir.isDirectory()) {
					logger.info("[SRC] " + source);
			        logger.info("[DST] " + destination);
					FileUtils.copyDirectory(srcDir, destDir);
				}
				logger.info("[END] COPY");

				output.put("fileResult", "success");
				output.put("fileMsg", "success copy file");
			} catch (Exception e) {
				logger.error(e.getClass() + ": " + e.getMessage(), e);
				output.put("fileResult", "fail");
				output.put("fileMsg", "fail copy file");
			}
		} catch (Exception e) {
			logger.error(e.getClass() + ": " + e.getMessage(), e);
			output.put("fileResult", "fail");
			output.put("fileMsg", "unknown error");
		}

		logger.info("[END] /data/dataUpload.do");
		this.outputJSON(request, response, output);
	}
	
	@RequestMapping(value = "/dataDelete.do", method = { RequestMethod.GET, RequestMethod.POST })
	public void dataDelete(HttpServletRequest request, HttpServletResponse response) {
		logger.info("[BEG] /data/dataDelete.do");
		Map output = new Hashtable();
		
		try {
			String source = CommonConstant.TEMP_FOLDER_PATH;
			File srcDir = new File(source);
			if (srcDir.exists() && srcDir.isDirectory()) {
				logger.info("[SRC] " + source);
				FileUtils.cleanDirectory(srcDir);
			}
			
			output.put("result", "success");
			output.put("msg", "success delete file");
		} catch (Exception e) {
			logger.error(e.getClass() + ": " + e.getMessage(), e);
			output.put("result", "fail");
			output.put("msg", "fail delete file");
		}

		logger.info("[END] /data/dataDelete.do");
		this.outputJSON(request, response, output);
	}

}
