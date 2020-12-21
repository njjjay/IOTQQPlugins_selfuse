local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
function ReceiveFriendMsg(CurrentQQ, data)
if data.FromUin ==2986807981 then--防止自我复读
		  return 1 end
if string.find(data.Content, "trumpdeathclock" )  then

	response, error_message =
            http.request(
            "GET",
            "https://api.covidtracking.com/v1/us/current.json" --从json接口获取https://covidtracking.com/data/api/
        )
    html = response.body
	result = json.decode(html) --反序列化json
	local totalcases=result[1].positive
	--local s = dump_tostring(result);--测试打印表格
	--print(s);--测试打印表格
	local death  = result[1].death
	local deathincrease = result[1].deathIncrease
	--log.notice("death=\n%s", death)
	--local deathclock =  tostring(math.ceil(0.6*tonumber(death)))--取整*0.6
	local deathdate = result[1].date
	local dailyincrease = result[1].positiveIncrease
		luaMsg =
					    Api.Api_SendMsg(--调用发消息的接口
					    CurrentQQ,
					    {
					       toUser = data.FromUin, --回复当前消息的来源群ID
					       sendToType = 1, --2发送给群1发送给好友3私聊
					       sendMsgType = "TextMsg", --进行文本复读回复
					       groupid = 0, --不是私聊自然就为0咯
					       content = "At "..deathdate.."\n" 
									..death.."(+"..deathincrease..") people who have died from COVID-19 in USA\n"
									..totalcases.." total cases(+"..dailyincrease.." today) in USA", --回复内容
					       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
					    }
					)
					
	html = nil
    result = nil
	death = nil
	deathdate = nil
	dailyincrease = nil

	end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end
	if string.find(data.Content, "trumpdeathclock")   then --发送trumpdeathclock获取美国新冠死亡数据
	
	response, error_message =
            http.request(
            "GET",
            "https://api.covidtracking.com/v1/us/current.json" --从json接口获取https://covidtracking.com/data/api/
        )
    html = response.body
	result = json.decode(html) --反序列化json
	local totalcases=result[1].positive
	--local s = dump_tostring(result);--测试打印表格
	--print(s);--测试打印表格
	local death  = result[1].death
	local deathincrease = result[1].deathIncrease
	--log.notice("death=\n%s", death)
	--local deathclock =  tostring(math.ceil(0.6*tonumber(death)))--取整*0.6
	local deathdate = result[1].date
	local dailyincrease = result[1].positiveIncrease

		luaMsg =
				    Api.Api_SendMsg(--调用发消息的接口
				    CurrentQQ,
				    {
				       toUser = data.FromGroupId, --回复当前消息的来源群ID
				       sendToType = 2, --2发送给群1发送给好友3私聊
				       sendMsgType = "TextMsg", --进行文本复读回复
				       groupid = 0, --不是私聊自然就为0咯
				       content =	 "At "..deathdate.."\n" 
									..death.."(+"..deathincrease..") people who have died from COVID-19 in USA\n"
									..totalcases.." total cases(+"..dailyincrease.." today) in USA", --回复内容
				       atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
				    }
				)
	html = nil
    result = nil
	death = nil
	deathdate = nil
	dailyincrease = nil
    end

    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
local string_format = string.format;
local table_insert = table.insert;

function dump_r(t)

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

function dump_tostring(t)
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

