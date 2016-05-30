require 'spec_helper'
describe 'oneview' do

  context 'with defaults for all parameters' do
    it { should contain_class('oneview') }
  end
end
