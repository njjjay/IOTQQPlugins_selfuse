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
	
		local newrecipe = data.Content:gsub(".添加菜单", "")
		
		result = addrecipe(newrecipe)
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

	if string.find(data.Content, ".今天吃啥") and data.Content:gsub(".今天吃啥", "")=="" then 
		--foodarray = {"汉堡","螺蛳粉","凉皮","火锅","过桥米线","饺子","铁锅饭","卤肉饭","炸酱面","麻辣烫","炒粉","云吞","炸鸡","手抓饼","拉面","泡面","牛排","寿司","木桶饭","冒菜","羊肉粉","馒头","皮蛋瘦肉粥","奶茶","黄焖鸡米饭","海鲜"}
		foodarray = readfile()
		--print(#foodarray.arry)
		
		math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 7)))  --https://blog.csdn.net/goodai007/article/details/59579515
		result = math.random(1 , #foodarray.arry)
		menu = foodarray.arry[result]
		luaMsg =
				    Api.Api_SendMsg(--调用发消息的接口
				    CurrentQQ,
				    {
				       toUser = data.FromGroupId, --回复当前消息的来源群ID
				       sendToType = 2, --2发送给群1发送给好友3私聊
				       sendMsgType = "TextMsg", --进行文本复读回复
				       groupid = 0, --不是私聊自然就为0咯
				       content =" [ATUSER("..data.FromUserId..")] 今天吃"..menu.."\n*"..result.."*命令.添加菜单 ,完整菜单请私聊我  .今天吃啥菜单", --回复内容
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
		
		result = addrecipe(newrecipe)
		luaMsg =
		    Api.Api_SendMsg(--调用发消息的接口
			CurrentQQ,
				{
				toUser = data.FromGroupId, --回复当前消息的来源群ID
				sendToType = 2, --2发送给群1发送给好友3私聊
				sendMsgType = "TextMsg", --进行文本复读回复
				groupid = 0, --不是私聊自然就为0咯
				content = result.."\n防止刷屏 完整菜单请私聊我  .今天吃啥菜单", --回复内容
				atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
				}
 
		)
		result = nil
		return 1
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
		if newrecipe == "" then --消息为空返回错误信息

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

function dump_r(t) --打印表格组件 测试用

--[[打印表格 用法
local s = dump_tostring(result)
print(s)
]]--
    local sp = " ";
    local function do_print(tt, l)
        local tp = type(tt);
        if (tp == "table") then
            l = l + 1;
            if (l - 1 == 0) then
                print("{");
            end
            for k, v in pairs(tt) do
                local pp = type(v);
                if (pp == "table") then
                    print(string_format("%"..l.."s[%s]={",sp,k));
                    do_print(v, l + 1);
                    print(string_format("%"..l.."s},",sp));
                else
                    print(string_format("%"..l.."s[%s]=%s,",sp,k,tostring(v)));
                end

            end
            if (l - 1 == 0) then
                print("}");
            end
        else
            print(string_format("%"..l.."s=%s,",sp,k,tostring(tt)));
        end

    end

    do_print(t, 0);
end

function dump_tostring(t)--打印表格组件 测试用
    local sp = " ";
    local list = {};
    local function addline(str)
        table_insert(list, str);
    end

    local function do_tostring(tt, l, ln)
        local tp = type(tt);
        if (tp == "table") then
            l = l + 1;
            if (l - 1 == 0) then
                addline("{");
            end
            for k, v in pairs(tt) do
                local pp = type(v);
                if (pp == "table") then
                    addline(string_format("%"..l.."s[%s]={",sp,k));
                    do_tostring(v, l + 1);
                    addline(string_format("%"..l.."s},",sp));
                else
                    addline(string_format("%"..l.."s[%s]=%s,",sp,k,tostring(v)));
                end

            end
            if (l - 1 == 0) then
                addline("}");
            end
        else
            addline(string_format("%"..l.."s=%s,",sp,k,tostring(tt)));
        end

    end

    do_tostring(t, 0);

    return table.concat(list, "\n");
end



