require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: 'Test Project', owner: @user)
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  # 二人のユーザーが同じ名前を使うことは許可すること
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  describe 'late status' do
    # 締切日が過ぎていれば遅延していること
    it 'is late when the due date is past today' do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュール通りであること
    it 'is on time when the due date is today' do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締切日が未来ならスケジュール通りであること
    it 'is on time when the due date is in the future' do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
