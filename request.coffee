# Description:
#   SuperAgent backed HTTP request plugin for hubot
#
# Commands:
#   hubot request get <url> [options] - send GET request
#   hubot request post <url> [options] - send POST request
#   hubot request create <url> [options] - send CREATE request
#   hubot request delete <url> [options] - send DELETE request
#   hubot request (put|update) <url> [options] - send PUT request
#   hubot request help - show help
#
# Configuration:
#   None
#
# Dependencies:
#   superagent: 0.9.8
#   commander: 1.0.5
#   shellwords: 0.1.0
#   qs: 0.5.1
#
# Examples:
#   None
#
# Author:
#   ecarter

request = require 'superagent'
program = require 'commander'
shellwords = require 'shellwords'
qs = require 'qs'

msg = {}

program
  .usage('<verb> <url> [options]')
  .option('-u, --url <url>', "Request URL")
  .option('-m, --method <verb>', "CREATE | DELETE | GET | POST | PUT")
  .option('-a, --auth <user:pass>', "Authentication user:pass")
  .option('-s, --header <field>', "Set header fields")
  .option('-h, --no-header', "Hide response header")
  .option('-q, --query <string>', "Query string")
  .option('-p, --send <fields>', "POST / PUT fields")

program._name = '(request|req)'

help = () ->
  out = []
  out.push "  Examples:"
  out.push ""
  out.push "    # GET"
  out.push "    hubot request get http://localhost:3000"
  out.push "    request get http://localhost:3000?format=json"
  out.push "    hubot req get http://localhost:3000 --query '{ \"format\": \"json\" }'"
  out.push ""
  out.push "    # POST"
  out.push "    hubot request post http://localhost:3000 --header 'API-Key: ...' --send one=1&two=2&three=3"
  out.push "    hubot req post http://localhost:3000?format=json -p test=hooray"
  out.push ""
  out.push "    # PUT"
  out.push "    hubot request put http://localhost:3000/users/1.json -p name=User+Name"
  out.push "    hubot req put http://localhost:3000/profile.json -p '{ \"name\": \"...\", \"email\": \"...\" }'"
  out.push ""
  out.push "    # DELETE"
  out.push "    hubot delete http://localhost:3000/models/1.json"
  out.push ""
  return out.join("\n")

isJson = (str) ->
  try
    JSON.parse str
  catch e
    return false
  return true


parse = (msg, verb, opts) ->

  args = shellwords.split opts
  program.parse ["node", "request"].concat(args)
  url = program.url or program.args[0]

  if not url
    return msg.send "Sorry, couldn't parse URL"

  if program.method
    verb = program.method

  switch verb
    when 'update'
      verb = 'put'

  req = request verb, url

  if program.auth
    auth = program.auth.split /:s/
    req.auth auth[0], auth[1]

  if typeof program.header is 'string'
    head = program.header.split /:\s/
    req.set head[0], head[1]

  if program.query
    if isJson(program.query)
      query = JSON.parse(program.query)
      req.type 'json'
      for own key, value of query
        q = {}
        q[key] = value
        req.query q
    else
      q = qs.parse program.query
      req.type 'form'
      req.query q

  if program.send
    if isJson(program.send)
      send = JSON.parse(program.send)
      req.type 'json'
      for own key, value of send
        p = {}
        p[key] = value
        req.send p
    else
      req.type 'form'
      req.send program.send

  delete program.auth
  delete program.query
  delete program.send

  req.end output


output = (res) ->
  out = []

  if res.clientError
    msg.send "[#{res.status}] Client Error"

  if res.serverError
    msg.send "[#{res.status}] Server Error"

  if res.error
    msg.send "[#{res.status}] Error"

  if res.type is 'application/json'
    body = JSON.stringify JSON.parse(res.text), null, 2
  else
    body = res.text

  if program.header isnt false
    out.push "url: #{res.url}"
    out.push "method: #{res.req.method}"
    out.push "status: #{res.status}"
    for own head, value of res.headers
      out.push "#{head}: #{value}"
    out.push ""
    out.push "---"
    out.push ""

  out.push body

  msg.send out.join("\n")


module.exports = (robot) ->

  robot.respond /(request|req) (create|delete|get|post|put|update) (.*)/i, (response) ->
    msg = response
    parse msg, msg.match[2], msg.match[3]

  robot.respond /(request|req) (help|-h|--help)/i, (msg) ->
    msg.send "#{program.helpInformation()}#{help()}"
