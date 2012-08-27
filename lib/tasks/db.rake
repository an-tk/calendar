namespace :create do
  task :admin => :environment do
    @user =	User.new(:name => "admin", :email => "admin@example.com", :password => "testing", :password_confirmation => 'testing')
    @user.roles << "admin"
    @user.save
  end
end
