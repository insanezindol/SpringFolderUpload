package com.wizcm.common;

import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

public class CommonUtils {

	public static HashMap<String, String> getAllParameters(HttpServletRequest request) {
		HashMap<String, String> param = new HashMap<String, String>();
		Enumeration<?> requestParameters = request.getParameterNames();
		while (requestParameters.hasMoreElements()) {
			String element = (String) requestParameters.nextElement();
			String value = request.getParameter(element);
			if (element != null && value != null) {
				param.put(element, value);
			}
		}
		return param;
	}

	public static String getCookieValue(Cookie[] cookies, String name) {
		if (cookies == null)
			return null;
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals(name))
				return cookie.getName();
		}
		return null;
	}

	public static boolean isEmpty(String str) {
		if (str == null)
			return true;
		if ("".equals(str))
			return true;
		return false;
	}

	public static boolean isNumeric(Object obj) {
		try {
			if (obj == null)
				return false;
			Double.parseDouble(obj.toString());
			return true;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	public static boolean isStringDouble(String s) {
		try {
			Double.parseDouble(s);
			return true;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	// 전화번호 convert 01012345678 -> 010-1234-5678
	public static String convertPhone(String strPhonenum) {
		if (isEmpty(strPhonenum))
			return "";
		if (strPhonenum.length() == 10) {
			return strPhonenum.substring(0, 3) + "-" + strPhonenum.substring(3, 6) + "-" + strPhonenum.substring(6, 10);
		} else {
			return strPhonenum.substring(0, 3) + "-" + strPhonenum.substring(3, 7) + "-" + strPhonenum.substring(7, 11);
		}
	}

	public static String replaceXSSCheck(String word) throws Exception {
		if (word != null && !word.equals("")) {
			word = replaceStr(word, "<SCRIPT", "<X-SCRIPT");
			word = replaceStr(word, "VBSCRIPT", "X-VBSCRIPT");
			word = replaceStr(word, "JAVASCRIPT", "X-JAVASCRIPT");
			word = replaceStr(word, "<script", "<x-script");
			word = replaceStr(word, "vbscript", "x-vbscript");
			word = replaceStr(word, "javascript", "x-javascript");
			word = replaceStr(word, "<object", "x-object");
			word = replaceStr(word, "<applet", "x-applet");
			word = replaceStr(word, "<embed", "x-embed");
			word = replaceStr(word, "<form", "x-form");
			word = replaceStr(word, "<img", "x-img");
			word = replaceStr(word, "<xml", "x-xml");
			word = replaceStr(word, "<a href", "x-a href");
			// word = replaceStr(word, "&", "&#38");
			word = replaceStr(word, "<", "&lt;");
			word = replaceStr(word, ">", "&gt;");
			word = replaceStr(word, "\'", "`");
			word = replaceStr(word, "\"", "&quot;");
			// word = replaceStr(word, "(", "&#40");
			// word = replaceStr(word, ")", "&#41");
			// word = replaceStr(word, "#", "&#35");
			// word = replaceStr(word, "\'", "#39");
			// word = replaceStr(word, "\"", "&#34");
			// word = replaceStr(word, "/", "&#47");
			// word = replaceStr(word, "\\", "&#92");
			// word = replaceStr(word, ":", "&#59");

			word = replaceStr(word, "onabort", "");
			word = replaceStr(word, "onactivate", "");
			word = replaceStr(word, "onafterprint", "");
			word = replaceStr(word, "onafterupdate", "");
			word = replaceStr(word, "onbeforeactivate", "");
			word = replaceStr(word, "onbeforecopy", "");
			word = replaceStr(word, "onbeforecut", "");
			word = replaceStr(word, "onbeforedeactivate", "");
			word = replaceStr(word, "onbeforeeditfocus", "");
			word = replaceStr(word, "onbeforepaste", "");
			word = replaceStr(word, "onbeforeprint", "");
			word = replaceStr(word, "onbeforeunload", "");
			word = replaceStr(word, "onbeforeupdate", "");
			word = replaceStr(word, "onblur", "");
			word = replaceStr(word, "onbounce", "");
			word = replaceStr(word, "oncellchange", "");
			word = replaceStr(word, "onchange", "");
			word = replaceStr(word, "onclick", "");
			word = replaceStr(word, "oncontextmenu", "");
			word = replaceStr(word, "oncontrolselect", "");
			word = replaceStr(word, "oncopy", "");
			word = replaceStr(word, "oncut", "");
			word = replaceStr(word, "ondataavailable", "");
			word = replaceStr(word, "ondatasetchanged", "");
			word = replaceStr(word, "ondatasetcompletev", "");
			word = replaceStr(word, "ondblclick", "");
			word = replaceStr(word, "ondeactivate", "");
			word = replaceStr(word, "ondrag", "");
			word = replaceStr(word, "ondragend", "");
			word = replaceStr(word, "ondragenter", "");
			word = replaceStr(word, "ondragleave", "");
			word = replaceStr(word, "ondragover", "");
			word = replaceStr(word, "ondragstart", "");
			word = replaceStr(word, "ondrop", "");
			word = replaceStr(word, "onerror", "");
			word = replaceStr(word, "onerrorupdate", "");
			word = replaceStr(word, "onfilterchange", "");
			word = replaceStr(word, "onfinish", "");
			word = replaceStr(word, "onfocus", "");
			word = replaceStr(word, "onfocusin", "");
			word = replaceStr(word, "onfocusout", "");
			word = replaceStr(word, "onhelp", "");
			word = replaceStr(word, "onkeydown", "");
			word = replaceStr(word, "onkeypress", "");
			word = replaceStr(word, "onkeyup", "");
			word = replaceStr(word, "onlayoutcomplete", "");
			word = replaceStr(word, "onload", "");
			word = replaceStr(word, "onlosecapture", "");
			word = replaceStr(word, "onmousedown", "");
			word = replaceStr(word, "onmouseenter", "");
			word = replaceStr(word, "onmouseleave", "");
			word = replaceStr(word, "onmousemove", "");
			word = replaceStr(word, "onmouseout", "");
			word = replaceStr(word, "onmouseover", "");
			word = replaceStr(word, "onmouseup", "");
			word = replaceStr(word, "onmousewheel", "");
			word = replaceStr(word, "onmove", "");
			word = replaceStr(word, "onmoveend", "");
			word = replaceStr(word, "onmovestart", "");
			word = replaceStr(word, "onpaste", "");
			word = replaceStr(word, "onpropertychange", "");
			word = replaceStr(word, "onreadystatechange", "");
			word = replaceStr(word, "onreset", "");
			word = replaceStr(word, "onresize", "");
			word = replaceStr(word, "onresizeend", "");
			word = replaceStr(word, "onresizestart", "");
			word = replaceStr(word, "onrowenter", "");
			word = replaceStr(word, "onrowexit", "");
			word = replaceStr(word, "onrowsdelete", "");
			word = replaceStr(word, "onrowsinserted", "");
			word = replaceStr(word, "onscroll", "");
			word = replaceStr(word, "onselect", "");
			word = replaceStr(word, "onselectionchange", "");
			word = replaceStr(word, "onselectstart", "");
			word = replaceStr(word, "onstart", "");
			word = replaceStr(word, "onstop", "");
			word = replaceStr(word, "onsubmit", "");
			word = replaceStr(word, "onunload", "");
		}

		return word;
	}

	public static String replaceStr(String org, String var, String tgt) throws Exception {
		StringBuffer str = new StringBuffer("");
		int end = 0;
		int begin = 0;
		if (org == null || org.equals(""))
			return org;

		try {
			while (true) {
				end = org.indexOf(var, begin);
				if (end == -1) {
					end = org.length();
					str.append(org.substring(begin, end));
					break;
				}
				str.append(org.substring(begin, end) + tgt);
				begin = end + var.length();
			}
		} catch (Exception e) {
			throw new Exception(e.toString());
		}
		return str.toString();
	}

	public static String convertLyrics(String word) throws Exception {
		if (word != null && !word.equals("")) {
			word = word.replaceAll("&#39;", "`");
		}
		return word;
	}
	
	public static String replaceCharView(String targetStr){
		String returnStr = targetStr;  
		try{
			returnStr = replaceStr(returnStr,"&amp;","n");
			returnStr = replaceStr(returnStr,"'","`");
			returnStr = replaceStr(returnStr,"\""," ");
			returnStr = replaceStr(returnStr,"&","n");
			returnStr = replaceStr(returnStr,"＆","n");
			returnStr = replaceStr(returnStr,"<","[");
			returnStr = replaceStr(returnStr,">","]");
			returnStr = replaceStr(returnStr,"%","％");
			returnStr = replaceStr(returnStr,"#","＃");
			returnStr = replaceStr(returnStr,"@"," ");
		}catch(Exception e){} 

		return returnStr;
	}

}
