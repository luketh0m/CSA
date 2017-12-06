Before do
  user = User.create!(surname: 'Loftus',
                      firstname: 'Chris',
                      email: 'cwl@aber.ac.uk',
                      phone: '01970 622422',
                      grad_year: 1985)
  UserDetail.create!(login: 'admin',
                     password: 'taliesin',
                     user: user)

  puts "Added Username"
end

Given(/^that user "([^"]*)" with password "([^"]*)" has logged in$/) do |username, password|
  puts username, password
  visit('/session/new')
  fill_in('Login', :with=> username)
  fill_in('Password', :with=> password)
  click_on('LoginUser')
end

When(/^the user creates a new anonymous thread with the title "([^"]*)" with the body "([^"]*)"$/) do |title, body|
  visit('/posts/new')
  fill_in('Title', :with=> title)
  fill_in('Subject', :with=> body)
  check('post[author]')
  click_on('Create Post')
end

Then(/^the current page should contain a new row containing the data:$/) do |expected_results|
  visit('/posts')
  results = find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
  expected_results.diff!(results)
end