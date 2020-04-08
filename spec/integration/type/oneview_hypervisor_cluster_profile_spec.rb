require 'spec_helper'

type_class = Puppet::Type.type(:oneview_hypervisor_cluster_profile)

def hcp_config
  {
    name:                           'test_hcp',
    data   => {
        type                           => HypervisorClusterProfileV3,
        name                           => Cluster5,
        hypervisorManagerUri           => /rest/hypervisor-managers/befc6bd9-0366-4fd9-a3fc-c92ab0df3603,
        path                           => DC2,
        hypervisorType                 => Vmware,
        hypervisorHostProfileTemplate  => 
        {
          serverProfileTemplateUri     => /rest/server-profile-templates/c865a62c-8fd8-414c-8c16-3f7ca75ab2ba,
          deploymentPlan   => {
           deploymentPlanUri            => /rest/os-deployment-plans/c54e1dab-cc14-48fa-92bf-d301671fb0cf,
           serverPassword               => dcs
          },
          hostprefix                    => Test-Cluster-host
        }
    }
  }
end

describe type_class, integration: true do
  let(:params) { %i[name data provider] }

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'should require a name' do
    expect do
      type_class.new({})
    end.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should require a data hash' do
    modified_config = hcp_config
    modified_config[:data] = ''
    expect do
      type_class.new(modified_config)
    end.to raise_error(/Inserted value for data is not valid/)
  end
end
