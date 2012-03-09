$(document).ready(function() {
    FB.init({
        appId  : '187353061340087',
        status : true, // check login status
        cookie : true, // enable cookies to allow the server to access the session
        xfbml  : true  // parse XFBML
    });

    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        // the user is logged in and has authenticated your
        // app, and response.authResponse supplies
        // the user's ID, a valid access token, a signed
        // request, and the time the access token
        // and signed request each expire
        var uid = response.authResponse.userID;
        var accessToken = response.authResponse.accessToken;
        console.log(response);
        $.colorbox({html:'<div class="conectandoFacebook"><span>Conectando ao Facebook ...</span><i></i></div>'});
        window.location = '/users/auth/facebook';

      /* deixei aqui só para ter a referência
      } else if (response.status === 'not_authorized') {
      */
      } else {

      }
     });
});