require 'bookmarks'
require 'comment'
require 'database_helpers'

describe Comment do
  describe '.create' do
    it 'creates a comment' do
      bookmark = Bookmarks.create(url: 'http://www.test.com', title: 'Test')
      comment = Comment.create(text: 'Test comment', bookmark_id: bookmark.id)

      persisted_data = persisted_data(table: 'comments', id: comment.id)

      expect(comment).to be_a Comment
      expect(comment.id).to eq persisted_data.first['id']
      expect(comment.text).to eq 'Test comment'
      expect(comment.bookmark_id).to eq bookmark.id
    end
  end

  describe '.where' do
    it 'gets the relevant comments from the database' do
      bookmark = Bookmarks.create(url: 'http://www.test.com', title: 'Test')
      comment = Comment.create(text: 'Test comment', bookmark_id: bookmark.id)
      comment = Comment.create(text: 'Second test comment', bookmark_id: bookmark.id)

      comments = Comment.where(bookmark_id: bookmark.id)
      comment = comments.first
      persisted_data = persisted_data(table: 'comments', id: comment.id)

      expect(comments.length).to eq 2
      expect(comment.id).to eq persisted_data.first['id']
      expect(comment.text).to eq 'Test comment'
      expect(comment.bookmark_id).to eq bookmark.id
    end
  end
end
