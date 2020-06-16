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

if string.find(data.Content, "降水量") then 


        response, error_message =
            http.request(
            "GET",
            "http://www.nmc.cn/rest/category/339" --从官方json接口获取图像列表
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
                content = "24小时预报" ..image.dataList[1].updateDate.. "", --获取最后发布时间
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
if string.find(data.Content, "华东雷达图") then 


        response, error_message =
            http.request(
            "GET",
            "http://www.nmc.cn/rest/category/99" --从官方json接口获取图像列表
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
                content = "" ..image.dataList[1].updateDate.. "", --获取最后发布时间
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
if string.find(data.Content, "看看副高") then --亚欧500hPa叠加卫星云图


        response, error_message =
            http.request(
            "GET",
            "http://www.nmc.cn/rest/category/3226" --从官方json接口获取图像列表
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
                content = "" ..image.dataList[1].updateDate.. "填图要素包括：风向风速和温度露点差；天气系统符号包括：高压中心（H）、低压中心（L）、暖中心（W）、冷中心（C）和台风符号；蓝色等值线为等高线（单位dagpm）；红色色等值线为等温线（单位℃），其中零摄氏度以下以虚线显示；底层填色为地形高度；顶层填色为红外卫星云图", --获取最后发布时间
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
if string.find(data.Content, "台风预警") then 


        response, error_message =
            http.request(
            "GET",
            "http://www.nmc.cn/rest/category/429" --从官方json接口获取图像列表
        )
        local html = response.body
        local str = html:gsub("/medium","") --从返回包体中替换掉medium图片路径，转为原文件
	local image = json.decode(str) --反序列化json
	local contenttest=image.dataList[1].content
	local keyWord = cutstring(contenttest)--html语言报文处理
		keyWord=string.sub(keyWord,0,290)--预警文本太长超过300字发不出计划切290字出来发 之后省略	
		if image.dataList[1].imgPath~="" then--判断图片是否为空
		ApiRet =
           	 Api.Api_SendMsg( 
           	 CurrentQQ,
          	  {
              	toUser = data.FromGroupId,
           	sendToType = 2,
         	sendMsgType = "PicMsg",
           	content =keyWord.."(已省略过长文本)完整预警内容请访问http://www.nmc.cn/publish/typhoon/warning.html", 
           	atUser = 0,
       	        voiceUrl = "",
                voiceBase64Buf = "",
                picUrl = "http://image.nmc.cn/" ..image.dataList[1].imgPath.. "", --从中央气象台的image站获取最后的图像
      	        picBase64Buf = "",
		fileMd5 = ""
            	}
      		)
		end
		if image.dataList[1].imgPath=="" then--图片为空
			ApiRet =
           	 Api.Api_SendMsg( 
           	 CurrentQQ,
          	  {	toUser = data.FromGroupId,
           		sendToType = 2,
         		sendMsgType = "TextMsg",
			groupid = 0,
			content =keyWord.."(已省略过长文本)完整预警内容请访问http://www.nmc.cn/publish/typhoon/warning.html",
			atUser = 0
		}
      		)
		end

	
    --log.notice("test-%s", reportstr)
	html = nil
        str = nil
	image = nil
	keyWord =nil
	contenttest=nil	
				
    end		


    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

function cutstring(str)
po1="<div class=\"writing\">"
po2="</p><p></p><p>"
_,i=string.find(str, po1)
j,_=string.find(str, po2)

result=string.sub(str,i+1,j-1) --去除头尾
result=result:gsub("</p><p>","\n")--根据需要继续添加
result=result:gsub("<p>","\n")
result=result:gsub("</div>","")
result=result:gsub("<div class=\"subhead\">","")

return result
end