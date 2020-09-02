<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- <c:set var="pageTitle" value="메인" /> --%>
<%@ include file="../part/head.jspf"%>

<h1 class="con">
	<strong style="color: red;">${board.code}</strong>
	<c:if test="${board.code eq 'memome'}"> 
			나의 메모장
	</c:if>
	<c:if test="${board.code eq 'memoyou'}">
			모두의 메모장
	</c:if>

</h1>
<div class="con margin-top-50 flex flex-jc-fe">
	<button type="button"
		onclick="location.href='../article/${boardCode}-write'">메모 작성</button>
</div>
<%-- <div class="con margin-top-20 flex flex-jc-fe border-red-1">
	<button type="button"
		onclick="location.href='../memo/${boardCode}-makeMemoCate'">메모
		폴더 생성</button>
</div> --%>
<div class="memo-table-box con flex flex-jc-sb flex-wrap">
	<c:forEach items="${articles}" var="article">
		<div class="memo-box  flex flex-jc-sa "
			onclick="location.href='${article.getDetailLink(board.code)}'"  style="overflow:auto;">

			<table>
				<colgroup>
					<col width="120" />
					<col width="200" />
				</colgroup>
				<tbody>
					<tr>
						<th>작성자</th>
						<td><a href="../memo/${article.extra.writer}-memoMemberPage?id=${article.memberId}">${article.extra.writer}</a></td>
					</tr>
					<tr>
						<th>작성일</th>
						<td>${article.updateDate}</td>
					</tr>
					<tr>
						<th>제목</th>
						<td>${article.title}</td>
					</tr>

					<tr style="height:250px;">
						<th>메모</th>
						<td>${article.body}</td>
					</tr>
					<c:if test="${article.extra.file__common__attachment['1'] != null}">
						<tr>
							<th>첨부 파일 1</th>
							<td>
								<div class="img-box">
									<img
										src="/usr/file/showImg?id=${article.extra.file__common__attachment['1'].id}&updateDate=${article.extra.file__common__attachment['1'].updateDate}"
										alt="image not supported" />
								</div>
							</td>
						</tr>
					</c:if>
					<tr>
						<th>태그</th>
						<td><c:forEach items="${hashtags}" var="hashtag">
						<c:if test="${article.id == hashtag.relId }">
				<strong style="font-size:0.8rem;" ><a href="#">#${hashtag.tag}</a>&nbsp;&nbsp;&nbsp;&nbsp;</strong>
							</c:if></c:forEach></td>
					</tr>
				</tbody>
			</table>

		</div>
	</c:forEach>
</div>



<style>
::-webkit-scrollbar {
					/* 스크롤바 전체 영역 */
  width: 10px;
} 
::-webkit-scrollbar-track {
					/* 스크롤이 움직이는 영역  */
      background-color: #f9f9f9;
} 
::-webkit-scrollbar-thumb {
					/*  스크롤  */
      background-color: #ccff66; 
  border-radius:30px;
} 
::-webkit-scrollbar-button:start:decrement, 
::-webkit-scrollbar-button:end:increment {
					/*  스크롤의 화살표가 포함된 영역   */
  display:block;
  height:8px;
  background-color: #000;
} 
::-webkit-scrollbar-corner {
					/*  상하+좌우 스크롤이 만나는 공간   */
      background-color: red;
} 

/* 스크롤 상하방향 */

::-webkit-scrollbar-button:vertical:incremen
::-webkit-scrollbar-button:vertical:decrement


/* 스크롤 좌우방향 */
::-webkit-scrollbar-button:horizontal:increment 
::-webkit-scrollbar-button:horizontal:decrement 
</style>



<%@ include file="../part/foot.jspf"%>