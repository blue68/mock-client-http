expect   = require 'expect.js'
mockHttp = require '../lib/mock-client-http'

describe 'mock-client-http', () ->

  it 'sample request', (done) ->
    options =
      method : 'get'
      url : 'http://localhost/r/s'
      chunks : ['abc']
    chunks = []
    mock = mockHttp options
    mock.req.on 'data', (chunk) ->
      chunks.push chunk.toString()
    mock.req.on 'end', () ->
      expect(chunks[0]).to.be('abc')
    expect(mock.req.url).to.be('http://localhost/r/s')
    expect(mock.req.method).to.be('get')
    mock.resp.write('abc')
    mock.resp.end()
    mock.resp.on 'end', (chunks) ->
      expect(chunks).to.eql(['abc'])
      mock.req.end()
      expect(mock.chunks.length).to.be(0)
      expect(mock.headers).to.be.empty()
      done()

  it 'chunks is null', (done) ->
    options =
      method: 'get',
      url: 'http://localhost/r/s'
    mock = mockHttp options
    chunks = []
    mock.req.on 'data', (err, chunk) ->
      chunks.push chunk.toString()
    mock.req.on 'end', () ->
      expect(chunks.length).to.be(0)
      done()

  it 'The end method call response', (done) ->
    options =
      method : 'get'
      url : 'http://localhost/r/s'
      chunks : ['abc']
    chunks = []
    mock = mockHttp options
    mock.req.on 'data', (chunk) ->
      chunks.push chunk.toString()
    mock.req.on 'end', () ->
      expect(chunks[0]).to.be('abc')
    expect(mock.req.url).to.be('http://localhost/r/s')
    expect(mock.req.method).to.be('get')
    mock.resp.setHeader 'Content-Type', 'text/plain'
    mock.resp.end('abc')
    mock.resp.on 'end', (chunks) ->
      expect(chunks).to.eql(['abc'])
      expect(mock.headers).to.eql({ 'content-type': 'text/plain' })
      mock.req.end()
      expect(mock.chunks.length).to.be(0)
      expect(mock.headers).to.be.empty()
      done()

  it 'error', (done) ->
    options =
      method: 'get',
      url: 'http://localhost/r/s'
      error :
        code : 404
        message : 'file not found'
      chunks : []
    mock = mockHttp options
    chunks = []
    mock.req.on 'error', (err, chunk) ->
      expect(err.code).to.be(404)
      expect(err.message).to.be('file not found')
      done()
