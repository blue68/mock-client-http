Mock-client-http
================

npm install mock-client-http

var mockClientHttp = require('mock-client-http')
var Test = require('abc'); //需要测试的js
var options = {
    method : 'get',
    url : 'http://localhost:8080/test',
    session : {
        user: {}
    },
    chunks : ['abc'],
    error : {}
}

var mock = mockClientHttp(options);
var test = Test({});
var _middleware = test.middleware()(mock.req, mock.resp)
mock.resp.on('end', function(chunks){
  //输出值和期望值比较 
});


