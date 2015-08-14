require "spec_helper"

feature 'User sign up' do

  def sign_up(email: 'alice@example.com',
            password: '12345678',
            password_confirmation: '12345678')
    visit '/users/new'
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end
  
  scenario 'As a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users') # current_path is a helper provided by Capybara
    expect(page).to have_content 'Password and confirmation password do not match'
  end
  
  scenario "must have a valid email address" do
    expect { sign_up(email: '') }.not_to change(User, :count)
    expect(current_path).to eq "/users"
    expect(page).to have_content "Email address is not valid"
  end  
  
end