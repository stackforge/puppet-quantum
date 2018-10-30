require 'spec_helper'

describe 'convert_cert_to_string' do
  it 'exists' do
    is_expected.not_to eq(nil)
  end

  it 'fails with no arguments' do
    is_expected.to run.with_params.and_raise_error(ArgumentError)
  end

  it 'fails when arg is not a string' do
    is_expected.to run.with_params(123).and_raise_error(ArgumentError)
  end

  context 'when file does not exist' do
    it 'fails when cert file doesnt exist' do
      File.stubs(:file?).with('/etc/ssl/certs/test.pem').returns(false)
      is_expected.to run.with_params('/etc/ssl/certs/test.pem').and_raise_error(Puppet::ParseError)
    end
  end

  context 'with certificate that doesnt need strip' do
    it 'should return proper value' do
      File.stubs(:file?).with('/etc/ssl/certs/test.pem').returns(true)
      File.stubs(:readlines).with('/etc/ssl/certs/test.pem').returns(['----- BEGIN CERTIFICATE -----', 'abc123data', '----- END CERTIFICATE -----'])
      is_expected.to run.with_params('/etc/ssl/certs/test.pem').and_return('abc123data')
    end
  end

  context 'with certificate that requires strip' do
    it 'should return proper value' do
      File.stubs(:file?).with('/etc/ssl/certs/test.pem').returns(true)
      # NOTE(tobias-urdin): There is spacing in the return data here on purpose to test the ruby string strip.
      File.stubs(:readlines).with('/etc/ssl/certs/test.pem').returns(['----- BEGIN CERTIFICATE -----', '    abc321    ', '----- END CERTIFICATE -----'])
      is_expected.to run.with_params('/etc/ssl/certs/test.pem').and_return('abc321')
    end
  end
end
