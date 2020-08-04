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

if string.find(data.Content, "PM2.5") then 
	keyWord = data.Content:gsub("PM2.5", "")
	if keyWord=="" then keyWord="上海" end --默认上海
	querystr="app=weather.pm25&weaid="..keyWord.."&appkey=你的apikey" --到https://www.nowapi.com/?app=account.login申请
   -- log.notice("querystr=\n%s", querystr)--	
        response, error_message =
            http.request(
            "POST",
            "http://api.k780.com" ,--从nowapi接口获取--https://www.nowapi.com/?app=account.login
		{query=""..querystr}
        )
        local html = response.body

	resultstr = json.decode(html) --反序列化json
  --log.notice("html=\n%s", html)
  --log.notice("resultstr=\n%s", resultstr)
		ApiRet =				
            Api.Api_SendMsg( 
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "TextMsg",
                content = keyWord.."aqi:".. resultstr.result.aqi.."\n空气质量:" .. resultstr.result.aqi_levnm, --获取最后发布时间 ,
		groupid = 0,

                atUser = 0,

            }
        )
	html = nil

    end	

    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

function cutstring(str)
po1="<div class=\"writing\"><p>"
po2="</p><p></p><p><div style"
_,i=string.find(str, po1)
j,_=string.find(str, po2)

result=string.sub(str,i+1,j-1) --去除头尾
return result
end
