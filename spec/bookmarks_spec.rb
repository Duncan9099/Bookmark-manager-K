require 'bookmarks'
require 'database_helpers'

describe Bookmarks do
  let(:comment_class) { double(:comment_class)}
  subject(:bookmarks) { described_class.new }
  let(:tag_class) { double(:tag_class) }

  describe '#all' do
    it 'should return a list of bookmarks' do
      connection = PG.connect(dbname: 'bookmark_manager_test')

     bookmark = Bookmarks.create(url: 'http://www.bbc.co.uk/sport', title: 'BBC Sport')
      Bookmarks.create(url: 'http://www.miniclip.com', title: 'Miniclip')
      Bookmarks.create(url: 'http://www.cartoonnetwork.co.uk', title: 'CN')

      bookmarks = Bookmarks.all

      expect(bookmarks.length).to eq 3
      expect(bookmarks.first).to be_a Bookmarks
      expect(bookmarks.first.id).to eq bookmark.id
      expect(bookmarks.first.title).to eq 'BBC Sport'
      expect(bookmarks.first.url).to eq 'http://www.bbc.co.uk/sport'
    end
  end

  describe '#create' do
    it 'creates a new bookmark' do
      bookmark = Bookmarks.create(url: 'http://www.test.com', title: 'Test')
      persisted_data = persisted_data(table: 'bookmarks', id: bookmark.id)

      expect(bookmark).to be_a Bookmarks
      expect(bookmark.id).to eq persisted_data.first['id']
      expect(bookmark.title).to eq 'Test'
      expect(bookmark.url).to eq 'http://www.test.com'
   end
    it 'validates new bookmarks by checking URL' do
      bookmark = Bookmarks.create(url: 'faketest', title: 'faketest')
      expect(bookmark).not_to be_a Bookmarks
    end
  end

  describe '#delete' do
    it 'deletes a bookmark' do
      bookmark = Bookmarks.create(url: 'http://www.test.com', title: 'Test')
      expect(Bookmarks.all).not_to be_empty
      Bookmarks.delete(id: bookmark.id)
      expect(Bookmarks.all).to be_empty
   end
    it 'deletes only the selected bookmark' do
      bookmark = Bookmarks.create(url: 'http://www.test1.com', title: 'Test1')
      bookmark2 = Bookmarks.create(url: 'http://www.test.com', title: 'Test')

      Bookmarks.delete(id: bookmark.id)
      expect(Bookmarks.all.length).to eq(1)
      expect(Bookmarks.all.first.title).to eq(bookmark2.title)
    end
  end

  describe '#get_bookmark' do
    context 'given an id' do
      it 'returns a bookmark' do
        bookmark = Bookmarks.create(url: 'http://www.test1.com', title: 'Test1')

        expect(Bookmarks.get_bookmark(bookmark.id)).to be_a(Bookmarks)
        expect(Bookmarks.get_bookmark(bookmark.id).url).to eq(bookmark.url)
        expect(Bookmarks.get_bookmark(bookmark.id).title).to eq(bookmark.title)
      end
    end
  end

  describe '#comments' do
    it 'calls .where on the Comment class' do
      bookmark = Bookmarks.create(url: 'http://www.test1.com', title: 'Test1')
      expect(comment_class).to receive(:where).with(bookmark_id: bookmark.id)

      bookmark.comments(comment_class)
    end
  end

  describe '#tags' do
    it 'calls .where on the Tag class' do
      bookmark = Bookmarks.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      expect(tag_class).to receive(:where).with(bookmark_id: bookmark.id)

      bookmark.tags(tag_class)
    end
  end
end
