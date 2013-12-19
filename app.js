//@ sourceMappingURL=app.map
// Generated by CoffeeScript 1.6.1
(function() {
  var app, auth, express, http, mail, pages, path, plants, _;

  express = require('express');

  pages = require('./routes/pages');

  plants = require('./routes/plants');

  mail = require('./routes/mail');

  http = require('http');

  path = require('path');

  _ = require('underscore');

  app = express();

  app.configure(function() {
    app.set('port', process.env.PORT || 3000);
    app.set('views', "" + __dirname + "/views");
    app.set('view engine', 'jade');
    app.use(express.favicon("" + __dirname + "/public/img/favicon.png"));
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser('hollymolly'));
    app.use(express.session());
    app.use(express["static"]("" + __dirname + "/public"));
    return app.use(app.router);
  });

  app.configure('development', function() {
    return app.use(express.errorHandler());
  });

  app.get('/', pages.index);

  app.post('/mail', mail.send);

  app.get('/about', pages.about);

  app.get('/faq', pages.faq);

  app.get('/articles', pages.articles);

  auth = express.basicAuth('sadsam', '12345%54321');

  app.get('/admin', auth, pages.admin);

  app.get('/plants', plants.findAll);

  app.get('/plants/random', plants.random);

  app.get('/plants/prize/:prize', plants.findWithPrizeUpTo);

  app.get('/plants/height/:height', plants.findWithHightUpTo);

  app.get('/plants/type/:type', plants.filterByType);

  app.get('/plants/source/:source', plants.filterBySource);

  app.get('/plants/filters/:type/:prize/:height/:text', plants.searchAndFilter);

  app.get('/plants/filters/:type/:prize/:height', plants.filterByAll);

  app.get('/plants/search/:text', plants.search);

  app.get('/hello.txt', function(request, responce) {
    return responce.send('hi');
  });

  app.get('*', pages.index);

  app.listen(3000);

  console.log('Listening on port 3000');

}).call(this);
