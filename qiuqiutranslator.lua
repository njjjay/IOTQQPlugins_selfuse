local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
--#########路径根据实际需要修改###########
local dictpath = "/root/opqbot/Plugins/qiu_qiu_dictionary.json" --,源文件见https://github.com/H-K-Y/Genshin_Impact_bot/blob/main/qiu_qiu_translation/qiu_qiu_dictionary.json

function ReceiveFriendMsg(CurrentQQ, data)
	if data.FromUin ==2986807981 then--防止自我复读
		  return 1 end

	return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end

	if string.find(data.Content, "丘丘翻译") == 1 then--菜单插件
		
		sourcestr = data.Content:gsub("丘丘翻译", "")
		jsonData=readfile()
		--print(sourcestr)

	if sourcestr == ""	then return 1 end--空消息无需发送
	
	result = inword(sourcestr,jsonData)--查找单词
	print("result=",result)	
	if result==false then
	result = inphrase(sourcestr,jsonData)	--如果没找到单词则查找短句
	print("result=",result)
		if result==false then result ="没有找到对应翻译" end	--如果都没找到报个错
	end
	
					luaMsg =
				    Api.Api_SendMsg(--调用发消息的接口
				    CurrentQQ,
				    {
				       toUser = data.FromGroupId, --回复当前消息的来源群ID
				       sendToType = 2, --2发送给群1发送给好友3私聊
				       sendMsgType = "TextMsg", --进行文本复读回复
				       groupid = 0, --不是私聊自然就为0咯
				       content = result, --回复内容
				       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
				    }
				)
	end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
function readfile()--读词典json
		local tbl ={}
		local f = io.input( dictpath, "r" )--路径可能需要修改
		local t = f:read( "*a" )
		f:close()
		if nil ~= t and "" ~= t then
			tbl =json.decode( t )
			--local s = dump_tostring(jsonData);--测试打印表格
			--print(s);--测试打印表格
			--print(jsonData)
			--print(t)
            if tbl == nil then
                print("Json error")
            end
		end
	return tbl
end
function inword(key,tbl)--判断是否在word表
	if tbl == nil then
        return false
    end
    for k, v in pairs(tbl.word) do
	print(k,v)
        if k == key then
            return tbl.word[key] --如果找到了丘丘语则返回中文
        end
		if v == key then
			return k	--如果找到了中文则返回丘丘语
		end
    end
    return false

end
function inphrase(key,tbl)--判断是否在phrase表
	if tbl == nil then
        return false
    end
    for k, v in pairs(tbl.phrase) do
        if k == key then
            return tbl.phrase[key] --如果找到了丘丘语则返回中文
        end
		if v == key then
			return k --如果找到了中文则返回丘丘语
		end
    end
    return false
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

