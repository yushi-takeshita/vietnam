$(function () {
  function buildChildHTML(child) {
    var html = `<a class="child_category list-group-item" id="${child.id}" href="category/${child.id}">${child.name}</a>`;
    return html;
  }

  $(".parent_category").mouseover(function () {
    var id = this.id;
    $(".now-selected-gray").removeClass("now-selected-gray")
    $('#' + id).addClass("now-selected-gray")
    $(".child_category").remove();
    $.ajax({
      type: 'GET',
      url: '/category/new',
      dataType: 'json',
      data: { parent_id: id, locale: $('.current_locale').val() }
    }).done(function (children) {
      children.forEach(function (child) {
        var html = buildChildHTML(child);
        $(".children_list").append(html);
      });
    });
  });

  $(document).on("mouseover", ".child_category", function () {
    var id = this.id;
    $(".now-selected-lavender").removeClass("now-selected-lavender");
    $('#' + id).addClass("now-selected-lavender");
  }).on("mouseleave", ".category_list", function () {
    $(".child_category").remove();
  });
});