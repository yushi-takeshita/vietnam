$(function () {
  function buildChildHTML(child) {
    var html = `<a class="child_category" id="${child.id}" href="/category/${child.id}">${child.name}</a>`;
    return html;
  }

  $("parent_category").on("mouseover", function () {
    var id = this.id
    $(".now-selected-red").removeClass("now-selected-red")
    $('#' + id).addClass("now-selected-red");
    $(".child_category").remove();
    $.ajax({
      type: 'GET',
      url: '/category/new',
      data: { parent_id: id },
      dataType: 'json'
    }).done(function (children) {
      children.forEach(function (child) {
        var html = buildChildHTML(child);
        $(".children_list").append(html);
      });
    });
  });
});