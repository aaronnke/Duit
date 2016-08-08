$(document).on('turbolinks:load', function() {

  $(".month-toggle-button").click(function () {
    $(".month-toggle-dropdown").toggle();
  })

  $(".dashboard-toggle-button").click(function () {
    $(".dashboard-toggle-dropdown").toggle();
  })

});
