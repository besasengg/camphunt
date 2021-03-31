// Trip object
function Trip(name, description, user_id, id, start_date, end_date) {
  this.name = name;
  this.description = description;
  this.user_id = user_id;
  this.id = id;
  this.start_date = start_date;
  this.end_date = end_date;
}

// Trip object function to filter trips within 30 days
Trip.prototype.upcoming = function() {
  var todayDate = new Date();
  var monthDate = new Date();
  var oneMonthFromToday = new Date(monthDate.setMonth(todayDate.getMonth() + 1));
  var startDate = new Date(this.start_date);

  if (startDate >= todayDate && startDate <= oneMonthFromToday) {
    return true;
  } else {
    return false;
  }
};

// Date parse function
var dateParse = function(date) {
  date_str = date;
  date_arr = date_str.split("-");
  date_str = date_arr[1] + "-" + date_arr[2] + "-" + date_arr[0];
  return date_str;
};


$(function() {
// Function to retrieve more description info on Trips index page.
  $(".js-more").on("click", function() {
    var tripId = $(this).data("trip");
    var userId = $(this).data("user");
    $.get("/users/" + userId + "/trips/" + tripId + ".json", function(response) {
      var moreTripInfo = new Trip(
        response.trip.name,
        response.trip.description
      );
      var descriptionText = "<p>" + moreTripInfo.description + "</p>";
      $("#trip-" + tripId).html(descriptionText);
    });
  });

// Function to retrieve index of Trips filtered with Trip.prototype.upcoming function
  $(".upcoming-trips").on("click", function() {
    $(".table-striped").html(
      "<tr>" +
      "<th>Trip Name</th>" +
      "<th>Start Date</th>" +
      "<th> End Date</th>" +
      "</tr>");
    var userId = $(this).data("user");
    $.get("/users/" + userId + "/trips/upcoming.json", function(response) {
      $.each(response, function() {
        $.each(this, function(key, trip) {
          var tripData = new Trip(
            trip.name,
            trip.description,
            trip.user_id,
            trip.id,
            trip.start_date,
            trip.end_date
          );
          //if (tripData.upcoming() === true) {
            $(".table").append("<tr>" +
                              "<td>" + tripData.name + "</td>" +
                              "<td>" + dateParse(tripData.start_date) + "</td>" +
                              "<td>" + dateParse(tripData.end_date) + "</td>" +
                              "</tr>"
            );
          //}
        });
      });

    });
  });

// Function to submit supplies via AJAX
  $(".edit_trip").on("submit", function(event) {
    url = this.action;
    data = $(this).serialize();
    $.ajax({
      type: "PATCH",
      url: url,
      data: data,
      success: function(response) {
        var respArr = response.split("\n");
        var supplyName = respArr[0];
        var supplyQuantity = respArr[1];
        var tripSupplyId = respArr[2];
        var authToken = $('input:hidden[name=authenticity_token]').val();
        $(".table").append(
          '<tr>' +
            '<td>' + supplyName + " " + supplyQuantity + " " +
              '<div style="display:inline-block;">' +
                '<form class="button_to" method="post" action="/trip_supplies/' + tripSupplyId + '/increase"><input type="hidden" name="_method" value="put"><input type="submit" value="+1"><input type="hidden" name="authenticity_token" value="' + authToken + '"></form>' +
              '</div>' + " " +
              '<div style="display:inline-block;">' +
                '<form class="button_to" method="post" action="/trip_supplies/' + tripSupplyId + '/increase"><input type="hidden" name="_method" value="put"><input type="submit" value="-1"><input type="hidden" name="authenticity_token" value="' + authToken + '"></form>' +
              '</div>' +
          '</td>' +
          '</tr>'
        );
        $('input#trip_supplies_attributes_0_name').val("");
      }
    });
    event.preventDefault();
  });

// Function to load next trip show preview via AJAX
    $(".js-next").on("click", function() {
    var nextTripId = parseInt($('.js-next').data("trip")) + 1;
    var userId = $('.js-next').data("user");
    $.get("/users/" + userId + "/trips/" + nextTripId + ".json", function(response) {
      var nextTrip = new Trip(
        response.trip.name,
        response.trip.description,
        response.trip.user_id,
        response.trip.id
      );
      $(".titleName").text(nextTrip.name);
      $(".tripDescription").text(nextTrip.description);
      $(".tripLink").html('<a href="/users/' + nextTrip.user_id + '/trips/' + nextTrip.id + '"' + '>Go to Trip</a>');
      $(".js-next").attr("data-trip", nextTrip.id);
      $(".js-next").attr("data-user", nextTrip.user_id);
    });
  });
});
