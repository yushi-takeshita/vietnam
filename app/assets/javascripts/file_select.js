$(document).ready(function () {
  $("#post_image, #user_image").on("change", function () {
    var file = this.files[0];
    if (file != null) {
      document.getElementById("dummy_file").value = file.name;
    }
  });
});
