$(document).ready () ->

    # Этот странный код определяет, какой пункт меню соответствует текущей странице, хы-хы
    currentMenuItem = _.find $(".nav li a"), (a) ->
      a.href.match new RegExp(window.location.pathname, "i")

    $(currentMenuItem).parent().addClass "active"
    currentMenuItem?.href = null

    # Тут обработка карты для фенсибокса
    $(".fancybox").fancybox()

    # # Преобразование телефона для Айфонов
    # $("#phone").click ->
    #   $("#phone").text $("#phone").text().replace(/[^+\d*]/ig, "")
    #   Не нужно оказывается, он сам преобразует всё
    

    # Для красоты семилинков
    $(".semilink").hover(
        ->
            if $(this).next().hasClass("semilink-next")
                $(this).next().addClass("semilink-next-hover")
            if $(this).prev().hasClass("semilink-next")
                $(this).prev().addClass("semilink-next-hover")
        ->
            if $(this).next().hasClass("semilink-next-hover")
                $(this).next().removeClass("semilink-next-hover")
            if $(this).prev().hasClass("semilink-next-hover")
                $(this).prev().removeClass("semilink-next-hover")
    )

    # Заплатка для многолетников
    $(".patch ").filter('.semilink').hover(
        ->
            $(".patch").filter('.semilink').addClass("semilink-hover")
            $(".patch").filter('.semilink-next').addClass("semilink-next-hover")

        ->
            $(".patch").filter('.semilink').removeClass("semilink-hover")
            $(".patch").filter('.semilink-next').removeClass("semilink-next-hover")
    )

    # Для красоты Шиндовсовских шрифтов
    # if navigator.platform.match /win/i
    #     $("html").addClass  "windowsSucks"
    #     $("body").addClass  "windowsSucks"
    #     $(".catalog").addClass  "windowsSucks"
        

