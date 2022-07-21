require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  # 姓、名、メール、パスワードがあれば有効な状態であること
  it 'is valid with a first name, last name, email, and password' do
    expect(user).to be_valid
  end

  # 名がなければ無効な状態であること
  it { is_expected.to validate_presence_of :first_name }

  # 姓がなければ無効な状態であること
  it { is_expected.to validate_presence_of :last_name }

  # メールアドレスがなければ無効な状態であること
  it { is_expected.to validate_presence_of :email }

  # 重複したメールアドレスなら無効な状態であること
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  # ユーザーのフルネームを文字列として返すこと
  it { is_expected.to satisfy { |user| user.name == 'Aaron Sumner' } }

  # アカウントが作成されたときにウェルカムメールを送信すること
  it 'sends a welcome email on account creation' do
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  # ジオコーディングを実行すること
  it 'performs geocording', vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: '161.185.207.20')
    expect { user.geocode }.to change(user, :location).from(nil).to('New York City, New York, US')
  end
end
