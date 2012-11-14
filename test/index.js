var express = require('express');

var app = express();

app.use(express.methodOverride());
app.use(express.bodyParser());

app.all('*', function(req, res, next){

  var json = {}
    , body = []
    , query = []
    , out = [];

  switch (req.method) {
    case 'POST':
    case 'PUT':
      for (var k in req.body) {
        var v = req.body[k];
        body.push("  " + k + ": " + v);
      }
      break;
    default:
      for (var k in req.query) {
        var v = req.query[k];
        query.push("  " + k + ": " + v);
      }
      break;
  }

  // ?format=json
  if ( 'json' === (req.body.format || req.query.format) ) {
    if ( body.length > 0 ) json.body = req.body;
    if ( query.length > 0 ) json.query = req.query;
    return res.send(json);
  }

  // plain text
  res.set('Content-Type', 'text/plain');

  if ( query.length > 0 ) {
    out.push('Query:');
    out.push('');
    out = out.concat(query);
    out.push('');
  }
  if ( body.length > 0 ) {
    out.push('Body:');
    out.push('');
    out = out.concat(body);
    out.push('');
  }

  res.send( out.join('\n') );

  console.log(req.method + ': ' + req.url);
});

app.get('/error', function(req, res){
  res.send(500, { error: true, message: 'error!!!' });
});

app.listen(3000);
console.log('test server started on port 3000');
