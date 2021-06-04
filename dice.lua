local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
--local http = require "resty.http"
function ReceiveFriendMsg(CurrentQQ, data)
	if data.FromUin ==2986807981 then--防止自我复读
		  return 1 end
	if string.find(data.Content, ".roll") == 1 then
		math.randomseed(os.time()+assert(tonumber(tostring({}):sub(7))))
		m = 1
		n =data.Content:gsub(".roll", "")
		if n =="" or n == nil then n = 6 end --默认为6面骰		
		n = tonumber(n)--不可以直接tonumber 不知道为什么会变nil	
		if n == nil then n=0 end
		
		temp= math.floor(n)
		
		if type(n) == "number" and  n > 0	and ( temp == n )then 
		
			--result=math.random(m , n)
			resultstr="你掷出了一个"..tostring(n).."面骰".."结果为" ..tostring(getrandomint(n)) 
			
		else 
		
			resultstr = "数字错误 请输入阿拉伯数字正整数" --空消息返回报错		
			
		end
					luaMsg =
					    Api.Api_SendMsg(--调用发消息的接口
					    CurrentQQ,
					    {
					       toUser = data.FromUin, --回复当前消息的来源群ID
					       sendToType = 1, --2发送给群1发送给好友3私聊
					       sendMsgType = "TextMsg", --进行文本复读回复
					       groupid = 0, --不是私聊自然就为0咯
					       content = resultstr, --回复内容
					       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
					    }
 
					)
	resultstr = nil
	end
	return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end
	
	
	if string.find(data.Content, ".roll") == 1 then
		math.randomseed(os.time()+assert(tonumber(tostring({}):sub(7))))
		m = 1
		n =data.Content:gsub(".roll", "")
		if n =="" or n == nil then n = 6 end --默认为6面骰		
		result = ""	

		n = tonumber(n)--不可以直接tonumber 不知道为什么会变nil	
		if n == nil then n=0 end
		temp= math.floor(n)
		
		if type(n) == "number" and  n > 0	and ( temp == n )then 
		

			--print(res.result.random.data[1])
			--result=math.random(m , n)
			resultstr="你掷出了一个"..tostring(n).."面骰".."结果为" ..tostring(getrandomint(n)) 
			
		else 
		
			resultstr = "数字错误 请输入阿拉伯数字正整数" --空消息返回报错		
			
		end
		

					luaMsg =
				    Api.Api_SendMsg(--调用发消息的接口
				    CurrentQQ,
				    {
				       toUser = data.FromGroupId, --回复当前消息的来源群ID
				       sendToType = 2, --2发送给群1发送给好友3私聊
				       sendMsgType = "TextMsg", --进行文本复读回复
				       groupid = 0, --不是私聊自然就为0咯
				       content = resultstr, --回复内容
				       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
				    }
				)
		resultstr = nil

	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
function getrandomint(n)
			local bodytable = {
  				jsonrpc= "2.0",
  				method= "generateIntegers",
  				params= {
    					apiKey= "aaabbbcccddd",--此处填写apikey  需要到random.org申请
						n= 1,
    					min= 1,
     					max= n,
						replacement= true,
						base= 10
						},
				id=math.random(1 , n)
				}	
         response, error_message = http.request
			(
			"POST", 
			"https://api.random.org/json-rpc/2/invoke",
				{
				query = "",
				headers = {["Content-Type"] = "application/json"},
				body = json.encode( bodytable)
				}
  			)
			local html = response.body
				local res=json.decode(html)
	return res.result.random.data[1]
end