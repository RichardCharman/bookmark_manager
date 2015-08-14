feature 'User signs out' do

  before(:each) do
    User.create(email: 'test@test.com',
                password: 'test',
                password_confirmation: 'test')
  end

  scenario 'while being signed in' do
    user = create(:user)
    sign_in(user)
    click_button 'Sign out'
    expect(page).to have_content('You have logged out') # where does this message go?
    expect(page).not_to have_content("Welcome, #{user.email}")
  end

end