--Funcionalidades novas---
#Tratamento de Exceções (erros, deletou e não deu certo. mostrar erro para o usuário)
#Terminar o perfil do usuário
#Terminar o mural
#Adicionar funcionalidade de mudar de livro e capítulo
    #- Falta layout
    - Falta filtro do livro
    #- tentar resolver problema do scroll na parte de leitura, no sidebar
#*passo a passo para recém cadastrado no site - Fiz umas explicações no início. Não chega a ser um passo-a-passo, mas está bom
emails de resumo semanais e para notificações
 - Fazer unsubscribe
 - #Usar delayed_job para as notificações (https://github.com/collectiveidea/delayed_job)
 - #Acentuação no subject (resolvido com # enconding: utf-8)
 - #Criar link direto para a atividade (serve para a notificacao do voto)
 - Fazer email de convite para o BibliaSocial (Convidar Amigo)
#Terminar intregração com omniauth (Decidir se além do facebook vai colocar twitter e google) - Decidido somente facebook
#Como transicionar Comentários do 1.0 para essa nova versão - Resolvido
Adaptar para multi-versões
*Possibilitar criar comentários privados (e de grupos)
Colocar opção de denunciar conteúdo (irrelevante ou ofensivo)
*Criar atividade quando um usuário gostar ou não de alguma publicação. Mostrar no mural
Criar plano de leitura comnunitário (idéia do lucas para ajudar a gerar conteúdo)
Fazer busca por pessoas (usuários)
Fazer busca dentro dos comentários feitos pelos usuários
Mudar imagem do usuário que não tem imagem (colocar algum bonequinho legal)

--Problemas--
#Melhorar Busca
Otimizar performance. Criar índices. Fazer joins.
#Ordenação dos itens não está decrescente
#Colocar opção de fechar janela de comentários
#Resolver problema de acetuação na hora de ver quem deu os likes
#Layout
    #- corrigir problemas dos ícones no firefox (os dois com o mesmo font-size, mas, mesmo assim nada. Tem que pesquisar)
    #- limitar tamanho dos posts na hora de mostrar e colocar um link (ver mais)
    #- Resolver layout de Editar Perfil do Usuário
    #- Terminar layout da mensagem de erro!
    #- Terminar layout da página de cadastro e de Login
    #  -Ver porque não está aparecendo mensagem quando usuário e senha estão errados.
    #- Colocar botão do Facebook no lugar onde fica a palavra facebook
    #- Clarear input de busca quando der o foco


#Pedir para se logar quando tentar fazer algo q só quem está logado pode.
#    - Ver como fazer na hora de tentar fazer um comentário sem estar logado

Quando clicar em um versículo, ir para o capítulo e marcar o versículo
    - está dando um problema estranho no interpretador ruby (acho que é quando tem várias requisições simultaneas)
#COnvidar amigos do facebook
    - Testar para saber na prática como funciona (não está funcionando)
#Fazer index
    #- terminar tops (Fazer ordenação verdadeira)
        #- Top Usuários - ordenar por mais ativos (Seguidores + atividades + (likes - dislikes) )
        #- Top Versículos - OK
        #- Top Publicações - Ordenar corretamente pelas atividades mais bem votadas (likes - dislikes)
        #- Colocar nas páginas de ver lista completa a explicação em cinza também
    #- terminar Ultimas Publicações - performance da ordenação
    #- terminar + do sidebar
#Lembrar de criar uma App no Facebook para a Bíblia social e utilizá-la no lugar do GameUFC de teste
#Quando busca pelo nome do livro ele era para ir para o livro - deixar assim mesmo, quando busca por referência funciona
Lembrar de testar o envio dos emails
Testar novamente todas as funcionalidades de comentário!


#No IE deu um problema no índice. Os livros ficam fora de ordem
No IE, o botão publicar, desabilitado fica muito feio!
password -- senha


#No índice, quando clicar no livro, fazer abrir os capítulos com slide - Coloquei um FadeIn no lugar do slide, mas ficou massa
#Quando importa os comentários da versão anterior, as datas das citações ou referências que são geradas consequentemente, estão erradas.
#Está aparecendo no mural citações, que não deveriam aparecer
#Retirar aba de citações do perfil
Na hora de mostrar as citações, melhorar o seguinte:
    Mostrar "citou este versiculo em" + Ref_Versiculo
    Ocultar o comentário, deixando um linka para ver comentário
#Tem comentários com 5 linhas que a ultima linha não está aparecendo - melhorar o ver mais para quando ele tiver somente 5 linhas, não precisa mostrar ver mais
#Na página inicial, colocar uma opção de ver mais comentários (foi resolvido colocando o ícone de comentários)
Adicionar Selected a bibliasocial.com
Quando o usuário clicar em Bíblia, abrir o ultimo capítulo que ele estava lendo

*Reformular idéia dos comentários, para que não apareçam mais referencias ou links soltos nas respectivas abas



-----
Retirar tabela de comentários e os camos relacionados (Retirar do bano de dados os campos que não precisam mais existir)
  - Somente depois da migração

-----
update versiculos set comments_count = 0,	referencias_count = 0, 	links_count = 0, 	videos_count = 0, 	atividades_count = 0, 	citacoes_count = 0

http://localhost:3000/users/auth/facebook/callback?code=AQBawxWswdYBDa1Q5Hsd3ofjzbUNzVryoEp3753f7IiCAsoRIEmpzEkzq-fdlzeSA_8_Q6O5pk46HqVbZXRs-N3ay33PVrEobmFg5gnyEemZiwF01WjhpA2slbZKejJTbDcCFtU3up4Hp6QsIX6oja7toa8yNXwMhBx3oi6FBUBtdTbNDX1H-k1N9zvTzL9WMRs#_=_



Devise callbacks
https://groups.google.com/group/plataformatec-devise/browse_thread/thread/57d0259b075f21c5/e30420828b73e311?lnk=gst&q=callbacks#e30420828b73e311
http://rubydoc.info/github/hassox/warden/master/Warden/Hooks