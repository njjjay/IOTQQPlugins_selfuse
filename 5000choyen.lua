local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end

if string.find(data.Content, "#") and string.find(data.Content, ".jpg")  then 
		toptext = ""
		bottomtext = ""
		toptext = string.sub(data.Content, 1, string.find(data.Content, "#")-1)
		bottomtext = string.sub(data.Content,string.find(data.Content, "#")+1, -5)
		--print(toptext.."  ")
		--print(bottomtext)
		toptext = urlEncode(toptext)
		bottomtext = urlEncode(bottomtext)
		if toptext == ""  then
			toptext =" "
		end
		if bottomtext == ""  then
			bottomtext =" "
		end
		ApiRet =
            Api.Api_SendMsg( 
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "PicMsg",
                content = "本群已内置傻屌图生成器:http://yurafuca.com/5000choyen/index_cn.html", 
                atUser = 0,
                voiceUrl = "",
                voiceBase64Buf = "",
                picUrl = "http://5000choyen.app.cyberrex.ml/image?top="..toptext.."&bottom="..bottomtext, --感谢dalao的API   https://github.com/CyberRex0/5000choyen-api
                picBase64Buf = "",
				fileMd5 = ""
            }
        )

    end	
		toptext=nil
		bottomtext=nil
 
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
function urlEncode(s)  --url编码解码
  s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
  return string.gsub(s, " ", "+")
end
function urlDecode(s)
  s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
  return s
end