class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com'
  layout 'mailer'
      # pp/views/layouts/mailer.text.erb or mailer.html.erb
end
