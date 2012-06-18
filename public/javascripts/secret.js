(function($) {


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

    $.fn.indiceBiblia = function(livro_selecionado_id, num_capitulo_selecionado, options){
        var defaults = {flutuante:false, ativador:null}
        options = $.extend({}, defaults, options);
        var escolhaLivroCapitulo =  null;
        var escolhaLivro =  null;
        var escolhaVersiculo =  null;
        var elementoLivroSelecionado = null;
        var numero_capitulo_selecionado = num_capitulo_selecionado;

        $(this).html("");
        escolhaLivroCapitulo =  $(this).addClass("escolhaLivroCapitulo");

        var titulos = $('<div>').append($('<h4 class="tituloEscolha livroEscolha">Livro</h4>')).append($('<h4 class="tituloEscolha capituloEscolha">Capítulo</h4>'));
        titulos.appendTo(escolhaLivroCapitulo);
        escolhaLivro = $('<ul class="escolhaLivro scroll"></ul>').appendTo(escolhaLivroCapitulo);
        escolhaVersiculo = $('<ul class="escolhaVersiculo scroll"></ul>').appendTo(escolhaLivroCapitulo);
        for (livro_id in livros_capitulos){
            livro = livros_capitulos[livro_id];
            if (livro != undefined){
                li = $('<li><a href="'+livro.url+'" data-livro-id="'+livro_id+'"> '+livro.nome+' </a></li>');
                escolhaLivro.append(li);
                if (livro_id == livro_selecionado_id){
                    elementoLivroSelecionado = li;
                }
            }
        }


        escolhaLivro.find('a').click(function(event){
            event.preventDefault();
            event.stopPropagation();
            var livro_id = $(this).attr("data-livro-id");
            escolhaLivro.find('li').removeClass("selected");
            $(this).parent("li").addClass("selected");
            var livro = livros_capitulos[livro_id];
            escolhaVersiculo.html("");
            for (var i=1; i <= livro.capitulos_count; i++){
                var class_selected = (numero_capitulo_selecionado == i )? 'selected':'';
                var li_link = $('<li class="'+class_selected+'"> <a href="/'+livro.permalink+'/'+i+'" class="">'+i+'</a></li>');
                li_link.find('a').click(function(){
                    escolhaVersiculo.find("li").removeClass("selected");
                    $(this).parent('li').addClass("selected");
                });

                escolhaVersiculo.append(li_link);
            }
            escolhaVersiculo.hide().fadeIn();
            numero_capitulo_selecionado = 0;

        });
//        $(".escolhaVersiculo a").livequery(function(){
//            $(this).live("click", function(event){
//                $(this).parent('li').addClass("selected");
//            });
//        });

        if (options.flutuante && options.ativador != null){
            options.ativador.click(function(event){
                event.preventDefault();
                event.stopPropagation();
                escolhaLivroCapitulo.toggle();
                escolhaLivro.scrollTo(elementoLivroSelecionado,{over: -1});
                elementoLivroSelecionado.find("a").click();
            });
            $('html').click(function() {
                if (escolhaLivroCapitulo.is(":visible")) {
                    escolhaLivroCapitulo.hide();
                }
            });
        }
        escolhaLivroCapitulo.click(function() {
            event.stopPropagation();
        });

        if(!options.flutuante){
            escolhaLivro.scrollTo(elementoLivroSelecionado,{over: -1});
            elementoLivroSelecionado.find("a").click();
        }
    }


    $(document).ready(function() {

        //$('.reticencias').reticence({reduceMode: "char"});
        $('.reticencias').livequery(function(){
                    $(this).reticencias();
        });

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



        $('.atividadesFiltros  a[title], a.countLikeItem, .tooltip[title]').livequery(function(){
            $(this).tipsy({fade: false, gravity: 'n', opacity:1});
        });
        $('.botoesItens a[title], a.fecharSidebarFlutuante').livequery(function(){
            $(this).tipsy({fade: false, gravity: 's', opacity:1});
        });
        $('a.countLikeItem').livequery(function(){
            $(this).colorbox({opacity:0, initialWidth:360, initialHeight:100, fixed:true, close:'Fechar', maxHeight:'70%', scrolling:false});
        });

        $('a.linkVersiculo').live('click', function(event){
            var versiculo_id = $(this).attr('data-versiculo-id');
            var elemento_versiculo = $("#"+versiculo_id)
            if (elemento_versiculo.size() > 0){
                event.preventDefault();
                $.scrollTo(elemento_versiculo, {duration:250, over: -1,onAfter:function(){
                    elemento_versiculo.effect("highlight", {}, 2000);
                }});
            }
        });


        $('ul.botoesItens li a').live('click', function(event){
            event.preventDefault();
            $('.stringItemContainer').show();
            $('ul.botoesItens li').removeClass("selected");
            $(this).parent('li').addClass("selected");
            $('#stringItem').attr('placeholder', $(this).attr('data-placeholder'));
            $('#stringItem').attr('value', '');
            $('#stringItem').focus();
            $('#itemType').attr('value', $(this).attr('data-item-type'));
        });
        $('.fecharStringItem').live('click', function(event){
            event.preventDefault();
            $('.stringItemContainer').hide();
            $('ul.botoesItens a').removeClass("selected");
            $('#stringItem').attr('value', '');
        });
        $('.atividadesForm textarea').livequery(function(){
            $(this).autosize();
        });

        $('.uiVideoThumb').live('click', function(event){
            event.preventDefault();
            var iframe_video = $('<iframe>')
                .attr('width', 318)
                .attr('height', 239)
                .hide()
                .attr('src', $(this).attr('data-url'));
            videoContainer = $(this).parents('.atividadeVideoContainer');
            videoContainer.addClass('uiVideoThumbLoading');
            videoContainer.append(iframe_video);
            iframe_video.load(function(){
                videoContainer.removeClass("uiVideoThumbLoading");
                videoContainer.find(':not(iframe)').remove();
                $(this).show();
            });
        });
        $('#messageContainer a').click(function(event){
            event.preventDefault();
            $('#messageContainer').hide();
        });

		if($('body').hasClass("fullscreen")){		
			$('#botaoFullscreen').attr('title', 'Sair do modo Tela Cheia');
		}

        $('#botaoFullscreen').click(function(event){
            event.preventDefault();
            $('body').toggleClass("fullscreen");
			if($('body').hasClass("fullscreen")){
				$.cookie('fullscreen', true , {path: '/'});
				$(this).attr('title', 'Sair do modo Tela Cheia');
				restaurarSidebar();
			}else{
				$.cookie('fullscreen', false, {path: '/'});
				$(this).attr('title', 'Tela Cheia');
			}
        });
		
        $('#aumentarTamanhoFonte').click(function(event){
            event.preventDefault();
			$('#content article').css('fontSize', parseInt($('#content article').css('fontSize').replace('px', '')) + 2)
        });
		
		$('#diminuirTamanhoFonte').click(function(event){
            event.preventDefault();
			$('#content article').css('fontSize', parseInt($('#content article').css('fontSize').replace('px', '')) - 2)
        });

        $('a.precisaDeLogin').live("ajax:before", function(evt, xhr, settings){
            if (!USUARIO_ESTA_LOGADO){
                window.location = URL_LOGIN;
                return false;
            }
        })

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
                $('.atividades.filtravel li').hide().removeClass("first");
                $('.atividades.filtravel li.'+ $(this).attr("data-filtro")).show().first().addClass("first");
                $('.atividades.filtravel li.'+ $(this).attr("data-filtro")).show().first().addClass("first");
            });

        $('p.versiculo a[data-remote]')
            .live("click", function(){
                var versiculo = $(this).parents('.versiculo');
                hideSidebarFlutuante();
                versiculo.addClass("selected");
				if($('body').hasClass('fullscreen')){
					$('#botaoFullscreen').click();
				}
            })
            .live("ajax:before", function(evt, xhr, settings){
                $(this).parents('.versiculo').addClass("loading");
            })
            .live('ajax:complete', function(evt, xhr, status){
                var versiculo = $(this).parents('.versiculo');
                $('#sidebar_flutuante').html(xhr.responseText);
                $('#sidebar_flutuante').css('top',versiculo.offset().top - 60) ;
                versiculo.removeClass("loading");
                showSidebarFlutuante();
            });
        $('a.botaoExcluirItem')
            .live("ajax:before", function(evt, xhr, settings){
                $(this).parents('li').addClass("apagado");
            })
            .live("ajax:success", function(evt, data, status, xhr){
                var item = $(this).parents("li");
                item.effect("slide", { direction: "up", mode:"hide" }, 300, function(){$(this).remove()});
                var id_item = item.attr('id');
                $('.atividades.filtravel li[data-item-dependencia='+ id_item +']').remove();
                var itens_restantes = $('.atividades.filtravel li').not(':hidden').not(item);
                itens_restantes.first().addClass("first");
                if (itens_restantes.size() == 0) $('.nenhumaPublicacao').show();
            })
            .live("ajax:error", function(evt, xhr, status, error){
                $(this).parents('li').removeClass("apagado");
                showMessage("Não foi possível excluir este item!");
            });

        $('a.botaoVoto')
            .live("ajax:before", function(evt, xhr, settings){
                var container = $(this).parents(".botoesVoto");
                container.addClass("apagado");
            })
            .live("ajax:success", function(evt, data, status, xhr){
                var container = $(this).parents(".botoesVoto");
                container.removeClass("apagado");
                container.html(xhr.responseText);
            })
            .live("ajax:error", function(evt, xhr, status, error){
                var container = $(this).parents(".botoesVoto");
                container.removeClass("apagado");
            });
        $('a.botaoVoto.desfazer')
            .live("ajax:error", function(evt, xhr, status, error){
                showMessage("Não foi possível desfazer. Tente novamente!");
            });
        $('a.botaoVoto.votar')
            .live("ajax:error", function(evt, xhr, status, error){
                showMessage("Não foi possível registrar sua opnião. Tente novamente!");
            });

        $('a.userSeguir')
            .live("ajax:before", function(evt, xhr, settings){
                var container = $(this).parents(".userBotoes");
                container.addClass("apagado");
            })
            .live("ajax:success", function(evt, data, status, xhr){
                var container = $(this).parents(".userBotoes");
                container.removeClass("apagado");
                container.html(xhr.responseText);
            })
            .live("ajax:error", function(evt, xhr, status, error){
                var container = $(this).parents(".userBotoes");
                container.removeClass("apagado");
                showMessage("Não foi possível executar esta operação. Tente novamente!");
            });

    });
})(jQuery);

function showMessage(message){
//    $('#messageContainer span').html(message);
//    $('#messageContainer').show();
    window.alert(message);
}

function showSidebarFlutuante(){
    $('#sidebar_flutuante').show();
    $('#sidebar_opaco').show().css('height', $('#window').height() + 1);
}

function hideSidebarFlutuante(){
    $('#sidebar_flutuante').hide();
    $('p.versiculo.selected').removeClass("selected");
}

function restaurarSidebar(){
    hideSidebarFlutuante();
    $('#sidebar_opaco').hide();
}