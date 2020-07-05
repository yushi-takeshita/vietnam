$(function () {
  function buildChildHTML(child) {
    var html = `<option value="${child.id}">${child.name}</option>`;
    return html;
  }

  $("#parent").on("change", function () {
    var id = document.getElementById("parent").value;
    if (id == 0) {
      $("#child").remove();
    } else {
      $.ajax({
        type: 'GET',
        url: '/categories/pulldown',
        dataType: 'json',
        data: { parent_id: id, locale: $('.current_locale').val() }
      }).done(function (children) {
        if (children.length) {
          var select_html = `<select name="post[category_id]" id="child" class="custom-select custom-select-lg">
      <option value=0>---</option>`;
          $.each(children, function (i, child) {
            select_html += buildChildHTML(child);
          });
          select_html += `</select>`;
        }
        if ($("#child").length) {
          $("#child").replaceWith(select_html);
        } else {
          $(".children_pulldown").append(select_html);
        }
      });
    };
  });
});