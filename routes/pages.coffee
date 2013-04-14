exports.index = (request, responce) ->
  responce.render 'index', title: 'Растения из питомника «Садовые самоцветы»'

exports.faq = (request, responce) ->
  responce.render 'faq', title: 'Частые вопросы'

exports.articles = (request, responce) ->
  responce.render 'articles', title: 'Статьи'

exports.about = (request, responce) ->
  responce.render 'about', title: 'О питомнике'

exports.admin = (request, responce) ->
  responce.render 'admin', title: 'Админка'