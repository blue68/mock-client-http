{EventEmitter} = require 'events'

class MockClientHttp
  constructor : (@options={}) ->
    @chunks = []
    @headers = {}
    @req = new EventEmitter()
    @req.session = @options.session or {}
    @req.url     = @options.url
    @req.headers = @options.headers or {}
    @req.method  = @options.method or 'get'
    _this = @
    if @options.chunks?
      @req.chunks = @options.chunks
      flag = 0
      len  = @req.chunks.length
      if @options.error
        process.nextTick () =>
          @req.emit 'error', @options.error
      else
        for item, i in @req.chunks
          flag++
          do (item) ->
            process.nextTick () ->
              buffer = new Buffer item
              _this.req.emit 'data', buffer
            if flag is len
              process.nextTick () ->
                _this.req.emit 'end'
    else
      process.nextTick () =>
        @req.emit 'end'

    @req.end = () =>
      @clean()

    @resp = new EventEmitter()
    @resp.statusCode = @options.statusCode
    @resp.write = (data) =>
      @chunks.push data
    @resp.end = (data) =>
      if @chunks.length > 0
        process.nextTick () ->
          _this.resp.emit 'end', _this.chunks
      else
        @chunks.push data
        process.nextTick () ->
          _this.resp.emit 'end', _this.chunks
    @resp.setHeader = (name, value) =>
      @headers[name.toLowerCase()] = value
    
    @resp.headers = @headers;
    
  clean : () ->
    @chunks = []
    @headers = {}

module.exports = (options) ->
  new MockClientHttp options
