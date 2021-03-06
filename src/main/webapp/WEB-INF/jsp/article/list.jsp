<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- <c:set var="pageTitle" value="메인" /> --%>
<%@ include file="../part/head.jspf"%>

<c:if test="${boardCode eq 'notice' }">
	<h1 class="con visible-on-md-up">
		<strong style="color: orange;">${boardCode}</strong>게시판
	</h1>
</c:if>
<c:if test="${boardCode eq 'free' }">
	<h1 class="con visible-on-md-up">
		<strong style="color: gold;">${boardCode}</strong>게시판
	</h1>
</c:if>

<!-- PC 모드 -->
<c:if test="${boardCode eq 'free' }">
	<div class="free-top-bar visible-on-md-up con">
		<h1>Story</h1>
		<h2>메모미의 다양한 이야기들을 만나보세요</h2>
	</div>
</c:if>

<!-- 모바일 모드 -->
<c:if test="${boardCode eq 'free' }">
	<div class="free-top-bar-mobile visible-on-sm-down con">
		<div class="title">Story</div>
		<div class="body">메모미의 다양한 이야기들을 만나보세요</div>
	</div>
</c:if>

<%-- <c:if test="${boardCode eq 'notice' }">
	<div class="free-top-bar-mobile visible-on-sm-down con">
		<div class="title">Notice</div>
		<div class="body">메모미와 함께 시작하세요</div>
	</div>
</c:if> --%>

<style>
.free-top-bar {
	position: absolute;
	top: 130px;
	right: 15%;
	text-align: right;
}
</style>



<c:if test="${member.id eq 1 && boardCode eq 'notice' }">
	<div
		class="write-btn con margin-top-50 flex flex-jc-fe visible-on-md-up">
		<button type="button" class="btn black  "
			onclick="location.href='../article/${boardCode}-write'">글쓰기</button>
	</div>
	<div class="write-btn con  flex flex-jc-fe visible-on-sm-down">
		<button type="button" class="btn black  "
			onclick="location.href='../article/${boardCode}-write'">글쓰기</button>
	</div>
</c:if>
<c:if test="${boardCode eq 'notice' == false }">
	<div
		class="write-btn con margin-top-50 flex flex-jc-fe visible-on-md-up">
		<button type="button" class="btn black  "
			onclick="location.href='../article/${boardCode}-write'">글쓰기</button>
	</div>
	<div class="write-btn con  flex flex-jc-fe visible-on-sm-down">
		<button type="button" class="btn black  "
			onclick="location.href='../article/${boardCode}-write'">글쓰기</button>
	</div>
</c:if>

<c:if test="${boardCode eq 'memberPage' == false }">
	<c:if test="${boardCode eq 'notice' }">
		<script>
			$(document).ready(function() {
				$('.search').addClass('margin-top-105');
			});
		</script>
	</c:if>
	<c:if test="${boardCode eq 'notice' && loginedMemberId == 1}">
		<script>
			$(document).ready(function() {
				$('.search').removeClass('margin-top-105');
			});
		</script>
	</c:if>

	<div class="search con flex flex-jc-fe padding-10-0">
		<div class="search-box ">
			<!-- method="get"은 생략 가능하다. 무엇인지 찾아보기. method="get"-->
			<form action="../article/${boardCode}-list" class="flex">
				<input type="hidden" name="page" value="1" />
				<!-- 검색하면 page를 모두 0으로 초기화해야 하니까..? -->
				<input type="hidden" name="searchKeywordType" value="tag" /> <input
					type="hidden" name="boardCode" value="${boardCode}" />
				<div class="tag-box flex flex-jc-sb">
					<input type="text" name="searchKeyword"
						placeholder="검색할 태그를 입력해주세요." value="${param.searchKeyword}"
						class="box" />
					<button type="submit" class="search-button btn black">
						<i style="font-size: 1.2rem;" class="fas fa-search"></i>
					</button>
				</div>
			</form>
		</div>
	</div>
</c:if>

<div class="con total-box" style="font-size: 1.2rem;">총 게시물 수 :
	${totalCount}</div>
<div class="memo-table-list con  ">
	<c:forEach items="${articles}" var="article">
		<c:if test="${article.memberId == loginedMemberId  }">
			<div class="memo-table-list-box "
				onclick="location.href='../article/${boardCode}-modify?id=${article.id}&mode=${param.mode}'">
				<div class="contents-box">
					<div class="title">${article.title }</div>
					<div class="body">
						<c:forEach items="${hashtags}" var="hashtag">
							<c:if test="${article.id == hashtag.relId }">
								<strong><a
									href="../memo/${boardCode}-tagSearchResult?searchKeywordType=tag&searchKeyword=${hashtag.tag }&mode="${param.mode }">
										#${hashtag.tag}</a>&nbsp;&nbsp;&nbsp;&nbsp;</strong>
							</c:if>
						</c:forEach>
					</div>
					<div class="writer-box">
						<div class="writer">${article.extra.writer}</div>
						<div class="regDate">${article.regDate }</div>
					</div>
				</div>
				<div class="file-control-box">
					<c:set var="fileNo" value="${String.valueOf(3)}" />
					<c:set var="file"
						value="${article.extra.file__common__attachment[fileNo]}" />
					<c:if test="${file != null}">
						<c:if test="${file.fileExtTypeCode == 'video'}">
							<div class="video-box">
								<video controls
									src="/usr/file/streamVideo?id=${file.id}&updateDate=${file.updateDate}"></video>
							</div>
						</c:if>
						<c:if test="${file.fileExtTypeCode == 'img'}">
							<div class="img-box img-box-auto">
								<img
									src="/usr/file/img?id=${file.id}&updateDate=${file.updateDate}"
									alt="" />
							</div>
						</c:if>
					</c:if>
				</div>
			</div>
		</c:if>
	</c:forEach>
	<c:forEach items="${articles}" var="article">
		<c:if test="${article.memberId != loginedMemberId }">
			<div class="memo-table-list-box"
				onclick="location.href='${article.getDetailLink(board.code)}&memberId=${article.memberId }&mode=${param.mode }'">
				<div class="contents-box">
					<div class="title">${article.title }</div>
					<div class="body">
						<c:forEach items="${hashtags}" var="hashtag">
							<c:if test="${article.id == hashtag.relId }">
								<strong><a
									href="../memo/${boardCode}-tagSearchResult?searchKeywordType=tag&searchKeyword=${hashtag.tag }&mode="${param.mode }">
										#${hashtag.tag}</a>&nbsp;&nbsp;&nbsp;&nbsp;</strong>
							</c:if>
						</c:forEach>
					</div>
					<div class="writer-box">
						<div class="writer">${article.extra.writer}</div>
						<div class="regDate">${article.regDate }</div>
					</div>
				</div>
				<div class="file-control-box">
					<c:set var="fileNo" value="${String.valueOf(3)}" />
					<c:set var="file"
						value="${article.extra.file__common__attachment[fileNo]}" />
					<c:if test="${file != null}">
						<c:if test="${file.fileExtTypeCode == 'video'}">
							<div class="video-box">
								<video controls
									src="/usr/file/streamVideo?id=${file.id}&updateDate=${file.updateDate}"></video>
							</div>
						</c:if>
						<c:if test="${file.fileExtTypeCode == 'img'}">
							<div class="img-box img-box-auto">
								<img
									src="/usr/file/img?id=${file.id}&updateDate=${file.updateDate}"
									alt="" />
							</div>
						</c:if>
					</c:if>
				</div>
			</div>
		</c:if>
	</c:forEach>
</div>
<div class="con page-box ">
	<ul class="flex flex-jc-c">
		<c:forEach var="i" begin="1" end="${totalPage}" step="1">
			<li class="${i == cPage ? 'current' : ''}"><a
				href="?searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}&page=${i}"
				class="block">${i}</a></li>
		</c:forEach>
	</ul>

</div>


<style>
.memo-table-list {
	
}

.table-box {
	/* border:5px solid red; */
	
}

.table-box table {
	border: 5px solid black;
}

.page-box {
	/* border:10px solid red; */
	margin-bottom: 100px;
	margin-top: 100px;
}

input[type="submit"] {
	font-family: FontAwesome;
}

.search .search-box button {
	padding: 0 20px;
}

.search .search-box form .tag-box {
	padding: 10px 0;
	width: 240px;
	font-size: 1.5rem;
}

.search .search-box form .tag-box input {
	padding: 5px;
	margin-top: 5px;
	border: 1px solid black;
}

.page-box>ul>li>a {
	padding: 0 10px;
	text-decoration: underline;
	color: #787878;
}

.page-box>ul>li:hover>a {
	color: black;
}

.page-box>ul>li.current>a {
	color: red;
}

.memo-table-list .memo-table-list-box .file-control-box {
	height: 100%;
	width: 30%;
}

.memo-table-list .memo-table-list-box .file-control-box .img-box,
	.memo-table-list .memo-table-list-box .file-control-box .video-box {
	/* border:3px solid blue; */
	max-width: 100%;
	height: 100%;
	overflow: hidden;
}

.memo-table-list .memo-table-list-box .file-control-box img,
	.memo-table-list .memo-table-list-box .file-control-box video {
	/* object-fit: cover; */
	max-width: 100%;
}

.memo-table-list .memo-table-list-box {
	/* border: 3px solid red; */
	height: 160px;
	display: flex;
	padding-bottom: 10px;
	border-bottom: 3px solid black;
	margin-top: 20px;
}

.memo-table-list .memo-table-list-box:hover {
	cursor: pointer;
}

.memo-table-list .memo-table-list-box:first-child {
	margin-top: 50px;
}

.memo-table-list .memo-table-list-box .contents-box {
	/* border: 3px solid blue; */
	height: 100%;
	width: 80%;
}

.memo-table-list .memo-table-list-box .contents-box .title {
	/* border: 3px solid gold; */
	height: 60px;
	width: 100%;
	font-size: 2.5rem;
}

/* body를 태그로 바꿔서 사용중....  */
.memo-table-list .memo-table-list-box .contents-box .body {
	/* border: 3px solid orange; */
	margin-top: 30px;
	height: 30px;
	width: 100%;
	font-size: 1.1rem;
	opacity: 0.7;
}

.memo-table-list .memo-table-list-box .writer-box {
	/* border: 3px solid black; */
	height: 30px;
	display: flex;
}

.memo-table-list .memo-table-list-box .writer-box .writer, .regDate {
	/* border: 3px solid green; */
	width: 200px;
	height: 30px;
	text-align: left;
}

@media ( max-width :800px ) {
	.search {
		margin-right: 1.3px;
	}
	.search .search-box button {
		padding: 0 20px;
	}
	.search .search-box form .tag-box {
		width: 220px;
		font-size: 1.5rem;
	}
	.total-box {
		width: 50%;
		margin-right: 0;
		margin-top: 20px;
		text-align: right;
	}
	.memo-table-list {
		margin-top: 80px;
	}
	.memo-table-list .memo-table-list-box .contents-box .title {
		font-size: 1.3rem;
		width: 95%;
	}
	.memo-table-list .memo-table-list-box .file-control-box {
		height: 38%;
	}
	.memo-table-list .memo-table-list-box .file-control-box img {
		height: 100%;
		width: 100%;
	}
	.memo-table-list .memo-table-list-box {
		height:145px;
	}

	/* body를 태그로 바꿔서 사용중....  */
	.memo-table-list .memo-table-list-box .contents-box .body {
		width: 124%;
		height: 50px;
		font-size: 0.8rem;
		opacity: 0.7;
		margin-top: 10px;
		/* word-break: keep-all; */
	}
	.memo-table-list .memo-table-list-box .writer-box {
		display: flex;
		font-size: 0.9rem;
	}
	.free-top-bar-mobile {
		position: absolute;
		top: 100px;
		left: 4%;
		font-weight: bold;
	}
	.free-top-bar-mobile .title {
		font-size: 1.8rem;
	}
	.free-top-bar-mobile .body {
		font-size: 1.3rem;
		
	}
	.write-btn {
		margin-top: 250px;
		margin-bottom: 0;
	}
	.memo-table-list .memo-table-list-box .writer-box {
		margin-top:0px;
		height:20px;
	}
	.memo-table-list .memo-table-list-box .writer-box .writer, .regDate {
		/* border: 3px solid green; */
		width: 280px;
		height:0;
	}
}
</style>



<%@ include file="../part/foot.jspf"%>