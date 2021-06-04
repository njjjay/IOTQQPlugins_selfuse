local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
--########菜单路径#########
local menupath = "/root/opqbot/Plugins/whattoeat.json"

function ReceiveFriendMsg(CurrentQQ, data)
	if data.FromUin ==2986807981 then--防止自我复读
		  return 1 end
	if string.find(data.Content, ".今天吃啥菜单") then
	menu = ""
	
	foodarray = readfile()
	for i=1,#foodarray.arry,1 do
	menu = menu.."No"..i..foodarray.arry[i].."\n"
	
	end
	
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
	menu = nil
	
	end
	if string.find(data.Content, ".添加菜单") then
		if data.FromUin ==779091224 then --屏蔽某些捣乱的
			result = "你说你🐎呢"
		else	
	
		local newrecipe = data.Content:gsub(".添加菜单", "")		
		result = addrecipe(newrecipe)
		end
		luaMsg =
		    Api.Api_SendMsg(--调用发消息的接口
			CurrentQQ,
			{
		    toUser = data.FromUin, --回复当前消息的来源群ID
			sendToType = 1, --2发送给群1发送给好友3私聊
			sendMsgType = "TextMsg", --进行文本复读回复
			groupid = 0, --不是私聊自然就为0咯
			content = result, --回复内容
			atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
			}
 
		)
		
		end
		
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end


	if string.find(data.Content, ".今天吃啥") and data.Content:gsub(".今天吃啥", "")=="" or (string.find(data.Content, ".今天吃什么") and data.Content:gsub(".今天吃什么", "")=="") or string.find(data.Content, ".今晚吃啥") or string.find(data.Content, ".今晚吃什么") then 
		--foodarray = {"汉堡","螺蛳粉","凉皮","火锅","过桥米线","饺子","铁锅饭","卤肉饭","炸酱面","麻辣烫","炒粉","云吞","炸鸡","手抓饼","拉面","泡面","牛排","寿司","木桶饭","冒菜","羊肉粉","馒头","皮蛋瘦肉粥","奶茶","黄焖鸡米饭","海鲜"}
		foodarray = readfile()
		--print(#foodarray.arry)
		
		--math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 7)))  --https://blog.csdn.net/goodai007/article/details/59579515
		math.randomseed(os.time()+assert(tonumber(tostring({}):sub(7))))  --试试这个?匿名空表取地址

		--result = math.random(1 , #foodarray.arry)
		result = getrandomint(#foodarray.arry)
		menu = foodarray.arry[result]
		luaMsg =
				    Api.Api_SendMsg(--调用发消息的接口
				    CurrentQQ,
				    {
				       toUser = data.FromGroupId, --回复当前消息的来源群ID
				       sendToType = 2, --2发送给群1发送给好友3私聊
				       sendMsgType = "TextMsg", --进行文本复读回复
				       groupid = 0, --不是私聊自然就为0咯
				       content =" [ATUSER("..data.FromUserId..")] 今天吃"..menu.."\n*"..result.."*可选命令->.添加菜单 ,完整菜单-> .今天吃啥菜单", --回复内容
				       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
				    }
				)
		
		foodarray = nil
		menu = nil
		result = nil
		
		return 1
    end	
		
	if string.find(data.Content, ".添加菜单") then
		
		
		local newrecipe = data.Content:gsub(".添加菜单", "")
		if data.FromUserId ==779091224 then --屏蔽某些捣乱的
			result = "你说你🐎呢"
		else	
			result = addrecipe(newrecipe)
		end
		luaMsg =
		    Api.Api_SendMsg(--调用发消息的接口
			CurrentQQ,
				{
				toUser = data.FromGroupId, --回复当前消息的来源群ID
				sendToType = 2, --2发送给群1发送给好友3私聊
				sendMsgType = "TextMsg", --进行文本复读回复
				groupid = 0, --不是私聊自然就为0咯
				content = result.."\n完整菜单请使用命令  .今天吃啥菜单", --回复内容
				atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
				}
 
		)

		result = nil
		return 1
	end
	
	if string.find(data.Content, ".今天吃啥菜单") then
		menu = " "

		foodarray = readfile()
		for i=1,#foodarray.arry,1 do
		menu = menu.."No"..i..foodarray.arry[i].."\n"
		end
		Api.Api_SendMsgV2( 
            CurrentQQ,
            {
                ToUserUid = data.FromGroupId,
                GroupID = 0,
                SendToType = 2, --2发送给群1发送给好友3私聊
                SendMsgType = "TextMsg" , --进行文本复读回复
                Content = "避免刷屏, 已发送至私聊信息"
            }
        )
	
		Api.Api_SendMsgV2( 
            CurrentQQ,
            {
                ToUserUid = data.FromUserId,
                GroupID = 0,
                SendToType = 1, --2发送给群1发送给好友3私聊
                SendMsgType = "TextMsg" , --进行文本复读回复
                Content = menu
            }
)
		Api.Api_SendMsgV2( 
            CurrentQQ,
            {
                ToUserUid = data.FromUserId,
                GroupID = data.FromGroupId,
                SendToType = 3, --2发送给群1发送给好友3私聊
                SendMsgType = "TextMsg" , --进行文本复读回复
                Content = menu
            }
        )

		menu = nil
	
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
function readfile()--读json
		local tbl ={}
		local f = io.input( menupath, "r" )--路径可能需要修改
		local t = f:read( "*a" )
		f:close()
		if nil ~= t and "" ~= t then
			tbl =json.decode( t )
			--local s = dump_tostring(tbl);--测试打印表格
			--print(s);--测试打印表格
			--print(jsonData)
			--print(t)
            if tbl == nil then
                print("Json error")
            end
		end
	return tbl
end
function writefile(content)
      local file = io.open(menupath, "w")
      if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
      else
        return false
      end
end
function addrecipe (newrecipe)


		local result = ""
		newrecipe = newrecipe:gsub(" ", "")
		if newrecipe == ""  then --消息为空返回错误信息

			result = "您是不是要喝西北风?" --回复内容
			
		
		else 
		
			local foodarray = readfile()
			table.insert(foodarray.arry, newrecipe) --插入新菜
				
		
			local str = json.encode(foodarray)		--编码
			if writefile(str)	== true	 then		--覆盖写入
		
				result = "写入成功"
			
			else 
			
				result = "写入失败"
	
			end
		end
	return result
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
