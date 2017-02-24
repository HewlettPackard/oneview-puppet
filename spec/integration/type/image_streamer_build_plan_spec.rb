require 'spec_helper'

type_class = Puppet::Type.type(:image_streamer_build_plan)

def build_plan_config
  {
    name: 'build_plan_1',
    ensure: 'present',
    data:
        {
          'name'            => 'Demo OS Build Plan',
          'description'     => 'oebuildplan',
          'oeBuildPlanType' => 'deploy'
        }
  }
end

describe type_class do
  let :params do
    [
      :name,
      :data,
      :provider
    ]
  end

  let :special_ensurables do
    [
      :found
    ]
  end

  it 'should accept special ensurables' do
    special_ensurables.each do |value|
      expect do
        described_class.new(name: 'Test',
                            ensure: value,
                            data: {})
      end.to_not raise_error
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to include(param)
    end
  end

  it 'should require a name' do
    expect { type_class.new({}) }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should require a data hash' do
    modified_config = build_plan_config
    modified_config[:data] = 5
    expect { type_class.new(modified_config) }.to raise_error(/Inserted value for data is not valid/)
  end
end
