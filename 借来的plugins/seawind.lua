-- 获取中央气象台NMC最新发布的海上大风预警图
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
if string.find(data.Content, "seawind") then --匹配关键词seawind
        response, error_message = 
            http.request(
            "GET",
            "http://www.nmc.cn/rest/category/3980" 
        )
        local html = response.body 
		local str = html
		local j = json.decode(str)    
		local word = j.dataList[1].dataDesc --匹配预警发布的时间和描述，若当日没有发布则默认取最后一次的预警
		local link = j.dataList[1].imgPath --获取medium中尺寸图片路径
		local linkbig = link:gsub("/medium","") --替换掉medium获取原始尺寸高清大图
            ApiRet =
                Api.Api_SendMsg(
                CurrentQQ,
                {
                    toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "PicMsg",
                content = "" ..word.. "",
                atUser = 0,
                voiceUrl = "",
                voiceBase64Buf = "",
                picUrl = "http://image.nmc.cn" ..linkbig.. "", --补全image路径，若发送过慢请将linkbig改为link
                picBase64Buf = "",
				fileMd5 = ""
                }
            )
  end
  return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
