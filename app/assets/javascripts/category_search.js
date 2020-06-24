$(function () {
  function buildChildHTML(child) {
    var html = `<a class="child_category" id="${child.id}" href="/category/${child.id}">${child.name}</a>`;
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
      data: { parent_id: id }
    }).done(function (children) {
      children.forEach(function (child) {
        var html = buildChildHTML(child);
        $(".children_list").append(html);
      });
    });
  });

  $(document).on("mouseover", ".child_category", function () {
    var id = this.id;
    $(".now-selected-green").removeClass("now-selected-green");
    $('#' + id).addClass("now-selected-green");
  });
});