$(function () {
  function buildChildHTML(child) {
    var html = `<a class="child_category" id="${child.id}" href="/category/${child.id}">${child.name}</a>`;
    return html;
  }

  $(".parent_category").mouseover(function () {
    var id = this.id;
    $(".now-selected").removeClass("now-selected")
    $('#' + id).addClass("now-selected")
    $(".child_category").remove();
    $.ajax({
      type: 'GET',
      url: '/category/new',
      dataType: 'json',
      data: { parent_id: id },
    }).done(function (children) {
      children.forEach(function (child) {
        var html = buildChildHTML(child);
        $(".children_list").append(html);
      });
    });
  });
});