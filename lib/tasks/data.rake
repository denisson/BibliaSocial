# encoding: UTF-8

require 'nokogiri'
require 'open-uri'

namespace :data do
  task :bibliaonline => :environment do
    Biblia.transaction do
      biblia = Biblia.create!(:nome => 'Almeida Corrigida e Revisada Fiel', :permalink => 'acf')

      velho_testamento = Secao.create!(:nome => 'Velho Testamento', :permalink => 'velho-testamento', :biblia_id => biblia.id)
      novo_testamento = Secao.create!(:nome => 'Novo Testamento', :permalink => 'novo-testamento', :biblia_id => biblia.id)

      doc = Nokogiri::HTML(open('http://www.bibliaonline.com.br/acf'))
      doc.css('.books_select a').each do |book|
        secao = book.attribute('book').to_s.to_i <= 39 ? velho_testamento : novo_testamento
        livro = Livro.create!(:numero => book.attribute('book').to_s, :nome => book.content.chomp.strip, :permalink => book.content.chomp.strip.parameterize, :biblia_id => biblia.id, :secao_id => secao.id)
        puts livro.nome
        capitulos = book.attribute('chapters').to_s.to_i
        url = book.attribute('href').to_s
        url = url[0.. url.length - 2]
        
        1.upto(capitulos) do |i|
          capitulo = Capitulo.create!(:numero => i, :biblia_id => biblia.id, :secao_id => secao.id, :livro_id => livro.id)
    
          doc = Nokogiri::HTML(open("#{url}#{i}"))
          doc.css('article p').each do |article|
            versiculo = Versiculo.create!(:numero => article.attribute('verse').to_s, :texto => article.content.chomp.strip, :biblia_id => biblia.id, :secao_id => secao.id, :livro_id => livro.id, :capitulo_id => capitulo.id)
            puts versiculo.to_json if versiculo.texto.blank?
          end 
        end
      end      
    end
  end
  
  task :bibliaon => :environment do
    biblia = Biblia.create!(:nome => 'Almeida Corrigida e Revisada Fiel', :permalink => 'acf')

    velho_testamento = Secao.create!(:nome => 'Velho Testamento', :permalink => 'velho-testamento', :biblia_id => biblia.id)
    novo_testamento = Secao.create!(:nome => 'Novo Testamento', :permalink => 'novo-testamento', :biblia_id => biblia.id)
    
    doc = Nokogiri::HTML(open('http://www.bibliaon.com/'), 'ISO-8859-1')
    doc.css('.livros li > a').each_with_index do |l, i|
      secao = i <= 38 ? velho_testamento : novo_testamento
      livro = Livro.create!(:numero => i + 1, :nome => l.content.chomp.strip, :permalink => l.attribute('href').to_s.gsub(/\//, ''), :biblia_id => biblia.id, :secao_id => secao.id)
      puts livro.nome
      
      doc = Nokogiri::HTML(open("http://www.bibliaon.com/#{livro.permalink}/"), 'ISO-8859-1')
      doc.css('.wrapper li > a > b').each do |c|
        capitulo = Capitulo.create!(:numero => c.content.chomp.strip, :biblia_id => biblia.id, :secao_id => secao.id, :livro_id => livro.id)
        
        doc = Nokogiri::HTML(open("http://www.bibliaon.com/#{livro.permalink}_#{capitulo.numero}/"), 'ISO-8859-1')
        doc.css('.mainbar > p').each_with_index do |p, i|
          content = ''
          initial = p.at_css('.paragrafo')
          content << initial.content if initial
          content << p.xpath('child::text()').to_s.encode("UTF-8").gsub(/[\n\r]/, '').rstrip.squeeze(' ')
          content = "#{content[0].upcase}#{content[1..content.length - 1]}"
          content = content.gsub(/Â/,'À').gsub(/â/,'à')
          Versiculo.create!(:numero => i + 1, :texto => content, :biblia_id => biblia.id, :secao_id => secao.id, :livro_id => livro.id, :capitulo_id => capitulo.id)
        end
      end
    end
  end
end