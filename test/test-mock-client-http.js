var expect = require('expect.js');
var mockHttp =  require('./lib/mock-client-http');
var ep = require('event-pipe');
var Url = require('url');

describe('mock-client-http', function(){

  describe('sample', function(){
    it('sample', function(done){
      var options = {
        method: 'get',
        url: 'http://localhost/r/s',
        chunks: ['abc']
      };
      var mock = mockHttp(options);
      var chunks = [];
      mock.req.on('data', function(chunk){
        chunks.push(chunk.toString());
      });
      mock.req.on('end', function(){
        expect(chunks[0]).to.be('abc');
      });
      expect(mock.req.url).to.be('http://localhost/r/s');
      expect(mock.req.method).to.be('get');
      mock.resp.write('abc');
      mock.resp.end();
      mock.resp.on('end', function(chunks){
        expect(chunks).to.eql(['abc']);
        mock.req.end();
        expect(mock.chunks.length).to.be(0);
        expect(mock.headers).to.be.empty();
        done();
      });
    });
    it('chunks is null', function(done){
      var options = {
        method: 'get',
        url: 'http://localhost/r/s'
      };
      var mock = mockHttp(options);
      var chunks = [];
      mock.req.on('data', function(err, chunk){
        chunks.push(chunk.toString());
      });
      mock.req.on('end', function(){
        expect(chunks.length).to.be(0);
        done();
      });
    });
  });
});
