User.delete_all
Event.delete_all
emanuel = User.create(:name => 'Emanuel', :email => 'emanuel@example.com', :password => 'testing', :password_confirmation => 'testing')
diego = User.create(:name => 'Diego', :email => 'diego@example.com', :password => 'testing', :password_confirmation => 'testing')
rodrigo = User.create(:name => 'Rodrigo', :email => 'rodrigo@example.com', :password => 'testing', :password_confirmation => 'testing')

emanuel.events.create(:name => 'Non-repeatable event', :start_at => Date.today - 5.days , :end_at => Date.today - 3.days, :repeat => 0 )
emanuel.events.create(:name => 'Daily event', :start_at => Date.today, :end_at => Date.today, :repeat => 1 )
emanuel.events.create(:name => 'Weekly event', :start_at => Date.today + 5.day, :end_at => Date.today + 8.days, :repeat => 2 )
diego.events.create(:name => 'Monthly', :start_at => Date.today + 1.week, :end_at => Date.today + 2.weeks, :repeat => 3)
rodrigo.events.create(:name => 'Yearly event', :start_at => Date.today + 3.days, :end_at => Date.today + 3.days, :repeat => 4 )