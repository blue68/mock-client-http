var events = require('events');

var MockHttp = function(options){
  this.options = options || {};
  this.chunks = [];
  this.headers = {};
  var _this = this;
  this.req = new events.EventEmitter();
  this.req.session = {};
  this.req.url = _this.options.url;
  this.req.method = _this.options.method;
  if(_this.options.chunks !== undefined && _this.options.chunks !== null){
    this.req.chunks = _this.options.chunks;
    var flag = 0, len, i;
    len = this.req.chunks.length;
    if(_this.options.error){
      process.nextTick(function(){
        _this.req.emit('error', _this.options.error);
      });
    }else{
      for (i = 0; i < len; i++){
        flag ++;
        var chunk = this.req.chunks[i];
        (function(chunk){
           process.nextTick(function(){
            var buffer = new Buffer(chunk);
            _this.req.emit('data', buffer);
          });
          if(flag === len){
            process.nextTick(function(){
              _this.req.emit('end');
            });
          }
        })(chunk);
      }
    }
  }else{
    process.nextTick(function(){
      _this.req.emit('end');
    });
  }
  this.req.end = function(){
    _this.clean();
  };
  this.resp = new events.EventEmitter();
  this.resp.write = function(data){
    _this.chunks.push(data);
  };
  this.resp.end = function(){
    process.nextTick(function(){
      _this.resp.emit('end', _this.chunks);
    });
  };
  this.resp.setHeader = function(name, value){
    return _this.headers[name.toLowerCase()] = value;
  };
};

MockHttp.prototype.clean = function(){
  this.chunks = [];
  this.headers = {};
};
module.exports = function(options){
  return new MockHttp(options);
};
