$(document).ready(function(){
  /* Constants */
  var TOOPHER_TIMEOUT = 90; // seconds

  /* Utility methods */
  var startLoadingAnimation = function(headerMessage, bodyMessage) {
    if ($(".blockUI").length == 0) {
      headerMessage = headerMessage || "Loading";
      bodyMessage = bodyMessage || "Please check your mobile device.";
      $.blockUI({ message: 
        '<h3>' + headerMessage + ' <img src="/assets/loading.gif" /></h3> \
        <hr/><p>' + bodyMessage + '</p>' });
    }
  }

  /* Authenticating */
  $("#sign_in").submit(function(e) {
    e.preventDefault();
    pollAuthenticating(Date.now(), TOOPHER_TIMEOUT);
  })

  var startAuthenticating = function() {
    startLoadingAnimation('Authenticating with Toopher');
  }

  var stopAuthenticating = function() {
    $.unblockUI()
    window.location.href = '/';
  }

  var pollAuthenticating = function(start_time, timeout_in_seconds) {
    var elapsed_time = Date.now() - start_time;
    if (elapsed_time > timeout_in_seconds*1000) {
      stopAuthenticating();
    }

    $.post('/sessions',
      $('#sign_in').serialize(),
      function(data) {
        if (data.redirect) {
          window.location.href = data.redirect;
        } else if (data.exception == "no_terminal") {
          var terminalName = window.prompt("Please enter a meaningful name for the computer you are using.");
          if (!terminalName) {
            stopAuthenticating();
          }
          startAuthenticating();
          $('#sign_in').append('<input type="hidden" name="terminal_name" value="' + terminalName + '" />');
          $.post('/toopher_terminals',
            $('#sign_in').serialize(),
            function(data) {
              setTimeout(function(){ pollAuthenticating(start_time, timeout_in_seconds); }, 2000);
            }).error(function() {
              stopAuthenticating();
            }
          );
        } else {
          startAuthenticating();
          setTimeout(function(){ pollAuthenticating(start_time, timeout_in_seconds); }, 2000);
        }
      }).error(function() {
        stopAuthenticating();
      }
    );
  }

  /* Pairing */
  $('#unpair').submit(function(e) {
    var proceed = window.confirm("Do you want to remove Toopher from your account? You can reenable Toopher later.");
    if (!proceed) {
      e.preventDefault();
    }
  });

  $('#pair').submit(function(e){
    e.preventDefault();
    pollPairing(Date.now(), TOOPHER_TIMEOUT);
  });
  
  var startPairing = function() {
    startLoadingAnimation('Pairing with Toopher');
  }

  var stopPairing = function() {
    $.unblockUI()
    window.location.href = '/';
  }

  var pollPairing = function(start_time, timeout_in_seconds) {
    var elapsed_time = Date.now() - start_time;
    if (elapsed_time > timeout_in_seconds*1000) {
      stopPairing();
    }

    $.post('toopher_create_pairing',
      $('#pair').serialize(),
      function(data) {
        if (data.redirect) {
          window.location.href = data.redirect;
        } else {
          startPairing();
          setTimeout(function(){ pollPairing(start_time, timeout_in_seconds); }, 2000);
        }
      }).error(function() {
        stopPairing();
      }
    );
  }
});