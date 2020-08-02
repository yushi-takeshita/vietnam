$(document).ready(function () {
  $(".reply").click(function () {
    var num = $(this).parents(".card-body").parent().attr("id");
    const position = $("#comment_body").offset().top;
    const speed = 200;
    $("html,body").animate({ scrollTop: position }, speed)
    $("#comment_body").focus().val(">>" + num + "\n");
  });
});
