local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local tarot = {
				[0] = "愚者（The Fool，0）" ,
				[1] = "魔术师（The Magician，I）" ,
				[2] = "女祭司（The High Priestess，II）" ,
				[3] = "女皇（The Empress，III）" ,
				[4] = "皇帝（The Emperor，IV）" ,
				[5] = "教皇（The Hierophant，or the Pope，V）" ,
				[6] = "恋人（The Lovers，VI）" ,
				[7] = "战车（The Chariot，VII）" ,
				[8] = "力量（Strength，VIII）" ,
				[9] = "隐者（The Hermit，IX）" ,
				[10] = "命运之轮（The Wheel of Fortune，X）" ,
				[11] = "正义（Justice，XI）" ,
				[12] = "倒吊人（The Hanged Man，XII）" ,
				[13] = "死神（Death，XIII）" ,
				[14] = "节制（Temperance，XIV）" ,
				[15] = "恶魔（The Devil ，XV）" ,
				[16] = "塔（The Tower，XVI）" ,
				[17] = "星星（The Star，XVII）" ,
				[18] = "月亮（The Moon，XVIII）" ,
				[19] = "太阳（The Sun，XIX）" ,
				[20] = "审判（Judgement，XX）" ,
				[21] = "世界（The World，XXI）" 
			}
local inverse = {"正" , "逆" }
function ReceiveFriendMsg(CurrentQQ, data) 
	
	if string.find(data.Content, "塔罗牌") == 1 and data.Content:gsub("塔罗牌", "")==""   then

	Send_friendmsg(CurrentQQ, data,"正在虔诚洗牌...")
	shuffle(tarot)
	os.execute("sleep " .. 3)
	result1,result2,result3= getrandomint(21)
	result1 = tarot[result1]
	result2 = tarot[result2]
	result3 = tarot[result3]
	
	math.randomseed(os.time()+assert(tonumber(tostring({}):sub(7))))
	inverse1 = inverse[math.random(1 , 2)]
	inverse2 = inverse[math.random(1 , 2)]
	inverse3 = inverse[math.random(1 , 2)]
	Send_friendmsg(CurrentQQ, data,"你抽出了\n"..		
			inverse1.."位 "..result1.."\n"..
			inverse2.."位 "..result2.."\n"..
			inverse3.."位 "..result3)
	
	end
return 1 

end

function ReceiveGroupMsg(CurrentQQ, data)
	if string.find(data.Content, "塔罗牌") == 1 then

	Send_msg(CurrentQQ, data,"正在虔诚洗牌...")
	shuffle(tarot)

	
	os.execute("sleep " .. 3)
	result1,result2,result3= getrandomint(21)
	result1 = tarot[result1]
	result2 = tarot[result2]
	result3 = tarot[result3]
	--print(result1.."\n")
	--print(result2.."\n")
	--print(result3.."\n")
	math.randomseed(os.time()+assert(tonumber(tostring({}):sub(7))))
	inverse1 = inverse[math.random(1 , 2)]
	inverse2 = inverse[math.random(1 , 2)]
	inverse3 = inverse[math.random(1 , 2)]
	Send_msg(CurrentQQ, data,"你抽出了\n"..
			
			inverse1.."位 "..result1.."\n"..
			inverse2.."位 "..result2.."\n"..
			inverse3.."位 "..result3)
	
	end

    return 1

end
function  shuffle(t)
	local randomnum = 0
	local temp = ""
	math.randomseed(os.time()+assert(tonumber(tostring({}):sub(7))))
		
	for i=#t,1,-1 do
		randomnum = math.random(0 , i-1)
		--print(randomnum.."-rand\n")
		temp = t[randomnum]
		t[randomnum] = t[i]
		t[i] = temp
	end
	randomnum = nil
	temp = nil	
		return t
   
end

function getrandomint(n)
			local bodytable = {
  				jsonrpc= "2.0",
  				method= "generateIntegers",
  				params= {
    					apiKey= "aaaa-bbb-ccccc", ---需要自己申请 apikey    https://api.random.org/dashboard/details
						n= 3,
    					min= 0,
     					max= n,
						replacement= false,
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
	return res.result.random.data[1],res.result.random.data[2],res.result.random.data[3]
end

function Send_msg(CurrentQQ, data,resultstr)
    Api.Api_SendMsg( -- 调用发消息的接口
    CurrentQQ, {
        toUser = data.FromGroupId, -- 回复当前消息的来源群ID
        sendToType = 2, -- 2发送给群1发送给好友3私聊
        sendMsgType = "TextMsg", -- 进行文本复读回复
        groupid = 0, -- 不是私聊自然就为0咯
        content = resultstr, -- 回复内容
        atUser = data.FromUserId -- 是否 填上data.FromUserId就可以复读给他并@了
    })
end
function Send_friendmsg(CurrentQQ, data,resultstr)

		luaMsg =
		    Api.Api_SendMsg(--调用发消息的接口
			CurrentQQ,
			{
		    toUser = data.FromUin, --回复当前消息的来源群ID
			sendToType = 1, --2发送给群1发送给好友3私聊
			sendMsgType = "TextMsg", --进行文本复读回复
			groupid = 0, --不是私聊自然就为0咯
			content = resultstr, --回复内容
			
			}
 
		)
		
end
function ReceiveEvents(CurrentQQ, data, extData) return 1 end

