require 'rails_helper'

describe Post do
  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :updateable }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :type }
    it { is_expected.to validate_presence_of :date }
    it { is_expected.to validate_presence_of :content }
  end

  it 'types' do
    expect(described_class.types).to eql ["ActionTaken", "Observation", "Diagnosis", "ClientFollowUp", "TechnicianNote"]
  end

  it '.diagnosis' do
    diagnosis   = create(:post, type: 'Diagnosis')
    observation = create(:post, type: 'Observation')

    expect(described_class.diagnosis.ids).to include(diagnosis.id)
    expect(described_class.diagnosis.ids).to_not include(observation.id)
  end

  it '.actions_taken' do
    action_taken = create(:post, type: 'ActionTaken')
    observation  = create(:post, type: 'Observation')

    expect(described_class.actions_taken.ids).to include(action_taken.id)
    expect(described_class.actions_taken.ids).to_not include(observation.id)
  end

end
