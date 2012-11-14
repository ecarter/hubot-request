# hubot-request

a [SuperAgent](https://github.com/visionmedia/superagent) backed HTTP
request [plugin](https://github.com/github/hubot-scripts) for
[hubot](https://github.com/github/hubot)

## Dependencies

* [superagent](http://visionmedia.github.com/superagent/)
* [commander.js](https://github.com/visionmedia/commander.js/)
* [shellwords](https://github.com/jimmycuadra/shellwords)
* [node-querystring](https://github.com/visionmedia/node-querystring)

## Commands

    hubot request get <url> [options] - send GET request
    hubot request post <url> [options] - send POST request
    hubot request create <url> [options] - send CREATE request
    hubot request (put|update) <url> [options] - send PUT request
    hubot request delete <url> [options] - send DELETE request
    hubot request help - show help

## Examples

  **GET**

    hubot request get http://localhost:3000
    request get http://localhost:3000?format=json
    hubot req get http://localhost:3000 --query '{ "format": "json" }'

  **POST**

    hubot request post http://localhost:3000 --header 'API-Key: ...' --send one=1&two=2&three=3
    hubot req post http://localhost:3000?format=json -p test=hooray

  **PUT**

    hubot request put http://localhost:3000/users/1.json -p name=User+Name
    hubot req put http://localhost:3000/profile.json -p '{ "name": "...", "email": "..." }'

  **DELETE**

    hubot delete http://localhost:3000/models/1.json

## Usage

    Usage: (request|req) <verb> <url> [options]

    Options:

      -h, --help              output usage information
      -u, --url <url>         Request URL
      -m, --method <verb>     CREATE | DELETE | GET | POST | PUT
      -a, --auth <user:pass>  Authentication user:pass
      -s, --header <field>    Set header fields
      -h, --no-header         Hide response header
      -q, --query <string>    Query string
      -p, --send <fields>     POST / PUT fields

## Configuration

    None

## Installation

1. Install dependencies `$ npm install`
2. Copy `request.coffee` to hubot's `hubot/scripts` directory.

## Testing

[hubot-request](https://github.com/ecarter/hubot-request) comes with simple 
[express.js](http://expressjs.com) app for testing incoming
requests.

**Running test server:**

    $ cd hubot-request
    $ node test

Open [localhost:3000](http://localhost:3000) in your browser to make
sure it's working.

**Start Hubot in another shell and try some commands:**

    $ bin/hubot --name Hubot
    $ Hubot> hubot request get http://localhost:3000

    $ Hubot>

    method: GET
    status: 200
    x-powered-by: Express
    content-type: text/plain
    content-length: 23
    date: Wed, 14 Nov 2012 06:46:29 GMT
    connection: keep-alive

    ---

    Query:

      hello: world

## License

MIT

