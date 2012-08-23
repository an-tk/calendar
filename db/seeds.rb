User.delete_all
Event.delete_all
emanuel = User.create(:name => 'Emanuel', :email => 'emanuel@example.com', :password => 'testing')
diego = User.create(:name => 'Diego', :email => 'diego@example.com', :password => 'testing')
rodrigo = User.create(:name => 'Rodrigo', :email => 'rodrigo@example.com', :password => 'testing')

emanuel.events.create(:name => 'Burito-fest in Mexico', :start_at => Time.now.beginning_of_day + 1.day, :end_at => Time.now.beginning_of_day + 2.days )
emanuel.events.create(:name => 'Vacation!!!', :start_at => Time.now.beginning_of_day + 5.day, :end_at => Time.now.beginning_of_day + 10.days )
diego.events.create(:name => 'El desierto party', :start_at => Time.now, :end_at => Time.now)
rodrigo.events.create(:name => 'Ride to agava fields', :start_at => Time.now.beginning_of_day + 3.days, :end_at => Time.now.beginning_of_day + 3.days )