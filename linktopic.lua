local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)

	if data.FromUin ==2986807981 then--防止自我复读
		 return 1 
	end
  	if string.find(data.Content, "链接转图") then 
		img_url = data.Content:gsub("链接转图", "")--获取链接
		log.notice("img_url--->  %s", img_url)
		
		if img_url == nil or  img_url=="" then --空链接退出
			return 1
		end
		 response, error_message =
                 http.request(
                 "GET",
          				img_url,
                 {
                     query = "",
                     headers = {
          								["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
					}
                 }
             )
  				local html = error_message
				
				--log.notice("error_message  %s", html)
				
				if html~=nil then
				
					luaMsg =
							Api.Api_SendMsg(--调用发消息的接口
							CurrentQQ,
							{
							toUser = data.FromUin, --回复当前消息的来源群ID
							sendToType = 1, --2发送给群1发送给好友3私聊
							sendMsgType = "TextMsg", --进行文本复读回复
							groupid = 0, --不是私聊自然就为0咯
							content = "淦 老哥你的鸡掰地址好几把怪啊"..html, --回复内容
							atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
							}
						)
						return 1
				end
				local re=response.headers
				--print(json.encode(response.headers))
				local ContentType="Content-Type"--减号是特殊字符 要么转义要么拐弯抹角 欢迎告诉我怎么转义变量名里的符号
				ContentType=re[ContentType]
				--[[for k, v in pairs(re) do --遍历结果测试用
					print(k, v)
				end]]--
				if string.find(ContentType, "image") == 1 then
					luaRes =
						Api.Api_SendMsg(--调用发消息的接口
						CurrentQQ,
						{
							toUser =data.FromUin, --回复当前消息的来源群ID
							sendToType = 1, --2发送给群1发送给好友3私聊
							sendMsgType = "PicMsg", --进行文本复读回复
							content = "受限于服务器本身不能翻墙不保证能发出图片",
							picUrl = img_url,
							picBase64Buf = "",
							fileMd5 = ""
						}
					)
					
					-- log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
					else
						 --返回类型不是image/***就退出
							
							luaMsg =
							Api.Api_SendMsg(--调用发消息的接口
							CurrentQQ,
							{
							toUser = data.FromUin, --回复当前消息的来源群ID
							sendToType = 1, --2发送给群1发送给好友3私聊
							sendMsgType = "TextMsg", --进行文本复读回复
							groupid = 0, --不是私聊自然就为0咯
							content = "淦 老哥你的鸡掰地址好几把怪啊,类型不是图片诶它是"..ContentType, --回复内容
							atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
							}
						)
					
						return 1
						end
					
				end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		return 1 
	end
  	if string.find(data.Content, "链接转图") then 
		img_url = data.Content:gsub("链接转图", "")--获取链接
		log.notice("img_url--->  %s", img_url)
		
		if img_url == nil or  img_url=="" then --空链接退出
			return 1
		end
		 response, error_message =
                 http.request(
                 "GET",
          				img_url,
                 {
                     query = "",
                     headers = {
          								["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
					}
                 }
             )
  				local html = error_message
				
				--log.notice("error_message  %s", html)
				
				if html~=nil then
				
					luaMsg =
							Api.Api_SendMsg(--调用发消息的接口
							CurrentQQ,
							{
							toUser = data.FromGroupId, --回复当前消息的来源群ID
							sendToType = 2, --2发送给群1发送给好友3私聊
							sendMsgType = "TextMsg", --进行文本复读回复
							groupid = 0, --不是私聊自然就为0咯
							content = "淦 老哥你的鸡掰地址好几把怪啊"..html, --回复内容
							atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
							}
						)
						return 1
				end
				local re=response.headers
				--print(json.encode(response.headers))
				local ContentType="Content-Type"--减号是特殊字符 要么转义要么拐弯抹角 欢迎告诉我怎么转义变量名里的符号
				ContentType=re[ContentType]
				--[[for k, v in pairs(re) do --遍历结果测试用
					print(k, v)
				end]]--
				if string.find(ContentType, "image") == 1 then
					luaRes =
						Api.Api_SendMsg(--调用发消息的接口
						CurrentQQ,
						{
							toUser = data.FromGroupId, --回复当前消息的来源群ID
							sendToType = 2, --2发送给群1发送给好友3私聊
							sendMsgType = "PicMsg", --进行文本复读回复
							content = "受限于服务器本身不能翻墙不保证能发出图片",
							picUrl = img_url,
							picBase64Buf = "",
							fileMd5 = ""
						}
					)
					
					-- log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
					else
						 --返回类型不是image/***就退出
							
							luaMsg =
							Api.Api_SendMsg(--调用发消息的接口
							CurrentQQ,
							{
							toUser = data.FromGroupId, --回复当前消息的来源群ID
							sendToType = 2, --2发送给群1发送给好友3私聊
							sendMsgType = "TextMsg", --进行文本复读回复
							groupid = 0, --不是私聊自然就为0咯
							content = "淦 老哥你的鸡掰地址好几把怪啊,类型不是图片诶它是"..ContentType, --回复内容
							atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
							}
						)
					
						return 1
						end
					
				end
      return 1
end
		
     

function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
	