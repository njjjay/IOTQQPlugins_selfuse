local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)

if data.FromUin ==2986807981 then--防止自我复读
		  return 1 end
  	
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end
  		if string.find(data.Content, "链接转图") then 
				 img_url = data.Content:gsub("链接转图", "")--获取链接
				log.notice("img_url--->  %s", img_url)
				if img_url == nil then
					return 1
				end
				
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
      end
		
      return 1
 end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
