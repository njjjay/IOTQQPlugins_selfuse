local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
function ReceiveFriendMsg(CurrentQQ, data)
if data.FromUin ==2986807981 then--防止自我复读
		  return 1 end" )== 1 then --机器人退出当前qq


		luaMsg =
					    Api.Api_SendMsg(--调用发消息的接口
					    CurrentQQ,
					    {
					       toUser = data.FromUin, --回复当前消息的来源群ID
					       sendToType = 1, --2发送给群1发送给好友3私聊
					       sendMsgType = "TextMsg", --进行文本复读回复
					       groupid = 0, --不是私聊自然就为0咯
					       content = "正在退出...请联系管理员重登", --回复内容
					       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
					    }
					)
		
					Api.Api_LogOut(CurrentQQ, false)


end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end


    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
