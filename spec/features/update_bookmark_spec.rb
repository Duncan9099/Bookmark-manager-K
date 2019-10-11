feature 'Updating a bookmark' do
  scenario 'User can update a bookmark' do
  bookmark = Bookmarks.create(url: 'http://www.reddt.com', title: 'Reddit')
  visit('/bookmarks')
  expect(page).to have_link('Reddit', href: 'http://www.reddt.com')

  first('.bookmark').click_button 'Edit'
  expect(current_path).to eq "/bookmarks/#{bookmark.id}/edit"

  fill_in('url', with: 'http://www.reddit.com')
  fill_in('title', with: 'Reddit')
  click_button('Submit')

  expect(current_path).to eq '/bookmarks'
  expect(page).to have_link('Reddit', href: 'http://www.reddit.com')
  expect(page).not_to have_link('Reddit', href: 'http://www.reddt.com')
  end
end
