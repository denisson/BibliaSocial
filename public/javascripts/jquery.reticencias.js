/*!
 * jQuery-Reticence JavaScript Plugin v0.2.0
 * http://plugins.jquery.com/project/Reticence
 *
 * Copyright 2011, Marcelo Manzan
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 * http://en.wikipedia.org/wiki/MIT_License
 * http://en.wikipedia.org/wiki/GNU_General_Public_License
 *
 * Date: Thu Jul 28 11:46:10 2011 -0300
 */
(function ($) {
    function applyReticence(elem, options) {
        var $el = $(elem);
        var alturaLinha, alturaTotal, alturaMaxima, alturaMaximaMaisUmaLinha;
        var conteudo = $el.html();

        $el.css('overflow', 'hidden');
        alturaTotal = $el.height();
        alturaLinha = $el.html('_').height();
        alturaMaxima = alturaLinha * options.numLinhas;
        alturaMaximaMaisUmaLinha = alturaMaxima + alturaLinha;
        $el.html(conteudo);
        if (alturaTotal <= alturaMaximaMaisUmaLinha){
            $el.css('max-height', alturaMaximaMaisUmaLinha);
        }else{
            $el.css('max-height', alturaMaxima);
            var linkVerMais = $('<a></a>');
            linkVerMais.html(options.textoReticencias).attr('href', '#');
            linkVerMais.click(function(event){
                event.preventDefault();
                var divTextoReticencias = $(this).parent();
                divTextoReticencias.prev().css('max-height', '');
                divTextoReticencias.remove();
            });
            $('<div></div>').append(linkVerMais).insertAfter($el);
        }

    }
    $.fn.reticencias = function (options) {
        var defaults = {numLinhas:4, textoReticencias:'ver mais ...'};
        options = $.extend({}, defaults, options);
        return this.each(function () {
          applyReticence(this, options);
        });
    };
})(jQuery);
