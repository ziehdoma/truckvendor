

/* Call a customer from a support ticket */
function callCustomer(phone) {
  updateCallStatus("Calling " + phone);

  var params = {"phone": phone};
  Twilio.Device.connect(params);
}

/* Call the support_agent from the home page */
function callSupport() {
  updateCallStatus("Calling support...");

  // Our backend will assume that no params means a call to support_agent
  Twilio.Device.connect();
}

$(document).ready(function() {
  $.post("/token/generate", {page: window.location.pathname}, function(data) {
    // Set up the Twilio Client Device with the token
    Twilio.Device.setup(data.token);
  });
});

/* Callback to let us know Twilio Client is ready */
Twilio.Device.ready(function (device) {
  updateCallStatus("Ready");
});

function callCustomer(phone) {
  updateCallStatus("Calling " + phone + "...");

  var params = {"phone": phone};
  Twilio.Device.connect(params);
}

/* Callback for when Twilio Client initiates a new connection */
Twilio.Device.connect(function (connection) {
  // Enable the hang up button and disable the call buttons
  hangUpButton.prop("disabled", false);
  callCustomerButtons.prop("disabled", true);
  callSupportButton.prop("disabled", true);
  answerButton.prop("disabled", true);

  // If phoneNumber is part of the connection, this is a call from a
  // support agent to a customer's phone
  if ("phone" in connection.message) {
    updateCallStatus("In call with " + connection.message.phoneNumber);
  } else {
    // This is a call from a website user to a support agent
    updateCallStatus("In call with support");
  }
});

function callSupport() {
  updateCallStatus("Calling support...");

  // Our backend will assume that no params means a call to support_agent
  Twilio.Device.connect();
}

Twilio.Device.incoming(function(connection) {
  updateCallStatus("Incoming support call");

  // Set a callback to be executed when the connection is accepted
  connection.accept(function() {
    updateCallStatus("In call with customer");
  });

  // Set a callback on the answer button and enable it
  answerButton.click(function() {
    connection.accept();
  });
  answerButton.prop("disabled", false);
});


function hangUp() {
  Twilio.Device.disconnectAll();
}
