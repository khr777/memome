<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- <c:set var="pageTitle" value="메인" /> --%>
<%@ include file="../part/head.jspf"%>
<%@ include file="../part/toastuiEditor.jspf"%>

<c:if test="${boardCode ne 'memoYOU'  && boardCode ne 'memoME' }">
	<h1 class="con">
		<strong style="color: red;">${boardCode}</strong>게시판<strong
			style="color: blue;"> 글쓰기</strong>
	</h1>
</c:if>
<c:if test="${boardCode eq 'memoYOU' || boardCode eq 'memoME'}">
	<h1 class="con">
		<strong style="color: black;">${boardCode}</strong><strong
			style="color: blue;"> MEMO</strong>
	</h1>
</c:if>




<div class="not-table-box con margin-top-50">
	<form method="POST" action="${boardCode}-doWrite?mode=${param.mode}"
		class="table-box-vertical form1"
		onsubmit="ArticleWriteForm__submit(this); return false;">
		<input type="hidden" name="fileIdsStr" /> <input type="hidden"
			name="redirectUri" value="/usr/article/${board.code}-detail?id=#id" />
		<input type="hidden" name="relTypeCode" value="article" /> <input
			type="hidden" name="body" />
		<c:if test="${boardCode eq 'unicon' }">
			<input type="hidden" name="displayStatus" value="1" />
			<div class="invite-title">
				UNICON email 초대<i style="margin-left: 10px;"
					class="far fa-paper-plane"></i>
			</div>
			<div class="not-table-box-controler">
				<div class="form-control-box invite-control-box  flex flex-wrap">
					<input type="email" name="invite1" placeholder="이메일을 입력해주세요."
						maxlength="20" /> <input type="email" name="invite2"
						placeholder="이메일을 입력해주세요." maxlength="20" /> <input type="email"
						name="invite3" placeholder="이메일을 입력해주세요." maxlength="20" /> <input
						type="email" name="invite4" placeholder="이메일을 입력해주세요."
						maxlength="20" /> <input type="email" name="invite5"
						placeholder="이메일을 입력해주세요." maxlength="20" /> <input type="email"
						name="invite6" placeholder="이메일을 입력해주세요." maxlength="20" /> <input
						type="email" name="invite7" placeholder="이메일을 입력해주세요."
						maxlength="20" /> <input type="email" name="invite8"
						placeholder="이메일을 입력해주세요." maxlength="20" /> <input type="email"
						name="invite9" placeholder="이메일을 입력해주세요." maxlength="20" /> <input
						type="email" name="invite10" placeholder="이메일을 입력해주세요."
						maxlength="20" /> <input type="email" name="invite11"
						placeholder="이메일을 입력해주세요." maxlength="20" /> <input type="email"
						name="invite12" placeholder="이메일을 입력해주세요." maxlength="20" />
				</div>
			</div>
		</c:if>

		<div class="not-table-box-controler select flex flex-jc-sb">
			<input type="text" name="title" placeholder="제목을 입력해주세요." autofocus
				maxlength="200" />
			<c:if
				test="${boardCode ne 'free' && boardCode ne 'notice' && boardCode ne 'unicon' }">
				<select name="displayStatus" id="">
					<option value="1">공개</option>
					<option value="0">비공개</option>
				</select>
			</c:if>
			<c:if test="${boardCode eq 'free' || boardCode eq 'notice' || boardCode eq 'unicon' }">
				<input type="hidden" name="displayStatus" value="1"/>
			</c:if>

		</div>

		<div class="not-table-box-controler">
			<!-- 					<div> # 제목
![img](https://placekitten.com/200/287)
이미지는 이렇게 씁니다.

# 유투브 동영상 첨부

아래와 같이 첨부할 수 있습니다.

```youtube
https://www.youtube.com/watch?v=LmgWxezH7cc
```	</div> -->
			<script type="text/x-template"></script>
			<div data-relTypeCode="article" data-relId="0"
				class="toast-editor input-body"></div>
		</div>
		<div class="not-table-box-controler">
			<div class="form-control-box">
				<input type="text" name="tag" placeholder="#태그 입력" class="input-tag" />
			</div>
		</div>
		<div class="not-table-box-controler">
			<c:forEach var="i" begin="1" end="3" step="1">
				<c:set var="fileNo" value="${String.valueOf(i)}" />
				<c:set var="fileExtTypeCode"
					value="${appConfig.getAttachmentFileExtTypeCode('article', i)}" />
				<div class="file-box">
					<div class="form-control-box file flex">
						<div>첨부${fileNo}
							${appConfig.getAttachmentFileExtTypeDisplayName('article', i)}</div>
						<input type="file"
							accept="${appConfig.getAttachemntFileInputAccept('article', i)}"
							name="file__article__0__common__attachment__${fileNo}">
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="not-table-box-controler btns">
			<button type="button" class="btn add__file" onclick="add__file();">파일추가</button>
			<button type="button" class="btn close__file"
				onclick="close__file();">파일추가 닫기</button>
			<button type="submit" class="btn">write</button>

		</div>
	</form>
</div>


<script>
	function add__file() {
		$(".file-box").addClass("file-box-block");
		$(".add__file").addClass("add__file__none");
		$(".close__file").addClass("close__file__block");
	};
	function close__file() {
		$(".file-box").removeClass("file-box-block");
		$(".add__file").removeClass("add__file__none");
		$(".close__file").removeClass("close__file__block");
	};

	function ArticleWriteForm__submit(form) {
		if (isNowLoading()) {
			alert('처리중입니다.');
			return;
		}

		form.title.value = form.title.value.trim();

		if (form.title.value.length == 0) {
			alert('제목을 입력해주세요.');
			form.title.focus();
			return;
		}

		var bodyEditor = $(form).find('.toast-editor.input-body').data(
				'data-toast-editor');

		var body = bodyEditor.getMarkdown().trim();

		if (body.length == 0) {
			alert('내용을 입력해주세요.');
			bodyEditor.focus();
			return;
		}

		form.body.value = body;

		form.tag.value = form.tag.value.trim();
		form.tag.value = form.tag.value.replaceAll('-', '');
		form.tag.value = form.tag.value.replaceAll('_', '');
		form.tag.value = form.tag.value.replaceAll(' ', '');

		// 자바스크립트 특수 문자 일치 정규식
		var temp = form.tag.value;
		var count = (temp.match(/#/g) || []).length;

		var textCount = temp.split('#');
		textCount = textCount.length - 1;

		if (count != textCount) {
			alert('# 입력을 확인해주세요.');
			form.tag.focus();
			return;
		}

		console.log(textCount);
		if (count > 10) {
			alert('해시태그를 10개 이하로 입력해주세요.');
			form.tag.focus();
			return;
		}

		var maxSizeMb = 50;
		var maxSize = maxSizeMb * 1024 * 1024 // 50MB 

		if (form.file__article__0__common__attachment__1.value) {
			if (form.file__article__0__common__attachment__1.files[0].size > maxSize) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
		}

		if (form.file__article__0__common__attachment__2.value) {
			if (form.file__article__0__common__attachment__2.files[0].size > maxSize) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
		}

		if (form.file__article__0__common__attachment__3.value) {
			if (form.file__article__0__common__attachment__3.files[0].size > maxSize) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
		}
		// 실행순서 1번 
		// ★ 만약 needToUpload == false라면 다음꺼를 바로 실행시키고 꺼버린다.

		var startUploadFiles = function(onSuccess) {
			var needToUpload = form.file__article__0__common__attachment__1.value.length > 0;

			if (!needToUpload) {
				needToUpload = form.file__article__0__common__attachment__2.value.length > 0;
			}

			if (!needToUpload) {
				needToUpload = form.file__article__0__common__attachment__3.value.length > 0;
			}

			// ★ false라면 다음꺼인 onSuccess();를 실행하고 꺼버린다. 	
			if (needToUpload == false) {
				onSuccess();
				return;
			}

			var fileUploadFormData = new FormData(form);

			// 실행순서 2번 ajax 호출 시작 
			// 예) 실행시간 오후 1시
			$.ajax({
				url : './../file/doUploadAjax',
				data : fileUploadFormData,
				processData : false,
				contentType : false,
				dataType : "json",
				type : 'POST',
				success : onSuccess
			//-> 얘는 '함수'이다! 
			// -> onSuccess는 실행순서 1번의 function(onSuccess)의 onSuccess를 의미
			// ★★★★★ onSuccess는 3번보다 먼저 실행되지 않는다.
			// 실행순서 3번보다 위에 있어서 먼저 실행될 것 같지만 그렇지 않다.
			// ajax로 파일을 업로드 한 후, 한참 있다가 실행될 '예약 걸어놓은 함수'이다.
			// 예) 실행시간 오후 1시로부터 1년 뒤
			});
			// 실행순서 3번 ajax 호출 끝
			// 예) 실행시간 오후 2시
		}

		startLoading();
		// 실행순서 4번 
		// 다음꺼는 (function(data)부터 form.submit()까지이다.)
		startUploadFiles(function(data) {
			//'onSuccess는 startUploadfiles ajax 호출 결과 도착'을 의미한다.
			var fileIdsStr = '';

			// ★ 먼저 upload한 file의 id를 게시물 작성하면서 같이 보낸다.
			if (data && data.body && data.body.fileIdsStr) {
				fileIdsStr = data.body.fileIdsStr;
			}

			// 실행순서 5번 
			// 마지막에 file 번호들을 가지고 form의 정보를 전송한다.

			form.fileIdsStr.value = fileIdsStr;
			form.file__article__0__common__attachment__1.value = '';
			form.file__article__0__common__attachment__2.value = '';
			form.file__article__0__common__attachment__3.value = '';

			if (bodyEditor.inBodyFileIdsStr) {
				form.fileIdsStr.value += bodyEditor.inBodyFileIdsStr;
			}

			form.submit();

		});
		/* 
		 맨처음 실행되는 것은 startUploadFiles 함수이다.
		 위의 함수를 실행하면 옆에 function이 실행되는게 아니라 
		 실행순서 1번의 var startUploadFiles = ~~~ { 이게 실행된다. ! }
		 */
	}

	function ArticleWriteForm__init() {
		$('form input[type="email"][name^="invite"]').click(function() {
			$(this).next().addClass('block');
		});
	}

	ArticleWriteForm__init();
</script>

<style>
.table-box {
	margin-top: 50px;
}

.border-red-3 {
	border: 3px solid red;
}

.table-box table th {
	text-align: center;
}

.table-box {
	
}

.btn {
	padding: 0 25px;
	font-size: 1rem;
}

@media ( max-width :800px) {
	.not-table-box .not-table-box-controler input:first-child {
		height:42px;
	}

	.not-table-box .not-table-box-controler input {
		width: 90%;
		font-size: 1.3rem;
		font-weight: bold;
		height: 50px;
	}
	.not-table-box .not-table-box-controler input:last-child {
		width: 100%;
		font-size: 1.1rem;
		font-weight: bold;
		height: 40px;
	}
	.not-table-box .not-table-box-controler input:nth-child(2) {
		width: 120%;
	}
	.not-table-box .not-table-box-controler .file-box {
		width: 100%;
		margin: 0;
	}
	.not-table-box .not-table-box-controler .file-box .file div {
		width: 80px;
	}
	.not-table-box .not-table-box-controler .file-box .file {
		width: 100%;
		padding: 10px;
	}
	.not-table-box .not-table-box-controler .file-box div, .not-table-box .not-table-box-controler .file-box input
		{
		margin:0;
	}
	 .not-table-box .not-table-box-controler .invite-control-box input {
		width: 200px;
		height: 40px;
		font-size: 0.8rem;
		font-weight: normal;
	}
	
	 .btns  {
		max-width:400px;
	}
	
	 .btns button {
		max-width:120px;
	}
	
}
</style>







<%@ include file="../part/foot.jspf"%>