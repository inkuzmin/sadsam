express = require 'express'

pages  = require './routes/pages'
plants = require './routes/plants'
mail   = require './routes/mail'

http = require 'http'
path = require 'path'

_ = require 'underscore'

app     = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'

  app.use express.favicon "#{__dirname}/public/img/favicon.png"
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser 'hollymolly'
  app.use express.session()

  app.use express.static "#{__dirname}/public"
  app.use app.router




app.configure 'development', ->
  app.use express.errorHandler()


# Static pages
app.get '/', pages.index

app.post '/mail', mail.send

app.get '/about', pages.about
app.get '/faq', pages.faq
app.get '/articles', pages.articles

auth = express.basicAuth('sadsam', '12345%54321');
app.get '/admin', auth, pages.admin


# REST API
app.get '/plants', plants.findAll

# app.get '/plants/:id', plants.getById

app.get '/plants/random', plants.random

app.get '/plants/prize/:prize', plants.findWithPrizeUpTo
app.get '/plants/height/:height', plants.findWithHightUpTo
app.get '/plants/type/:type', plants.filterByType
app.get '/plants/source/:source', plants.filterBySource

app.get '/plants/filters/:type/:prize/:height/:text', plants.searchAndFilter
app.get '/plants/filters/:type/:prize/:height', plants.filterByAll

app.get '/plants/search/:text', plants.search

# Just hi :)
app.get '/hello.txt', (request, responce) ->
  responce.send 'hi'


app.get '*', pages.index



app.listen 3000


console.log 'Listening on port 3000'