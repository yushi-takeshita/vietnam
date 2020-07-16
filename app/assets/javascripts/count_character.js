$(function () {
  $("#post_content").on("keyup", function () {
    let countNum = String($(this).val().length);
    $("#counter").text(countNum + "/600");
  });
});