require 'tag'
require 'bookmarks'
require 'database_helpers'

describe Tag do
  describe '.create' do
    it 'creates a new Tag object' do
      tag = Tag.create(content: 'test tag')

      persisted_data = persisted_data(id: tag.id, table: 'tags')

      expect(tag).to be_a Tag
      expect(tag.id).to eq persisted_data.first['id']
      expect(tag.content).to eq 'test tag'
    end
  end

  describe '.where' do
    it 'returns tags linked to the given bookmark id' do
      bookmark = Bookmarks.create(url: "http://www.makersacademy.com", title: "Makers Academy")
      tag1 = Tag.create(content: 'test tag 1')
      tag2 = Tag.create(content: 'test tag 2')
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag1.id)
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag2.id)

      tags = Tag.where(bookmark_id: bookmark.id)
      tag = tags.first

      expect(tags.length).to eq 2
      expect(tag).to be_a Tag
      expect(tag.id).to eq tag1.id
      expect(tag.content).to eq tag1.content
    end
  end
end
