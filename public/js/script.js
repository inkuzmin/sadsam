// Generated by CoffeeScript 1.6.1
(function() {

  $(document).ready(function() {
    var currentMenuItem;
    currentMenuItem = _.find($(".nav li a"), function(a) {
      return a.href.match(new RegExp(window.location.pathname, "i"));
    });
    $(currentMenuItem).parent().addClass("active");
    if (currentMenuItem != null) {
      currentMenuItem.href = null;
    }
    $(".fancybox").fancybox();
    $(".semilink").hover(function() {
      if ($(this).next().hasClass("semilink-next")) {
        $(this).next().addClass("semilink-next-hover");
      }
      if ($(this).prev().hasClass("semilink-next")) {
        return $(this).prev().addClass("semilink-next-hover");
      }
    }, function() {
      if ($(this).next().hasClass("semilink-next-hover")) {
        $(this).next().removeClass("semilink-next-hover");
      }
      if ($(this).prev().hasClass("semilink-next-hover")) {
        return $(this).prev().removeClass("semilink-next-hover");
      }
    });
    return $(".patch ").filter('.semilink').hover(function() {
      $(".patch").filter('.semilink').addClass("semilink-hover");
      return $(".patch").filter('.semilink-next').addClass("semilink-next-hover");
    }, function() {
      $(".patch").filter('.semilink').removeClass("semilink-hover");
      return $(".patch").filter('.semilink-next').removeClass("semilink-next-hover");
    });
  });

}).call(this);