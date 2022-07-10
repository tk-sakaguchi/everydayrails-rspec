require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: 'Test Project', owner: @user)
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it 'does not allow duplicate project names per user' do
    new_project = @user.projects.create(name: 'Test Project')
    new_project.valid?
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it 'allows two users to share a project name' do
    other_user = FactoryBot.create(:user, first_name: 'Jane', last_name: 'Tester', email: 'janetester@example.com')
    other_project = FactoryBot.create(:project, name: 'Test Project', owner: other_user)
    expect(other_project).to be_valid
  end

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
