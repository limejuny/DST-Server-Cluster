author = "abcdef"
name = "한글 입력기"
version = "2.0.01"
description = [[
## 2.0.0 업데이트 내역 ##

1. 이제 글 삭제시 음절 단위로 지워집니다.
2. 한영 전환 키에 Ctrl과 Shift 조합 키가 추가되었습니다.
   Ctrl or Shift + Space 조합으로 한영 전환이 가능합니다.
   (OS설정에 따라 동작이 다르게 될 수 있음.)
3. Mac(매킨토시) 에서도 정상 동작 확인.

피드백은 창작마당 댓글에 달아주세요.
]]
forumthread = ""
api_version = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true
client_only_mod = true
all_clients_require_mod = false

configuration_options =
{
	{
		name = "han_yeong_key",
		label = "한영 전환 키",
		options = {
			{description = "PageUp"		, data = "pageup"},
			{description = "PageDown"	, data = "pagedown"},
			{description = "Command R"	, data = "commandR"},
			{description = "F10"		, data = "f10"},
			{description = "F11"		, data = "f11"},
			{description = "Ctrl + Space", data = "__ctrlspace"},
			{description = "Shift + Space", data = "__shiftspace"},
		},
		default = "pagedown"
	},
	{
		name = "default_han_yeong",
		label = "기본 입력 언어",
		options = {
			{description = "한글"	, data = true},
			{description = "영어"	, data = false},
		},
		default = true
	}
}