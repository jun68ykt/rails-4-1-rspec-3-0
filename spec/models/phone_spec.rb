require 'rails_helper'

describe Phone do

  it 'ファクトリが有効なオブジェクトを返すこと' do
    phone = build :phone
    expect(phone).to be_valid
  end

  it '連絡先ごとに重複した電話番号を許可しないこと' do
    contact = create :contact

    create(:home_phone,
        contact: contact,
        phone: '785-555-1234'
    )
    mobile_phone = build(:mobile_phone,
        contact: contact,
        phone_type: 'mobile',
        phone: '785-555-1234'
    )

    mobile_phone.valid?
    expect(mobile_phone.errors[:phone]).to include('has already been taken')
  end

  it '2 件の連絡先で同じ電話番号を共有できること' do

    create(
        :home_phone,
        phone: '785-555-1234'
    )

    other_phone = build(
        :home_phone,
        phone: '785-555-1234'
    )

    expect(other_phone).to be_valid
  end
end