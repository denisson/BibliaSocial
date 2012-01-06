require 'fileutils'

namespace :cache do
  task :expire => :environment do
    FileUtils.rm_rf("#{Rails.root}/public/index.html")
    Livro.all.each do |livro|
      FileUtils.rm_rf("#{Rails.root}/public/#{livro.permalink}.html")
      FileUtils.rm_rf("#{Rails.root}/public/#{livro.permalink}")
    end
  end
end