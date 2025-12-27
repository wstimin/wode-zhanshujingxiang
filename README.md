一个 UUID (用户ID)
去 UUID Generator 生成一个。
例如：550e8400-e29b-41d4-a716-446655440000

一个Cloudflare 账号
你需要一个绑定了域名的 Cloudflare 账号。

镜像：shiyeo1/wode-zhanshujingxiang

部署cf隧道，端口一定是8080。 
zeabut变量：TUNNEL_TOKEN = cfTOKEN  ，UUID = 自己生成的 ，  WSPATH = /a

config.template.json文件修改你生成好的uuid，把 "这里填你的UUID" 换成你准备好的真实 UUID。

index.html文件修改：找到代码底部的 const MY_UUID = "..."，填入你真实的 UUID


打开浏览器访问：https://你的域名[zeabut分配的域名.端口也是8080】

你会看到一个粉色的动漫页面。

点击页面上的 “一键复制” 按钮。

打开 V2RayN / Shadowrocket / v2rayNG，从剪贴板导入。
