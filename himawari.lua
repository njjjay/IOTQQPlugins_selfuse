local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.FromUserId ==2986807981 then--防止自我复读
		  return 1 end
	

	if string.find(data.Content, "机动观测") then
	local url=""
	local des=""
	url="https://weather-models.info/latest/nocache/himawari/target/vis0.png"
	des="正在获取葵8机动观测可见光云图(夜间可能不可用)"--获取向日葵8号可视图夜间可能不可用
	
		if string.find(data.Content, "机动观测") and string.find(data.Content, "BD")  then
		url="https://weather-models.info/latest/nocache/himawari/target/color0.png"
		des="正在获取葵8机动观测红外云图"
		end
	

		ApiRet=Api.Api_SendMsg( 
         	   CurrentQQ,
			{toUser = data.FromGroupId,
           	 	sendToType = 2,
          	 	sendMsgType = "PicMsg",
         	 	content = des , 
         	 	atUser = 0,
         	      	picUrl = url , 
        	        picBase64Buf = "",
			fileMd5 = ""
			}
			)
	url= nil
	des=nil
	end
	if string.find(data.Content, "海面温度") then
	local getday=os.date("%d")
	--log.notice("getday=\n", getday)
	url=string.format("https://weather-models.info/latest/images/sea/%d/wpac-tc-sst.png",getday)
	des=string.format("正在获取%d日海面温度图",getday)
		ApiRet=Api.Api_SendMsg( 
         	   CurrentQQ,
			{toUser = data.FromGroupId,
           	 	sendToType = 2,
          	 	sendMsgType = "PicMsg",
         	 	content = des , 
         	 	atUser = 0,
         	      	picUrl = url , 
        	        picBase64Buf = "",
			fileMd5 = ""
			}
			)
	url= nil
	des=nil
	end





    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end