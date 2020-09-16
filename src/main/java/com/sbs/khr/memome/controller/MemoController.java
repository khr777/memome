package com.sbs.khr.memome.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.khr.memome.dto.Article;
import com.sbs.khr.memome.dto.Board;
import com.sbs.khr.memome.dto.File;
import com.sbs.khr.memome.dto.Hashtag;
import com.sbs.khr.memome.dto.Member;
import com.sbs.khr.memome.dto.ResultData;
import com.sbs.khr.memome.service.ArticleService;
import com.sbs.khr.memome.service.FileService;
import com.sbs.khr.memome.service.HashtagService;
import com.sbs.khr.memome.service.MemberService;
import com.sbs.khr.memome.service.MemoService;
import com.sbs.khr.memome.util.Util;

@Controller
public class MemoController {

	@Autowired
	private MemoService memoService;

	@Autowired
	private ArticleService articleService;

	@Autowired
	private HashtagService hashtagService;

	@Autowired
	private MemberService memberService;

	@Autowired
	private FileService fileService;

	@RequestMapping("/usr/memo/{boardCode}-tagSearchResult")
	public String showMemoSearchResult(@PathVariable("boardCode") String boardCode, Model model,
			HttpServletRequest request, String searchKeywordType, String searchKeyword, Integer id) {

		Board board = articleService.getBoardByCode(boardCode);
		model.addAttribute("board", board);

		int loginedMemberId = (int) request.getAttribute("loginedMemberId");

		Member member = null;

		List<Article> articles = null;

		if (boardCode.equals("memoME") && id == null) {
			if (searchKeyword != null && searchKeywordType != null) {
				articles = articleService.getArticlesContainsTagSearchResultByMemberId( loginedMemberId,
						searchKeyword);
				member = memberService.getMemberById(loginedMemberId);
			}
		}

		if (boardCode.equals("memoYOU") && id == null) {
			if (searchKeyword != null && searchKeywordType != null) {
				articles = articleService.getArticlesContainsTagSearchResultByMemberIdForMemoYou(loginedMemberId,
						searchKeyword);
				member = memberService.getMemberById(loginedMemberId);
			}
		}
		
		if (boardCode.equals("memberPage") && id != null) {
			if (searchKeyword != null && searchKeywordType != null) {
				articles = articleService.getArticlesContainsTagSearchResultByMemberId(id, searchKeyword);
				member = memberService.getMemberById(id);
			}
		}
		
		

		List<Hashtag> hashtags = hashtagService.getForPrintAllHashtags();

		model.addAttribute("member", member);
		model.addAttribute("hashtags", hashtags);
		model.addAttribute("articles", articles);

		return "memo/tagSearchResult";
	}

	@RequestMapping("/usr/memo/{boardCode}-memoModify")
	public String showMemoModify(@PathVariable("boardCode") String boardCode, Model model, HttpServletRequest request,
			int id) {

		Article article = articleService.getForPrintArticleById(id);
		model.addAttribute("article", article);

		int loginedMemberId = (int) request.getAttribute("loginedMemberId");
		Member member = memberService.getMemberById(loginedMemberId);
		model.addAttribute("member", member);

		String tagBits = hashtagService.getForPrintHashtagsByRelId(id);
		tagBits.toString();
		model.addAttribute("tagBits", tagBits);
		System.out.println("tagBits : " + tagBits);

		return "memo/memoModify";
	}

	@RequestMapping("/usr/memo/{boardCode}-doMemoModify")
	public String doMemoModify(@RequestParam Map<String, Object> param, @PathVariable("boardCode") String boardCode,
			Model model, HttpServletRequest request) {

		ResultData resultData = hashtagService.getChechTagDup(Util.getAsStr(param.get("tag")));

		if (resultData.isFail()) {
			model.addAttribute("alertMsg", resultData.getMsg());
			model.addAttribute("historyBack", true);
			return "common/redirect";
		}

		int loginedMemberId = (int) request.getAttribute("loginedMemberId");
		Map<String, Object> newParam = Util.getNewMapOf(param, "relTypeCode", "fileIdsStr", "id", "title", "body",
				"tag");
		System.out.println("param file수정 시작 : " + param);
		System.out.println("newParam file수정 시작 : " + newParam);
		articleService.memoModify(newParam, loginedMemberId);

		String redirectUri = "/usr/memo/" + boardCode + "-memoList";
		model.addAttribute("redirectUri", redirectUri);

		return "common/redirect";
	}

	@RequestMapping("/usr/memo/{boardCode}-doDelete")
	public String doDelete(@RequestParam Map<String, Object> param, @PathVariable("boardCode") String boardCode,
			Model model, HttpServletRequest request) {

		int memberId = (int) request.getAttribute("loginedMemberId");
		Map<String, Object> newParam = Util.getNewMapOf(param, "id");
		newParam.put("memberId", memberId);
		hashtagService.hashtagDelete(newParam); // hashtag를 먼저 지우니까 삭제가 되네.... 흠...
		articleService.memoDelete(newParam);

		fileService.deleteFiles("article", Util.getAsInt(newParam.get("id")));

		// 게시물 삭제
		// 태그 삭제
		// 파일 삭제

		System.out.println("newParam 테스트 고고 : " + newParam);

		return "home/main";
	}

	// id = articleId
	@RequestMapping("/usr/memo/{boardCode}-fork")
	public String showFork(@RequestParam Map<String, Object> param, Model model,
			@PathVariable("boardCode") String boardCode, int id, HttpServletRequest request) {

		Board board = articleService.getBoardByCode(boardCode);

		Article article = articleService.getForPrintArticleById(id);
		String hashtags = hashtagService.getForPrintHashtagsByRelId(id);

		String title = article.getTitle();
		String body = article.getBody();
		int memberId = (int) request.getAttribute("loginedMemberId");
		
		int boardId = board.getId();
		if ( boardId == 5 ) {
			boardId = 3;
		}

		param.put("title", title);
		param.put("body", body);
		param.put("memberId", memberId);
		param.put("boardId", boardId);

		int newArticleId = articleService.write(param);
		hashtagService.tagWrite(newArticleId, hashtags, memberId, "article");

		List<File> files = fileService.getFiles("article", id, "common", "attachment");
		for (File file : files) {
			int newFileId = fileService.saveFile(file.getRelTypeCode(), newArticleId, file.getTypeCode(),
					file.getType2Code(), file.getFileNo(), file.getOriginFileName(), file.getFileExtTypeCode(),
					file.getFileExtType2Code(), file.getFileExt(), file.getBody(), file.getFileSize());

			fileService.updateFork(newFileId, file.getId());
		}

		if (newArticleId != -1) {
			model.addAttribute("redirectUri", "/usr/memo/memoME-memoModify?id=" + newArticleId);
			model.addAttribute("alertMsg", newArticleId + "번 게시물이 생성되었습니다.");
			return "common/redirect";
		}

		return "home/main";
	}

	
	// id = 작성자 id
	@RequestMapping("/usr/memo/{boardCode}-memoList")
	public String showMemoList(@PathVariable("boardCode") String boardCode, Model model, HttpServletRequest request, Integer id) {
		Board board = memoService.getBoardByCode(boardCode);
		model.addAttribute("board", board);

		int loginedMemberId = (int) request.getAttribute("loginedMemberId");
		

		List<Article> articles = null;
		
		if ( id == null ) {
			if (boardCode.equals("memoME")) {
				articles = articleService.getForPrintArticlesByMemberId(loginedMemberId, board.getId());
			}
			if (boardCode.equals("memoYOU")) {
				articles = articleService.getForPrintAllArticles(board.getId(), loginedMemberId);
			}
			Member member = memberService.getMemberById(loginedMemberId);
			model.addAttribute("member", member);
		}
		if ( boardCode.equals("memberPage")) {
			articles = articleService.getForPrintArticlesByMemberId(id, board.getId());
			Member member = memberService.getMemberById(id);
			model.addAttribute("member", member);
		}

		// memo를 관리할 폴더 관련 코드를 없애서 관련 코드는 사용하지 않음. 검토해서 관련 코드 다 삭제하기.
		// List<Article> articles = articleService.getForPrintArticlesByMemo();
		List<Hashtag> hashtags = hashtagService.getForPrintAllHashtags();

		model.addAttribute("articles", articles);
		

		model.addAttribute("hashtags", hashtags);

		return "memo/memoList";
	}



	@RequestMapping("/usr/memo/{boardCode}-memoWrite")
	public String showMemoWrite(@PathVariable("boardCode") String boardCode, Model model) {
		model.addAttribute("boardCode", boardCode);
		return "article/write";
	}

	@RequestMapping("/usr/memo/{boardCode}-makeMemoCate")
	public String showMakeMemoCate(@PathVariable("boardCode") String boardCode, Model model) {
		Board board = memoService.getBoardByCode(boardCode);
		model.addAttribute("board", board);

		return "memo/makeCate";
	}

	@RequestMapping("/usr/memo/{boardCode}-doMakeMemoCate")
	public String doMakeMemoCate(@RequestParam Map<String, Object> param, @PathVariable("boardCode") String boardCode,
			Model model) {
		Board board = memoService.getBoardByCode(boardCode);

		Map<String, Object> newParam = Util.getNewMapOf(param, "id", "name");
		newParam.put("boardId", board.getId());

		int newMemoFolderId = memoService.makeMemoCate(newParam);
		String redirectUri = Util.getAsStr(param.get("redirectUri"));
		model.addAttribute("redirectUri", redirectUri);

		return "common/redirect";
	}

}
