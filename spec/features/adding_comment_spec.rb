feature 'comment' do
  scenario 'it adds a comment to a bookmark' do
    visit '/bookmarks/new'

    fill_in('url', with: 'http://www.reddit.com')
    fill_in('title', with: 'Reddit')
    click_button('Submit')

    click_button 'Comment'

    fill_in 'comment', with: "Comment placed here"
    click_button 'Submit'

    expect(page).to have_content "Comment placed here"
  end
end
