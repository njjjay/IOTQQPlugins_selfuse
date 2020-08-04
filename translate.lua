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
	if string.find(data.Content, "翻译成") == 1 then	 
	
		local keyWord ="" --涙じゃない。目から尿が出ているだけなんだ
		local sl = "auto" --默认自动匹配原语言'
		local tl = "en" --默认翻译英语
		
		if string.find(data.Content, "翻译成中文:") == 1 then
		
			keyWord  =  data.Content:gsub("翻译成中文:", "")
			tl="zh-CN"
		end
		if string.find(data.Content, "翻译成英语:") == 1 then
		
			keyWord  =  data.Content:gsub("翻译成英语:", "")
			tl="en"
		end
		if string.find(data.Content, "翻译成日语:") == 1 then
		
			keyWord  =  data.Content:gsub("翻译成日语:", "")
			tl="ja-JP"
		end
		
		
		if 	keyWord ~="" then
					keyWord = url_encode(keyWord)
					log.notice("keyWord-->%s",keyWord)
			response, error_message =
                 http.request(
                 "GET",
          				"http://translate.google.cn/translate_a/single?",
                 {
                     query = "client=gtx&sl="..sl.."&tl="..tl.."&dt=t&q="..keyWord ,
					 
                     headers = {
										
          								--["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
					}
                 }
             )
			local html = response.body
  			log.notice("html-->%s",html)
  			local re = json.decode(html)
			local resultstr = re[1][1][1]
			--log.notice("resultstr   =%s",resultstr)
				sendgroupresult(CurrentQQ,data,resultstr)
		end
	end
	
	
			
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

function sendgroupresult(CurrentQQ,data,resultstr)
if resultstr == "" then return 1 end --空则退出
ApiRet =				
            Api.Api_SendMsg( 
            CurrentQQ,
            {
                
					toUser = data.FromGroupId, --回复当前消息的来源群ID
					sendToType = 2, --2发送给群1发送给好友3私聊
					sendMsgType = "TextMsg",
					groupid = 0, --不是私聊自然就为0咯	
					content = "频率有限制请勿滥用, 翻译结果:"..resultstr,
					atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了

            }
        )
		
return 1
end
function sendfriendresult(CurrentQQ,data,resultstr)
if resultstr =="" then return 1 end --空则退出
ApiRet =				
            Api.Api_SendMsg( 
            CurrentQQ,
			{
			
			
						toUser = data.FromUin, --回复当前消息的来源群ID
					    sendToType = 1, --2发送给群1发送给好友3私聊
					    sendMsgType = "TextMsg", --进行文本复读回复
					    groupid = 0, --不是私聊自然就为0咯
					    content = "频率有限制请勿滥用, 翻译结果:"..resultstr, --回复内容
					    atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
			
			
			}
		)

return 1
end



function url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str	
end

function url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end
