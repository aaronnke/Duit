$(document).on('turbolinks:load', function() {

  $(".comparison-button").click(function () {
    $(".comparison-box").show();
    $(".transaction-box").hide();
    $(".summary-box").hide();
  })

  $(".transaction-button").click(function () {
    $(".transaction-box").show();
    $(".comparison-box").hide();
    $(".summary-box").hide();
  })

  $(".summary-button").click(function () {
    $(".summary-box").show();
    $(".transaction-box").hide();
    $(".comparison-box").hide();
  })

});
