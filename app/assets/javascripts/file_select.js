
$(document).ready(function () {
  $("#post_image").on("change", function () {
    var file = this.files[0];
    if (file != null) {
      document.getElementById("dummy_file").value = file.name;
    }
  });
  if (document.form1.filename.value == "") {
    document.getElementById("dummy_file").value = "";
  }
});