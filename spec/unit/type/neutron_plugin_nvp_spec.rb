require 'puppet'
require 'puppet/type/neutron_plugin_nvp'

describe 'Puppet::Type.type(:neutron_plugin_nvp)' do

  before :each do
    @neutron_plugin_nvp = Puppet::Type.type(:neutron_plugin_nvp).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'neutron::install::end')
    catalog.add_resource anchor, @neutron_plugin_nvp
    dependency = @neutron_plugin_nvp.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@neutron_plugin_nvp)
    expect(dependency[0].source).to eq(anchor)
  end

end
