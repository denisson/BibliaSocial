$(document).ready(function() {
    if (!FB) return;

    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        // the user is logged in and has authenticated your
        // app, and response.authResponse supplies
        // the user's ID, a valid access token, a signed
        // request, and the time the access token
        // and signed request each expire
        var uid = response.authResponse.userID;
        var accessToken = response.authResponse.accessToken;
        $.colorbox({html:'<div class="conectandoFacebook"><a class="bs_fb_button" href="#"><span class="bs_fb_button_text">Conectando ao Facebook ...</span></a></div>'});
        window.location = '/users/auth/facebook';

      /* deixei aqui só para ter a referência
      } else if (response.status === 'not_authorized') {
      */
      }
     });
});