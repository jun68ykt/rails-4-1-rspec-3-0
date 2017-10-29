require 'rails_helper'

describe Contact do

  it '有効なファクトリを持つこと' do
    contact = FactoryGirl.build(:contact)
    expect(contact).to be_valid
  end

  it '名がなければ無効な状態であること' do
    contact = FactoryGirl.build(:contact, firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include('can\'t be blank')
  end

  it '姓がなければ無効な状態であること' do
    contact = FactoryGirl.build(:contact, lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include('can\'t be blank')
  end

  it 'メールアドレスがなければ無効な状態であること' do
    contact = FactoryGirl.build(:contact, email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include('can\'t be blank')
  end

  it '重複したメールアドレスなら無効な状態であること' do
    FactoryGirl.create(:contact, email: 'aaron@example.com')
    contact = FactoryGirl.build(:contact, email: 'aaron@example.com')
    contact.valid?
    expect(contact.errors[:email]).to include('has already been taken')
  end

  it '連絡先のフルネームを文字列として返すこと' do
    contact = FactoryGirl.build(:contact,
        firstname: 'Jane',
        lastname: 'Smith'
    )
    expect(contact.name).to eq 'Jane Smith'
  end

  describe '文字で姓をフィルタする' do

    before :each do
      @smith = Contact.create!(
          firstname: 'John',
          lastname: 'Smith',
          email: 'jsmith@example.com'
      )
      @jones = Contact.create!(
          firstname: 'Tim',
          lastname: 'Jones',
          email: 'tjones@example.com'
      )
      @johnson = Contact.create!(
          firstname: 'John',
          lastname: 'Johnson',
          email: 'jjohnson@example.com'
      )
    end

    context 'マッチする文字の場合' do
      it 'マッチした結果をソート済みの配列として返すこと' do
        expect(Contact.by_letter('J')).to eq [@johnson, @jones]
      end
    end

    context 'マッチしない文字の場合' do
      it 'マッチしないものは結果に含まれないこと' do
        expect(Contact.by_letter('J')).not_to include @smith
      end
    end
  end
end
