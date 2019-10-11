feature 'create user' do
  scenario 'it creates a new user' do
    visit '/users/new'

    fill_in 'email', with: 'user@user.com'
    fill_in 'password', with: 'password'
    click_button 'Submit'

    expect(page).to have_content('Welcome, user@user.com')
  end
end
