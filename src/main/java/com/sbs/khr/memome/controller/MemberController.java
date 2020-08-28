package com.sbs.khr.memome.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.khr.memome.dto.Member;
import com.sbs.khr.memome.dto.ResultData;
import com.sbs.khr.memome.service.MemberService;
import com.sbs.khr.memome.util.Util;

@Controller
public class MemberController {

	@Autowired
	private MemberService memberService;

	@RequestMapping("/usr/member/join")
	public String showMain() {
		return "member/join";
	}

	@RequestMapping("/usr/member/doJoin")
	public String doJoin(@RequestParam Map<String, Object> param, Model model) {

		Util.changeMapKey(param, "loginPwReal", "loginPw");

		// 로그인 아이디 중복 체크
		ResultData checkLoginIdJoinableResultData = memberService
				.checkLoginIdJoinable(Util.getAsStr(param.get("loginId")));

		if (checkLoginIdJoinableResultData.isFail()) {
			model.addAttribute("historyBack", true);
			model.addAttribute("alertMsg", checkLoginIdJoinableResultData.getMsg());
			return "common/redirect";
		}
		// 닉네임 중복 체크
		ResultData checkNicknameJoinableResultData = memberService
				.checkNicknameJoinable(Util.getAsStr(param.get("nickname")));

		if (checkNicknameJoinableResultData.isFail()) {
			model.addAttribute("historyBack", true);
			model.addAttribute("alertMsg", checkNicknameJoinableResultData.getMsg());
			return "common/redirect";
		}

		// 이메일 중복 체크
		ResultData checkEmailJoinableResultData = memberService.checkEmailJoinable(Util.getAsStr(param.get("email")));

		if (checkEmailJoinableResultData.isFail()) {
			model.addAttribute("historyBack", true);
			model.addAttribute("alertMsg", checkEmailJoinableResultData.getMsg());
			return "common/redirect";
		}

		// param에 id가 들어있다?????????? 샘한테 질문하기.
		int newMemberId = memberService.join(param);

		String nickname = Util.getAsStr(param.get("nickname"));
		model.addAttribute("alertMsg", nickname + " 님, 회원가입을 감사드립니다.");

		String redirectUri = (String) param.get("redirectUri");
		model.addAttribute("redirectUri", redirectUri);

		return "common/redirect";
	}

	@RequestMapping("/usr/member/login")
	public String showLogin() {
		return "member/login";
	}

	@RequestMapping("/usr/member/doLogin")
	public String doLogin(@RequestParam Map<String, Object> param, Model model, HttpSession session) {

		Util.changeMapKey(param, "loginPwReal", "loginPw");

		Member member = memberService.getMemberByLoginId(Util.getAsStr(param.get("loginId")));

		if (member == null || member.isDelStatus() == true) {
			model.addAttribute("historyBack", true);
			model.addAttribute("alertMsg", "존재하지 않는 회원입니다.");
			return "common/redirect";
		}

		String loginPw = Util.getAsStr(param.get("loginPw"));

		if (member.getLoginPw().equals(loginPw) == false) {
			model.addAttribute("historyBack", true);
			model.addAttribute("alertMsg", "비밀번호가 일치하지 않습니다.");
			return "common/redirect";
		}

		session.setAttribute("loginedMemberId", member.getId());

		String redirectUri = Util.getAsStr(param.get("redirectUri"));

		if (redirectUri == null || redirectUri.length() == 0) {
			redirectUri = "/usr/home/main";
		}

		model.addAttribute("redirectUri", redirectUri);
		model.addAttribute("alertMsg", String.format("%s님 반갑습니다.", member.getNickname()));

		boolean isNeedToChangePasswordForTemp = memberService.isNeedToChangePasswordForTemp(member.getId());

		if (isNeedToChangePasswordForTemp) {

			model.addAttribute("alertMsg", String.format("%s 님. 현재 임시 패스워드를 사용중입니다.", member.getNickname()));

		}

		boolean getDateForpasswordModify = Util.getDateForpasswordModify("2020-05-28");
		
		
		// alert을 줄바꿈하고 싶어서 \n을 사용했는데 적용되지 않았음.
		// \n을 사용하기 위해 혹시 \앞에 \을 1개 더 입력했더니 원하는대로 작동하였음.
		if (getDateForpasswordModify) {
			System.out.println("이게 실행이 안되나????????");
			model.addAttribute("alertMsg2", "비밀번호를 변경하지 않은지 3개월이 경과하였습니다.\\n개인정보 보호를 위하여 비밀번호를 변경해주세요.");
		}

		return "common/redirect";
	}

	@RequestMapping("/usr/member/logout")
	public String doLogout(HttpSession session, Model model) {

		session.removeAttribute("loginedMemberId");

		String redirectUri = "/usr/home/main";
		model.addAttribute("redirectUri", redirectUri);

		return "common/redirect";
	}

	@RequestMapping("/usr/member/myPage")
	public String showMyPage(HttpSession session, Model model, HttpServletRequest request) {

		Member member = memberService.getMemberById(Util.getAsInt(request.getAttribute("loginedMemberId")));

		model.addAttribute("member", member);

		return "member/myPage";
	}

	@RequestMapping("/usr/member/memberDataPrivate")
	public String showMemberDataPrivate(HttpSession session, Model model, HttpServletRequest request) {

		Member member = memberService.getMemberById(Util.getAsInt(request.getAttribute("loginedMemberId")));

		model.addAttribute("member", member);

		return "member/memberDataPrivate";
	}

	@RequestMapping("/usr/member/passwordPrivate")
	public String showPasswordPrivate(HttpSession session, Model model, HttpServletRequest request) {

		Member member = memberService.getMemberById(Util.getAsInt(request.getAttribute("loginedMemberId")));

		model.addAttribute("member", member);

		return "member/passwordPrivate";
	}

	@RequestMapping("/usr/member/modify")
	public String showModify(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

		Util.changeMapKey(param, "loginPwReal", "loginPw");

		Member member = memberService.getMemberById(Util.getAsInt(request.getAttribute("loginedMemberId")));

		if (member.getLoginPw().equals(Util.getAsStr(param.get("loginPw"))) == false) {
			model.addAttribute("historyBack", true);
			model.addAttribute("alertMsg", "비밀번호가 일치하지 않습니다.");
			return "common/redirect";
		}

		model.addAttribute("member", member);

		return "member/modify";
	}

	@RequestMapping("/usr/member/passwordModify")
	public String showPasswordModify(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

		Util.changeMapKey(param, "loginPwReal", "loginPw");

		Member member = memberService.getMemberById(Util.getAsInt(request.getAttribute("loginedMemberId")));

		if (member.getLoginPw().equals(Util.getAsStr(param.get("loginPw"))) == false) {
			model.addAttribute("historyBack", true);
			model.addAttribute("alertMsg", "비밀번호가 일치하지 않습니다.");
			return "common/redirect";
		}

		model.addAttribute("member", member);

		return "member/passwordModify";
	}

	@RequestMapping("/usr/member/doModify")
	public String doModify(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {


		memberService.memberDataUpdate(param);

		String redirectUri = "/usr/member/myPage";

		model.addAttribute("redirectUri", redirectUri);

		return "common/redirect";
	}

	@RequestMapping("/usr/member/doPasswordModify")
	public String doPasswordModify(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

		Util.changeMapKey(param, "loginPwReal", "loginPw");
		memberService.passwordUpdate(param);

		String redirectUri = "/usr/member/myPage";

		model.addAttribute("redirectUri", redirectUri);

		return "common/redirect";
	}

	@RequestMapping("/usr/member/findAccount")
	public String showFindAccount(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {
		return "member/findAccount";
	}

	@RequestMapping("/usr/member/doFindLoginId")
	public String doFindLoginId(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

		Member member = memberService.getMemberByNameAndEmail(param);

		if (member != null) {
			model.addAttribute("redirectUri", "/usr/member/login");
			model.addAttribute("alertMsg", "찾으시는 아이디는 " + member.getLoginId() + " 입니다.");
		}

		return "common/redirect";
	}

	@RequestMapping("/usr/member/doFindLoginPw")
	public String doFindLoginPw(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request) {

		Member member = memberService.getMemberByLoginIdAndEmail(param);

		if (member != null) {
			model.addAttribute("redirectUri", "/usr/member/login");
			model.addAttribute("alertMsg", "임시 비밀번호를 가입하신 이메일로 발송드렸습니다.");
		} else {
			model.addAttribute("redirectUri", "/usr/member/findAccount");
			model.addAttribute("alertMsg", "일치하는 회원정보가 존재하지 않습니다.");
		}

		return "common/redirect";
	}

	@RequestMapping("/usr/member/getLoginIdDup")
	@ResponseBody
	public ResultData getLoginIdDup(HttpServletRequest request) {

		String loginId = request.getParameter("loginId");

		return memberService.checkLoginIdJoinable(loginId);

	}
	
	
	// 아무 기능도 하지 않는 메서드 
	// -----  /usr/member/getLoginIdDup 를 원래 아래 코드들로 구현했었으나 
	// 사용 가능, 중복 확인 문구가 memberService에서 처리하는 코드와 중복으로 작성되어 
	// 코드를 개선하기 위해 연구한 결과 위의 코드로 짧게 처리했는데 
	// 동일한 결과값을 보였음..... 대박
	// loginId와 동일하게 nickname과 email도 코드를 수정하였음!! 
	@RequestMapping("/usr/member/getLoginIdDup2")
	@ResponseBody
	public String getLoginIdDup2(HttpServletRequest request) {

		String loginId = request.getParameter("loginId");

		ResultData checkLoginIdJoinableResultData = memberService.checkLoginIdJoinable(loginId);

		boolean valid = checkLoginIdJoinableResultData.isFail();

		// 필히 \을 붙여주어야 한다.
		// 기존 blog에서 구현한 것과는 다르게 return "json:" 을 빼주었더니 되었음.
		// @ResponseBody 어노테이션도 입력해주었음.
		if (valid) {
			return "{\"msg\":\"이미 사용중인 아이디 입니다.\", \"resultCode\": \"F-1\", \"loginId\":\"" + loginId + "\"}";
		} else {
			return "{\"msg\":\"사용할 수 있는 아이디 입니다.\", \"resultCode\": \"S-1\", \"loginId\":\"" + loginId + "\"}";
		}

	}
	// 사용중인 닉네임 입니다 등 중복으로 고쳤으면 좋겠음..ㅠㅠ
	@RequestMapping("/usr/member/getNicknameDup")
	@ResponseBody
	public ResultData getNicknameDup(HttpServletRequest request) {

		String nickname = request.getParameter("nickname");

		return memberService.checkNicknameJoinable(nickname);

	}

	@RequestMapping("/usr/member/getEmailDup")
	@ResponseBody
	public ResultData getEmailDup(HttpServletRequest request) {

		String email = request.getParameter("email");

		return memberService.checkEmailJoinable(email);

	}

	@RequestMapping("/usr/member/passwordAccountDelete")
	public String passwordAccountDelete() {
		return "member/passwordAccountDelete";
	}

	@RequestMapping("/usr/member/accountDelete")
	public String doAccountDelete(Model model, HttpSession session, @RequestParam Map<String, Object> param) {

		memberService.accountDelete(param);

		session.removeAttribute("loginedMemberId");

		String redirectUri = "/usr/home/main";

		model.addAttribute("redirectUri", redirectUri);

		return "common/redirect";
	}

}
