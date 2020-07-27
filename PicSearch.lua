local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)

if data.FromUin ==2986807981 then--防止自我复读
		  return 1 end
  		if string.find(data.MsgType, "PicMsg") then 
				str = json.decode(data.Content)
				log.notice("str.Content--->  %s", str.Content)
				if str.Content == nil then
					return 1
				end
				if string.find(str.Content, "搜图") then
				loadingF(CurrentQQ,data)
  				img_url = str.FriendPic[1].Url--私聊搜图是FriendPic
				log.notice("MsgType--->   %s", data.MsgType)
  				log.notice("img_url--->   %s", img_url)
          response, error_message =
                 http.request(
                 "GET",
          				"https://saucenao.com/search.php?",
                 {
                     query = "db=999&output_type=2&testmode=1&numres=1&url=" ..
                         img_url,
                     headers = {
          								["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
					}
                 }
             )
  				local html = response.body
  				--log.notice("html-->%s",html)
  				local re = json.decode(html)
  				-- log.notice("re---> %s", re)
				--[[for k, v in pairs(re.results[1].data) do --遍历结果测试用
					print(k, v)
				end]]--
  				local similarity = re.results[1].header.similarity		--相似度
  				local thumbnail_url = re.results[1].header.thumbnail	--缩略图地址
  				local title = re.results[1].data.title					--标题
  				local pixiv_id = re.results[1].data.pixiv_id			--p站id
				
				
				--##处理作者名开始########
  				local member_name = re.results[1].data.member_name 
			
				local data_creator =  ""
				if type(re.results[1].data.creator)=="table" then	--data.creator可能是个string也可能是个table
					data_creator = re.results[1].data.creator[1]
				else
					data_creator = re.results[1].data.creator
				end					
				
				
				if member_name == nil then
					member_name = data_creator
					if member_name == nil then
						member_name = re.results[1].data.artist
						if	member_name == nil then
							member_name = re.results[1].data.author
						end	
					end	
				end	
				if member_name ==nil then --上面三个字段全都没有就认命了 给个空字符串
					member_name =""
					--log.notice("member_name= %s", member_name)
				end
				--##处理作者名结束##########
				
				--###处理其他信息开始,有时是地址有时是作品信息(data.source)##########
				local data_source = ""
				if type(re.results[1].data.source)=="table" then	--data.source可能是个string也可能是个table
					data_source = re.results[1].data.source[1]
				else
					data_source = re.results[1].data.source
				end
				if  data_source==nil then --api返回的结果可能没有source字段
					data_source = ""
					--log.notice("data_source= %s", data_source)
				end
				--####处理其他信息开始结束###########
				
				--###处理插画链接开始###########
				local ext_urls=""
				if type(re.results[1].data.ext_urls)=="table" then	--data.ext_urls可能是个string也可能是个table
					ext_urls = re.results[1].data.ext_urls[1]
				else
					ext_urls = re.results[1].data.ext_urls
					
				end
				--log.notice("ext_urls =  %s", ext_urls)
				--###处理插画链接结束#########
          luaRes =
              Api.Api_SendMsg(--调用发消息的接口
              CurrentQQ, 
			 { 
		        toUser = data.FromUin, --回复当前消息的来源群ID
		        sendToType = 1, --2发送给群1发送给好友3私聊
		        sendMsgType = "PicMsg", --进行文本复读回复 
		        content = string.format(
  									"\n相似度：%s\n标题：%s\nPixiv_ID：%d\n插画家昵称：%s \n插画链接：%s\n其他信息：%s ",
  									similarity,
  									title,
  									pixiv_id,
  									member_name,	
									ext_urls,
									data_source
									), --回复内容
				picUrl = thumbnail_url,
  				picBase64Buf = "",
  				fileMd5 = "" 
		    }
          )
          -- log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
      end
	end



    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end
  		if string.find(data.MsgType, "PicMsg") then 
				str = json.decode(data.Content)
				log.notice("str.Content--->  %s", str.Content)
				if str.Content == nil then
					return 1
				end
				if string.find(str.Content, "搜图") then
					loadingG(CurrentQQ,data)
  				img_url = str.GroupPic[1].Url
          log.notice("MsgType--->   %s", data.MsgType)
  				log.notice("img_url--->   %s", img_url)
          response, error_message =
                 http.request(
                 "GET",
          				"https://saucenao.com/search.php?",
                 {
                     query = "db=999&output_type=2&testmode=1&numres=1&url=" ..
                         img_url,
                     headers = {
          								["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
                     }
                 }
             )
  				local html = response.body
  				--log.notice("html-->%s",html)
  				local re = json.decode(html)
  				-- log.notice("re---> %s", re)
				--[[for k, v in pairs(re.results[1].data) do --遍历结果测试用
					print(k, v)
				end]]--
  				local similarity = re.results[1].header.similarity		--相似度
  				local thumbnail_url = re.results[1].header.thumbnail	--缩略图地址
  				local title = re.results[1].data.title					--标题
  				local pixiv_id = re.results[1].data.pixiv_id			--p站id
				
				
				--##处理作者名开始########
  				local member_name = re.results[1].data.member_name 
			
				local data_creator =  ""
				if type(re.results[1].data.creator)=="table" then	--data.creator可能是个string也可能是个table
					data_creator = re.results[1].data.creator[1]
				else
					data_creator = re.results[1].data.creator
				end					
				
				
				if member_name == nil then
					member_name = data_creator
					if member_name == nil then
						member_name = re.results[1].data.artist
						if	member_name == nil then
							member_name = re.results[1].data.author
						end	
					end	
				end	
				if member_name ==nil then --上面三个字段全都没有就认命了 给个空字符串
					member_name =""
					--log.notice("member_name= %s", member_name)
				end
				--##处理作者名结束##########
				
				--###处理其他信息开始,有时是地址有时是作品信息(data.source)##########
				local data_source = ""
				if type(re.results[1].data.source)=="table" then	--data.source可能是个string也可能是个table
					data_source = re.results[1].data.source[1]
				else
					data_source = re.results[1].data.source
				end
				if  data_source==nil then --api返回的结果可能没有source字段
					data_source = ""
					--log.notice("data_source= %s", data_source)
				end
				--####处理其他信息开始结束###########
				
				--###处理插画链接开始###########
				local ext_urls=""
				if type(re.results[1].data.ext_urls)=="table" then	--data.ext_urls可能是个string也可能是个table
					ext_urls = re.results[1].data.ext_urls[1]
				else
					ext_urls = re.results[1].data.ext_urls
					
				end
				--log.notice("ext_urls =  %s", ext_urls)
				--###处理插画链接结束#########
				
				
          luaRes =
              Api.Api_SendMsg(--调用发消息的接口
              CurrentQQ,
              {
                  toUser = data.FromGroupId, --回复当前消息的来源群ID
                  sendToType = 2, --2发送给群1发送给好友3私聊
                  sendMsgType = "PicMsg", --进行文本复读回复
  								content = string.format(
  									"\n相似度：%s\n标题：%s\nPixiv_ID：%d\n插画家昵称：%s \n插画链接：%s\n其他信息：%s ",
  									similarity,
  									title,
  									pixiv_id,
  									member_name,	
									ext_urls,
									data_source
									),
  								picUrl = thumbnail_url,
  								picBase64Buf = "",
  								fileMd5 = ""
              }
          )
          -- log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
      end
		end
      return 1
  end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
function loadingG(CurrentQQ,data)
		luaMsg =
		    Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromGroupId, --回复当前消息的来源群ID
		        sendToType = 2, --2发送给群1发送给好友3私聊
		        sendMsgType = "TextMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = "正在查询saucenao(只上传推特的大概率搜不到)[表情67]", --回复内容
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
	end
function loadingF(CurrentQQ,data)
		luaMsg =
		    Api.Api_SendMsg(--调用发消息的接口
		    CurrentQQ,
		    {
		        toUser = data.FromUin, --回复当前消息的来源群ID
		        sendToType = 1, --2发送给群1发送给好友3私聊
		        sendMsgType = "TextMsg", --进行文本复读回复
		        groupid = 0, --不是私聊自然就为0咯
		        content = "正在查询saucenao(只上传推特的大概率搜不到)[表情67]", --回复内容
		        atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
		    }
		)
	end
	
	
function table.kIn(tbl, key)--判断表中是否存在给定的Key值
    if tbl == nil then
        return false
    end
    for k, v in pairs(tbl) do
        if k == key then
            return true
        end
    end
    return false
end
