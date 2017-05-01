class ApplicationMailer < ActionMailer::Base
  default from: 'system@tickets.com'
  layout 'mailer'
end
