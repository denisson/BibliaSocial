(function($) {
    $.ajaxSetup({
        // cache: true,
        beforeSend: function(xhr) {
            xhr.setRequestHeader('Accept', 'text/javascript' )
        }
    });
    
    var active = null;
    
    $.fn.ajaxLinks = function() {
        return $(this).unbind('click').click(function(e) {
            if (e.which == 1) {
                $('#loading').show();
                $.getScript($(this).attr("href"));
                return false;
            }
            return true
        });
    };
    
    $.fn.defaultValue = function() {
        $(this).addClass('description').each(function() {
            var defaultValue = $(this).attr('value');
            $(this).focus(function() {
                $(this).removeClass('description');
                if ($(this).attr('value') == defaultValue) {
                    $(this).attr('value', '');
                }
            });
            $(this).blur(function() {
                if ($(this).attr('value') == '') {
                    $(this).addClass('description').attr('value', defaultValue);
                }
            });
        });
    };
            
    $.fn.showSidebar = function() {
        $('#sidebar_window').css('top', $(this).offset().top - 65).css('border-width', '1px 1px 1px 0').animate({width: 380}, 250).find('.text').html("<b>Comentários:</b> " + $(this).data('nome'));
        $('#facebook').html('<fb:comments href="' + $(this).data('url') + '" num_posts="10" width="360"></fb:comments>');
        if ($(this)[0].tagName == 'P') {
            var text = $(this).find('.text').text();
            if (text.length > 120) text = text.substring(0, 117) + '...';
            $('#buttons').html('<iframe allowtransparency="true" frameborder="0" scrolling="no" src="http://platform.twitter.com/widgets/tweet_button.html?url=' + $(this).data('url') + '&text=' + text + '" style="width:100px; height:20px;"></iframe> <fb:like href="' + $(this).data('url') + '" send="false" width="100" height="20" show_faces="false" layout="button_count" font="arial" style="vertical-align: top"></fb:like>');
            FB.XFBML.parse(document.getElementById('buttons'));
        } else {
            $('#buttons').html('');
        }
        FB.XFBML.parse(document.getElementById('facebook'));
    };
    
    $.hideSidebar = function(callback) {
        var sidebar = $('#sidebar_window, #sidebar_window2');
        if (!sidebar.is(':animated')) {
            sidebar.animate({width: 0}, 250, function() { 
                $(sidebar).css('border-width', '0');
                if (callback) callback();
            });
        }
        active = null;
    };
    
    $.fn.processReady = function() {
        $(this).find("a.ajax, .ajax a").ajaxLinks();
        
        $(this).find('.versiculo, .titulo').click(function() {
            var versiculo = this;
            if (active == null || active != this) {
                $.hideSidebar(function() {
                    $(versiculo).showSidebar();
                    active = versiculo;
                });
            }
        });
          
        /*$(this).find('.comment_count').each(function() {
            var count = this;
            var url = $(this).parents('.versiculo, .titulo').data('url').replace(/www\./, '');
            $.getJSON('http://graph.facebook.com/?ids=' + url + '&callback=?', function(json) {
                var comments = json[url]["comments"];
                $(count).text(comments ? comments : 0);
            });
        });
		*/
        
        return $(this);
    };
    
    $(document).ready(function() {
        
        //$('html').processReady();
        
        $('#search input').hover(function() { 
            $('#search input').addClass('hover');
        }, function() { 
            $('#search input').removeClass('hover');
        });
        $('#search input').focus(function() {
            $('#search input').addClass('focus');
        });
        $('#search input').blur(function() {
            $('#search input').removeClass('focus');
        });
        $('#search input[type=text]').defaultValue();
        
        $('#sidebar_window .title span, #sidebar_window2 .title span').click(function() { 
                $.hideSidebar();
        });


       $('a[title]').tipsy({fade: false, gravity: 'n'});
       $('textarea').autosize();

        $('ul.atividadesFiltros li a')
            /*
            .live("ajax:before", function(evt, xhr, settings){
                $(this).addClass("loading");
                $('.atividades').addClass("apagado");
            })
            .live('ajax:complete', function(evt, xhr, status){
                $(this).removeClass("loading");
                $('.atividades').removeClass("apagado");
            })
            */
            .live("click", function(event){
                event.preventDefault();
                $('ul.atividadesFiltros li').removeClass("selected");
                $(this).parent().addClass("selected");
                //todo:refatorar
                $('.atividades li').hide().removeClass("first");
                $('.atividades li.'+ $(this).attr("data-filtro")).show().first().addClass("first");
            });

        $('p.versiculo a[data-remote]')
            .live("click", function(){
                $('.versiculo').removeClass("selected");

            })
            .live("ajax:before", function(evt, xhr, settings){
                $(this).parents('.versiculo').addClass("loading");
            })
            .live('ajax:complete', function(evt, xhr, status){
                var versiculo = $(this).parents('.versiculo');
                versiculo.addClass("selected");
                $('#sidebar').html(xhr.responseText);
                $('#sidebar').css('top',versiculo.offset().top - 115) ;
                versiculo.removeClass("loading");
                $('#sidebar').show();
            });
        $('a.botaoExcluirItem')
            .live("ajax:before", function(evt, xhr, settings){
                $(this).parents('li').addClass("apagado");
            })
            .live("ajax:success", function(evt, data, status, xhr){
                var item = $(this).parents("li");
                item.effect("slide", { direction: "up", mode:"hide" }, 300, function(){$(this).remove()});
                var id_item = item.attr('id');
                $('.atividades li[data-item-dependencia='+ id_item +']').remove();
                $('.atividades li').not(':hidden').not(item).first().addClass("first");
            })
            .live("ajax:error", function(evt, xhr, status, error){
                $(this).parents('li').removeClass("apagado");
                window.alert("Não foi possível excluir este item!");
            });

    });
})(jQuery);