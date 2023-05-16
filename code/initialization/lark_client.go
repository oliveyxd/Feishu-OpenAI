package initialization

import (
	lark "github.com/larksuite/oapi-sdk-go/v3"
)
//飞书开放接口SDK
//https://github.com/larksuite/oapi-sdk-go

var larkClient *lark.Client

func LoadLarkClient(config Config) {
	larkClient = lark.NewClient(config.FeishuAppId, config.FeishuAppSecret)
}

func GetLarkClient() *lark.Client {
	return larkClient
}
