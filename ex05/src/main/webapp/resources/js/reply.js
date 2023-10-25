// 화면내에서 JavaScript 처리를 하다 보면 어느순간 이벤트 처리와 DOM처리, Ajax처리 등이 마구 섞여서 유지보수 하기 힘든 코드를 만드는 경우가 많다.
// 이런 경우를 대비해서 좀 더 JavaScript를 하나의 모듈처럼 구성하는 방식을 이용하는 것이 좋다.
// JavaScript에서 가장 많이 사용하는 패턴 중 하나는 모듈 패턴이다.
// 모듈 패턴은 쉽게 말해서 관련 있는 함수들을 하나의 모듈처럼 묶음으로 구성하는 것을 의미한다.
// JavaScript의 클로저를 이용하는 것이 대표적인 방법이다.

// 모듈 구성하기
// 모듈 패턴은 쉽게 말해서 Java의 클래스처럼 JavaScript를 이용해서 메서드를 가지는 객체를 구성한다.
// 모듈 패턴은 JavaScript의 즉시 실행함수와 '{}'를 이용해서 객체를 구성한다.


console.log("Reply Module.......");

/*
JavaScript의 즉시 실행함수는 ()안에 함수를 선언하고 바깥쪽에서 실행해 버린다.
즉시 실행함수는 함수의 실행 결과가 바깥쪽에 선언된 변수에 할당된다.
위의 코드에서는 replyService라는 변수에 name이라는 속성에'AAAA'라는 속성값을 가진 객체가 할당된다.*/
/* p.401
var replyService = (function(){

	return {name : "AAAA"};
	
})();
p.402
var replyService = (function(){

	function add(reply, callback){
		console.log("reply...........");
	}
	
	return {add:add};
	
})();
*/
// 모듈 패턴은 즉시 실행하는 함수 내부에서 필요한 메서드를 구성해서 객체를 구성하는 방식이다.
/* 	개발자 도구에서는 ReplyService 객체의 내부에는 add라는 메서드가 존재하는 형태로 보이게 된다.
   	외부에서는 replyService.add(객체,콜백)를 전달하는 형태로 호출할 수 있는데,
   	Ajax호출은 감쳐져 있기 때문에 코드를 좀 더 깔끔하게 작성할 수 있다.
*/

var replyService = (function(){
	// p.403
	function add(reply, callback){
		console.log("reply...........");
		
		$.ajax({
		type : 'post',
		url : '/replies/new',
		data : JSON.stringify(reply),
		contentType : "application/json; charset=utf-8",
		success : function(result, status, xhr){
			if(callback){
				callback(result);
				}
			},
			error : function(xhr, status, er){
				if(error){
				error(er);
				}
			}
		})
	
	}
	
	// p.406 jQuery의 getJSON() 사용
	/*jQuery의 getJSON() 메소드는 java의 static 메서드와 유사하다 jQuery에서는 전역메서드라 불린다.
	 첫번째 매개변수로 JSON파일을 로드한다.
	 두번째 매개변수(콜백함수)에서 JSON 파일을 이용하여 로드된 데이터를 처리한다.
	 콜백함수는 로드된 데이터를 인자로 넘겨 받는다(JSON데이터를 참조하기 위해 daga 변수를 사용하고 있다.)
	 p. 437 getList 수정으로 그전 로직 주석 처리
	function getList(param, callback, error){
		
		var bno = param.bno;
		var page = param.page || 1;
		
			$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
				function(data){
					if(callback){
						callback(data);
					}
				}).fail(function(xhr, status, err){
				if(error){
					error();
					}
			});
	
	}
	*/
	
	function getList(param, callback, error){
		
		var bno = param.bno;
		var page = param.page || 1;
		
			$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
				function(data){
					if(callback){
						//callback(data); 댓글 목록만 가져오는 경우
						callback(data.replyCnt, data.list); // 댓글 숫자와 목록을 가져오는 경우
					}
				}).fail(function(xhr, status, err){
				if(error){
					error();
					}
			});
	
	}
	// p.408 댓글 삭제와 갱신
	function remove(rno, callback, error){
		$.ajax({
			type : 'delete',
			url : '/replies/' + rno,
			success : function(deleteResult, status, xhr){
				if(callback){
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	// p.410 댓글 수정
	
	function update(reply, callback, error){
		
		console.log("RNO : " + reply.rno);
		
		$.ajax({
			type : 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error : function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	// p.412 댓글 조회 처리
	function get(rno, callback, error){
		$.get("/replies/" + rno +".json", function(result){
			
			if(callback){
				callback(result);
			}
		
		}).fail(function(xhr, status, err){
			if(error){
				error();
			}
		});
	}
	
	// p.417 시간 처리 
	function displayTime(timeValue){
		console.log("displayTime 호출 ");
		var today = new Date();
		
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		var str = "";
		if(gap < (1000 * 60 * 60 * 24)){
			
			var hh = dateObj.getHours();
			var mm = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [ (hh > 9 ? '' : '0') + hh, ':', (mm > 9 ? '' : '0') + mm,
				':', (ss > 9 ? '' : '0') + ss ].join('');
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
			var dd = dateObj.getDate();
			
			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/',
				(dd > 9 ? '' : '0') + dd ].join('');
		}
	}
	
	return {
		add:add,
		getList : getList,
		remove : remove,
		update : update,
		get : get,
		displayTime : displayTime
	};
		
	
})();
