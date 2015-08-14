require "spec_helper"

feature 'User sign up' do

  def sign_up(user)
    visit "/users/new"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button "Sign up"
  end
  
  scenario 'as a new user' do
    user = build :user
    expect { sign_up(user) }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, #{user.email}")
    expect(User.first.email).to eq("#{user.email}")
  end

  scenario 'requires a matching confirmation password' do
    user = build(:user, password_confirmation: "wrong")
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users') # current_path is a helper provided by Capybara
    expect(page).to have_content 'Password does not match the confirmation'
  end
  
  scenario 'must have a valid email address' do
    user = build(:user, email: '')
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq "/users"
    expect(page).to have_content 'Email must not be blank'
  end  
  
  scenario 'I cannot sign up with an existing email' do
    user = build :user
    sign_up(user)
    expect { sign_up(user) }.to change(User, :count).by(0)
    expect(page).to have_content 'Email is already taken'
  end
  
  
  
end