class UserMailer < ApplicationMailer
	def welcome_email(resource, password)
    @resource = resource
    @password = password
    mail(to: @resource.email, subject: 'Welcome to Tickets System')
  end
end
