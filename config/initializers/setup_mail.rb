ActionMailer::Base.smtp_settings = {
	  :address              => "smtp.gmail.com",
	  :port                 => 587,
	  :domain               => 'bibliasocial.com',
	  :user_name            => 'dap.tci@gmail.com',
	  :password             => 'gmail130687',
	  :authentication       => 'plain',
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"