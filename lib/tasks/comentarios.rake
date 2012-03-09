namespace :comentarios do
  desc "migra os comentarios da versao 1.0 para a nova versao"
  task :migrar => :environment  do

    @graph = Koala::Facebook::API.new
    comentarios = Comentario.all

    comentarios.each do |comentario|
      if !MigracaoComentario.find_by_versiculo_id(comentario.versiculo_id)
        @result = @graph.get_comments_for_urls(comentario.href)

        @result.each do |url, comment|
            comment["comments"]["data"].each do |dados|
              MigracaoComentario.create({:facebook_user_id => dados["from"]["id"], :texto => dados["message"], :versiculo_id => comentario.versiculo_id, :created_at => dados["created_time"], :updated_at => dados["created_time"]})
            end
        end
      end
    end

  end
end