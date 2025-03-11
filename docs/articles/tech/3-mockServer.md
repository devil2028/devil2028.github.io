# Node本地搭建Mock Server

## 目标
本地Mock模拟Http的503错误码

## 搭建环境
1.安装Node.js环境

2.安装依赖：`npm install express --save`

3.安装依赖：`npm install cors --save`

# 代码实现

mock-server.js

```
//本地Mock模拟503错误码
//
//本机请求地址：http://10.0.2.2:3000/api
//搭建环境：
//1.安装Node.js环境
//2.安装依赖：npm install express --save
//3.安装依赖：npm install cors --save

const express = require('express');
const app = express();
const port = 3000;

// 增加请求体大小限制 (这里设置为 50MB)
app.use(express.json({ limit: '50mb' })); // 支持 JSON 格式
app.use(express.urlencoded({ 
  extended: true,
  limit: '50mb' // 支持表单格式
}));
app.use(require('cors')());

app.all('/api/*', (req, res) => {
  console.log(`[${req.method}] ${req.path} 请求大小: ${JSON.stringify(req.body)?.length || 0} bytes`);

  // 根据路径设置不同状态码
  let statusCode = 503;
  let message = "Service Unavailable";
  
  // if (req.path === '/integration/timing/getServerTime') {
  //   statusCode = 422;
  //   message = "Unprocessable Entity";
  // } else if (req.path === '/integration/sdk/listMiniapp') {
  //   statusCode = 403;
  //   message = "Forbidden";
  // }

  res.status(statusCode)
    .set('Content-Type', 'application/json')
    .json({ 
      code: statusCode,
      message: message,
      path: req.path,
      timestamp: new Date().toISOString()
    });
});


app.listen(port, () => {
  console.log(`Mock server running at http://localhost:${port}`);
});

```


## 启动服务
```bash
node mock-server.js
```

## 本机请求测试地址
本机请求地址：http://10.0.2.2:3000/api