(function($) {
	/**
	 * 자바스크립트가 로드될 때까지 기다린후 화면제어 로직을 처리하는 스크립트의 init 함수를 호출한다.
	 */
	var	ScriptInvoker	= function(scriptName) {
		this.scriptName	= scriptName;	// 실행할 스크립트 객체명
		this.timeVar	= undefined;	// timeout 이벤트의 참조 변수
		this.attrValue	= undefined;	// 객체에 전달할 데이터 값
		this.attrName;					// 객체에 생성할 데이터

		/**
		 * script에 전달할 데이터를 설정한다..
		 * @param attrName  변수명
		 * @param attrValue 데이터, Object, string, int 등
		 */
		this.setAttribute	= function(attrName, attrValue) {
			this.attrName	= attrName;
			this.attrValue	= attrValue;
		};

		/**
		 * script의 init를 호출한다.
		 */
		this.invoke	= function() {
			var	self	= this;

			this.timeVar	= setTimeout(function() {
				var	func	= window[self.scriptName];

				if (func) {
					if (self.attrName) {
						func[self.attrName]	= self.attrValue;
					}

					func.init();
					self.clearTime();
				} else {
					self.invoke();
				}
			});
		};

		/**
		 * 타임아웃을 해제한다.
		 */
		this.clearTime	= function() {
			clearTimeout(this.timeVar);
		};
	};

    var	common	= function() {

    };

	common.string	= {
			/**
			 * 문자열의 앞뒤 공백문자를 제거한다.
			 * 
			 * @param str 문자열
			 * @return 앞뒤 공백문자가 제거된 문자열
			 */
			trim : function(str) {
				return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
			},

			/**
			 * 문자열의 일부를 지정한 문자열로 교체합니다.
			 * 
			 * @param str 문자열
			 * @param findStr 교체 대상 문자열
			 * @param replaceStr 교체할 문자열
			 * @return 지정한 문자열로 교체된 문자열
			 */
			replace : function(str, findStr, replaceStr) {
				if (!str) {
					return str;
				}

				return str.replace(new RegExp(findStr, "g"), replaceStr);
			}
	};			
    
    
    
    common.invoker	= {
		/**
		 * @param scriptName  javascript 객체이름
		 * @param varName  객체에 추가할 변수이름
		 * @param jsonStr 객체에 담을 변수, Object or primitive type
		 */
    	
		invoke : function(scriptName, varName, jsonStr) {
			var	invoker	= new ScriptInvoker(scriptName);
			invoker.setAttribute(varName, jsonStr);
			invoker.invoke();
		}
	};

	common.json		= {
		/**
		 * 데이타 객체를 쿼리스트링으로 변환한다.
		 *
		 * 예)
		 *     var json = { name : "kim", age : 10 };
		 *     var str  = common.json.toQueryString(json);
		 *
		 *     => str == "&name=kim&age=10"
		 *
		 * @param JSON 데이타 객체
		 * @return 쿼리스트링
		 */
		toQueryString : function(dataObject) {
			var	result	= "";

			for (var prop in dataObject) {
				result	+= "&" + prop + "=" + dataObject[prop];
			}

			return result;
		},

		/**
		 *
		 * JSON 객체를 문자열로 변환한다.
		 *
		 * 예)
		 *     var jsonObject = new Object();
		 *     
		 *     jsonObject.name = "kim";
		 *     jsonObject.age  = 10;
		 *
		 *     var convertedString = common.json.getJSONString(jsonObject);
		 *
		 *     => convertedString == {name:"kim", age : 10 }
		 *
		 * @param JSON 데이타 객체
		 * @return JSON 문자열
		 */
		getJSONString : function(object) {
			return $.toJSON(object);
		},

		dummy : function() {
			// not used
		},
		toJSON : function(values) {
			var	json	= {};

			$.each(values, function() {
				var	value	= (null != this.value) ? this.value : '';

				if (null != json[this.name]) {
					if (!json[this.name].push) {
						json[this.name]	= [json[this.name]];
					}

					json[this.name].push(value);
				} else {
					json[this.name]	= value;
				}
			});

			return json;
		}		
	};

	common.http		= {
		ajax : function(opts) {
			// default options
			var	settings	= {
				url					: "",
				target				: document.body,
				errorProcType		: "",				// "alert" 에러처리 방식 alert, html
				data				: {},					// 요청 데이터
				success				: function() {			// 응답성공시 실행할 함수
				},
				error				: function(xhr, statusText) {	// 에러발생시 실행할 함수
				},
				dataType			: "json",				// 응답데이터 유형  json, xml, html, script, json, jsonp, text
				useWrappedObject	: true,					// 응답결과를 ResponseData 객체에 넣어서 사용할지 여부
				type				: "post",				// 전송방법 기본값  post, (get/post)
				sendDataType		: "undefined",			// 전송 데이터 타입 json, (json/string)
				animation			: false					// 로딩 이미지 표시
			};

			$.extend(settings, opts);
			// 서버 프레임워크에서 에러발생시 처리방법을 결정하기 위해 _REQ_DATA_TYPE_ 에 dataType을 값을 설정함.
			// 서버에서 useWrappedObject가 true인 경우에는 ResponseData.class를 사용하여 오류정보를 반환함.
			if (0 <= settings.url.indexOf('?')) {
				settings.url	= common.string.trim(settings.url)
									+ '&_REQ_DATA_TYPE_=' + settings.dataType + "&_USE_WRAPPED_OBJECT_=" + settings.useWrappedObject;
			} else {
				settings.url	= common.string.trim(settings.url)
									+ '?_REQ_DATA_TYPE_=' + settings.dataType + "&_USE_WRAPPED_OBJECT_=" + settings.useWrappedObject;
			}

			if (settings.sendDataType == "json") {				
				var	sendData	= (typeof settings.data == "object") ? common.json.getJSONString(settings.data) : settings.data;
					sendData	= "_REQ_JSON_OBJECT_=" + encodeURIComponent(sendData);
			} else if(settings.sendDataType == "form"){				
				sendData	= settings.data;
			} else {
				var	sendData	= (typeof settings.data == "object") ? common.json.getJSONString(settings.data) : settings.data;
				sendData	= common.json.toQueryString(settings.data);

				if ("post" == settings.type) {
					sendData	= sendData.replace(/[+]/g, '%2B');
				}
			}

			// make the default timeout value.
			var	timeoutValue	= (settings.timeout) ? settings.timeout : 10000;	// default 10초

			// make a loading image
			var	ctime		= new Date().getTime();
			var	randomVal	= Math.floor(Math.random() * 100) + 1;
			var	divId		= "DIV" + ctime + "_" + randomVal;

			var	options	= {
				url		: settings.url,		// 요청URL
				async	: settings.async,	// 동기식
				data	: sendData,
				beforeSend	: function() {
					if (!settings.animation) {
						return;
					}

					// before sending a request, display the loading image.
					var	target	= (typeof settings.target == "string") ? $(settings.target).get(0) : settings.target;
					var	offset	= $(target).offset();
				},
				success	: function(responseData, statusText) {					

					// 응답데이타가 없다면 아무것도 하지 않음.
					if (!responseData) {
						return;
					}

					// server에서 json으로 되돌리면 object로 인식하는 경우
					if (settings.useWrappedObject) {
						var	resObject	= responseData;

						//server framework에서 반환하는 구조확인
						if (resObject.responseCode) {
							if (parseInt(resObject.responseCode) == 0) {
								if (settings.success) {
									settings.success(resObject, statusText);
								}
							} else if (parseInt(resObject.responseCode) == 500) {
								if (settings.errorProcType == "alert") {
									//alert("시스템 오류입니다.\n" + resObject.systemError);
									common.ui.showAjaxError(resObject);
									settings.error(resObject, statusText);
								}
							} else {
								if (settings.errorProcType == "alert") {
									//alert("오류코드:" + resObject.responseCode + "\n"
									//        + "오류메시지:" + resObject.responseText);
									common.ui.showAjaxError(resObject);
									settings.error(resObject, statusText);
								}
							}
						} else {
							settings.success(responseData, statusText); // callback 함수 직접 호출
						}
					} else {
						if (settings.dataType == "json") {
							// JSON 문자열을 JSON 객체로 변환
							var	resObject	= window["eval"]("(" + responseData + ")");

							//server framework에서 반환하는 구조확인
							if (resObject.responseCode) {
								if (parseInt(resObject.responseCode) == 0) {
									if (settings.success) {
										settings.success(resObject, statusText);
									}
								} else if (parseInt(resObject.responseCode) == 500) {
									if (settings.errorProcType == "alert") {
										//alert("시스템 오류입니다.\n" + resObject.systemError);
										common.ui.showAjaxError(resObject);
										settings.error(resObject, statusText);
									}
								} else {
									if (settings.errorProcType == "alert") {
										//alert("오류코드:" + resObject.responseCode + "\n"
										//        + "오류메시지:" + resObject.responseText);
										common.ui.showAjaxError(resObject);
										settings.error(resObject, statusText);
									}
								}
							} else {
								// JSON문자열을 callback 함수로 bypass.
								settings.success(responseData, statusText);
							}
						} else if (settings.dataType == "xml") {
							//  XML로 통신하는 방식은 기본적으로 지원하지 않음.
							//  callback 함수로 bypass
							if (settings.success) {
								settings.success(responseData, statusText);
							} else {
								settings.error(responseData, statusText);
							}
						} else { // html, text
							// text, html 처리방법은 응답결과를 그대로 callback 함수로 패스
							if (settings.success) {
								settings.success(responseData, statusText);
							} else {
								settings.error(responseData, statusText);
							}
						}
					}
				},
				// 통신오류
				error	: function(xhr, statusText) {

					if (settings.error) {
						if (settings.errorProcType == "alert") {
							var	errCode	= xhr.status;
							var	errMsg	= "";

							switch (xhr.status) {
								case 0:
									errMsg	= "서버에 접속할 수 없습니다.";
									break;
								case 404:
									errMsg	= "요청하신 페이지를 찾을 수 없습니다.";
									break;
								case 500:
									errMsg	= "서버에서 오류가 발생했습니다.";
									break;
								case 408:
									errMsg	= "서버로 부터 응답이 없습니다(Timeout).";
									break;
								default:
									errMsg	= "알수없는 오류가 발생했습니다.";
									break;
							}

							var	resObject	= {
								reqURL			: settings.url,
								responseCode	: errCode,
								responseText	: errMsg,
								systemError		: '수신된 서버의 오류 메시지가 없습니다.'
							};

							common.ui.showAjaxError(resObject);
							settings.error(xhr, statusText);
						}
					}
				},
				type : settings.type, // POST / GET
				timeout : timeoutValue,
				complete : function(xhr) {
					// 호출이 안되는 이유는???
				}
			};

			$.ajax(options);
		},
	};
	
	window.common	= common;
})(jQuery);


