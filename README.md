# mock-client-http  [![Build Status](https://travis-ci.org/blue68/mock-client-http.svg?branch=master)](https://travis-ci.org/blue68/mock-client-http)


A simulation tool client http


# Install

Install using [npm](https://npmjs.org/package/mock-client-http).

```
npm install mock-client-http --save-dev

```

# Usage

```js

    var mockClientHttp = require('mock-client-http');
    var Test = require('abc'); //需要测试的js, 基于connect 或 express的middleware
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

```