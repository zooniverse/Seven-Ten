RSpec.describe SplitPolicy, type: :policy do
  let(:user){ }
  let(:records){ create :split }
  subject{ SplitPolicy.new user, records }

  context 'without a user' do
    it_behaves_like 'a policy permitting', :index, :show
    it_behaves_like 'a policy forbidding', :create, :update, :destroy
  end

  context 'with a user' do
    let(:user){ create :user }
    it_behaves_like 'a policy permitting', :index, :show
    it_behaves_like 'a policy forbidding', :create, :update, :destroy
  end

  context 'with an admin' do
    let(:user){ create :user, :admin }
    it_behaves_like 'a policy permitting', :index, :show, :create, :update, :destroy
  end

  context 'with a project owner' do
    let(:user){ create :user, roles: { records.project.id => ['owner'] } }
    it_behaves_like 'a policy permitting', :index, :show, :create, :update, :destroy
  end

  context 'with a project collaborator' do
    let(:user){ create :user, roles: { records.project.id => ['collaborator'] } }
    it_behaves_like 'a policy permitting', :index, :show, :create, :update, :destroy
  end
end
