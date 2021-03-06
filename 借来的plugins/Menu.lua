local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
	if data.FromUin ==2986807981 then--防止自我复读
		  return 1 end
if string.find(data.Content, "机器人菜单") == 1 then
		menu =  		"1.se图命令(不保证可用)有：\n来点/张/份/XX(可选)/(的)色/涩/瑟/黄/图、漫画、插画、随机、首页、周排行、cos、私服、cos周排行、cos月排行、私服排行、炼点铜。(不可私聊)\n"..
					"2.天气查询：天气+城市(可以私聊)\n"..
					"3.机器人不会复读自己刷屏,如果无限复读请通知我关掉\n"..
					"4.QQ音乐：点歌+歌名(可以私聊)\n"..
					"5.搜图+图片 不保证准确(可以私聊搜图)\n"	..
					"6.语音+文字(文字转语音)(可以私聊)\n"..
					"7.搜番+图片 不保证准确(不可私聊)\n"..
					"8.气象功能:真彩色/华东雷达图/降水量/机动观测(可选加BD)/看看副高/台风预警/海面温度/PM2.5+城市(不可私聊)"
					luaMsg =
					    Api.Api_SendMsg(--调用发消息的接口
					    CurrentQQ,
					    {
					       toUser = data.FromUin, --回复当前消息的来源群ID
					       sendToType = 1, --2发送给群1发送给好友3私聊
					       sendMsgType = "TextMsg", --进行文本复读回复
					       groupid = 0, --不是私聊自然就为0咯
					       content = menu, --回复内容
					       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
					    }
					)
		end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end
if string.find(data.Content, "机器人菜单") == 1 then
	menu =  "避免刷屏 请私聊我'机器人菜单'获取"
					luaMsg =
				    Api.Api_SendMsg(--调用发消息的接口
				    CurrentQQ,
				    {
				       toUser = data.FromGroupId, --回复当前消息的来源群ID
				       sendToType = 2, --2发送给群1发送给好友3私聊
				       sendMsgType = "TextMsg", --进行文本复读回复
				       groupid = 0, --不是私聊自然就为0咯
				       content = menu, --回复内容
				       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
				    }
				)
		end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
	
