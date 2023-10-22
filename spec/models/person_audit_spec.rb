# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PersonAudit, type: :model do
  subject { described_class.new }

  it 'is valid with valid attributes' do
    subject.email = 'test@example.com'
    subject.home_phone_number = '1234567890'
    subject.mobile_phone_number = '9876543210'
    subject.address = '123 Main Street'

    expect(subject).to be_valid
  end

  it 'is not valid with duplicate email' do
    PersonAudit.create(email: 'test@example.com')
    subject.email = 'test@example.com'

    expect(subject).not_to be_valid
  end

  it 'is not valid with duplicate home_phone_number' do
    PersonAudit.create(home_phone_number: '1234567890')
    subject.home_phone_number = '1234567890'

    expect(subject).not_to be_valid
  end

  it 'is not valid with duplicate mobile_phone_number' do
    PersonAudit.create(mobile_phone_number: '9876543210')
    subject.mobile_phone_number = '9876543210'

    expect(subject).not_to be_valid
  end

  it 'is not valid with duplicate address' do
    PersonAudit.create(address: '123 Main Street')
    subject.address = '123 Main Street'

    expect(subject).not_to be_valid
  end
end
