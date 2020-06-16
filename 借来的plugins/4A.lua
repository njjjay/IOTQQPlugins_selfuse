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
if string.find(data.Content, "真彩色") then --发送真彩色获取风云4A最新的真彩色高清图像
        response, error_message =
            http.request(
            "GET",
            "http://www.nmc.cn/rest/category/d3236549863e453aab0ccc4027105bad" --从官方json接口获取图像列表
        )
        local html = response.body
        local str = html:gsub("/medium","") --从返回包体中替换掉medium图片路径，转为原文件
	local image = json.decode(str) --反序列化json
		ApiRet =
            Api.Api_SendMsg( 
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "PicMsg",
                content = "已获取最新的FY-4A图像\n发布于" ..image.dataList[1].updateDate.. "", --获取最后发布时间
                atUser = 0,
                voiceUrl = "",
                voiceBase64Buf = "",
                picUrl = "http://image.nmc.cn/" ..image.dataList[1].imgPath.. "", --从中央气象台的image站获取最后的图像
                picBase64Buf = "",
		fileMd5 = ""
            }
        )
	html = nil
        str = nil
	image = nil
    end

    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
