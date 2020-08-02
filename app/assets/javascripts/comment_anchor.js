$(function () {
  var res = ""
  $(".card-body p").map(function () {
    res = $(this).text().match(/>+\d{1,3}/)
    if (res) {
      var new_text = $(this).text().replace(/(>+)(\d{1,3})/g, '<a href="#$2">$1$2</a><br>');
    }
    $(this).html(new_text);
  });
});