local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
function ReceiveFriendMsg(CurrentQQ, data)
	if data.FromUin ==2986807981 then--防止自我复读
		  return 1 end
	img_url  = " "
	keyWord  = " "
	content = ""
	if string.find(data.Content, "上证指数") == 1 then	
		keyWord  ="sh000001"
		end
	if string.find(data.Content, "创业板指数") == 1 then
		keyWord  ="sz399006"
		end
	if 	keyWord ~=" " then
		img_url = "http://image.sinajs.cn/newchart/min/n/"..keyWord ..".gif"
		sendfriendstockpic(CurrentQQ,data,img_url,content)
		return 1
	end

		  
	if string.find(data.Content, "股票代码") == 1 then
	
	keyWord = data.Content:gsub("股票代码", "")
	
	if keyWord =="" then return 1 end --关键字为空则退出
	img_url = "http://image.sinajs.cn/newchart/min/n/"..keyWord ..".gif"
	content = "股票代码以新浪财经为准http://biz.finance.sina.com.cn/suggest/lookup_n.php"
	sendfriendstockpic(CurrentQQ,data,img_url,content)
	
	img_url  = nil
	keyWord  = nil
	content = nil
			return 1
	end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end
		  
	img_url  = " "
	keyWord  = " "
	content  = ""
	if string.find(data.Content, "上证指数") == 1 then	
		keyWord  ="sh000001"
		end
	if string.find(data.Content, "创业板指数") == 1 then
		keyWord  ="sz399006"
		end
	if 	keyWord ~=" " then
		img_url = "http://image.sinajs.cn/newchart/min/n/"..keyWord ..".gif"
		sendgroupstockpic(CurrentQQ,data,img_url,content)
		return 1
	end
	
			
if string.find(data.Content, "股票代码") == 1 then
	keyWord = data.Content:gsub("股票代码", "")
	if keyWord =="" then return 1 end --关键字为空则退出
	img_url = "http://image.sinajs.cn/newchart/min/n/"..keyWord ..".gif"
	
		ApiRet =				
            Api.Api_SendMsg( 
            CurrentQQ,
            {
                
					toUser = data.FromGroupId, --回复当前消息的来源群ID
					sendToType = 2, --2发送给群1发送给好友3私聊
					groupid = 0, --不是私聊自然就为0咯
					atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
					sendMsgType = "PicMsg",
					content = "股票代码以新浪财经为准http://biz.finance.sina.com.cn/suggest/lookup_n.php",
					picUrl = img_url,
					picBase64Buf = "",
					fileMd5 = ""
            }
        )
	img_url  = nil
	return 1
    end	

    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

function sendgroupstockpic(CurrentQQ,data,img_url,content)
if img_url == "" then return 1 end --空则退出
ApiRet =				
            Api.Api_SendMsg( 
            CurrentQQ,
            {
                
					toUser = data.FromGroupId, --回复当前消息的来源群ID
					sendToType = 2, --2发送给群1发送给好友3私聊
					groupid = 0, --不是私聊自然就为0咯
					atUser = 0, --是否 填上data.FromUserId就可以复读给他并@了
					sendMsgType = "PicMsg",
					content = content,
					picUrl = img_url,
					picBase64Buf = "",
					fileMd5 = ""
            }
        )
		
return 1
end
function sendfriendstockpic(CurrentQQ,data,img_url,content)
if img_url =="" then return 1 end --空则退出
ApiRet =				
            Api.Api_SendMsg( 
            CurrentQQ,
			{
			
			
								toUser = data.FromUin, --回复当前消息的来源群ID
								sendToType = 1, --2发送给群1发送给好友3私聊
								sendMsgType = "PicMsg",
								content = content,
								picUrl = img_url,
								picBase64Buf = "",
								fileMd5 = ""
			
			
			}
		)

return 1
end