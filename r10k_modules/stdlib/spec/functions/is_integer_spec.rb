require_relative 'spec_helper'

describe 'is_integer' do
  it { is_expected.not_to eq(nil) }

  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params(1, 2).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

  it { is_expected.to run.with_params(3).and_return(true) }
  it { is_expected.to run.with_params('3').and_return(true) }
  it { is_expected.to run.with_params(-3).and_return(true) }
  it { is_expected.to run.with_params('-3').and_return(true) }
  it { is_expected.to run.with_params("123\nfoo").and_return(true) }
  it { is_expected.to run.with_params("foo\n123").and_return(true) }

  it { is_expected.to run.with_params(3.7).and_return(false) }
  it { is_expected.to run.with_params('3.7').and_return(false) }
  it { is_expected.to run.with_params(-3.7).and_return(false) }
  it { is_expected.to run.with_params('-3.7').and_return(false) }

  it { is_expected.to run.with_params('one').and_return(false) }
  it { is_expected.to run.with_params([]).and_return(false) }
  it { is_expected.to run.with_params([1]).and_return(false) }
  it { is_expected.to run.with_params({}).and_return(false) }
  it { is_expected.to run.with_params(true).and_return(false) }
  it { is_expected.to run.with_params(false).and_return(false) }
  it { is_expected.to run.with_params('0001234').and_return(false) }
  it { is_expected.to run.with_params("foo\nbar").and_return(false) }

  context 'with deprecation warning' do
    after(:each) do
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end
    # Checking for deprecation warning, which should only be provoked when the env variable for it is set.
    it 'displays a single deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
      expect(scope).to receive(:warning).with(include('This method is deprecated'))
      is_expected.to run.with_params(50).and_return(true)
    end
    it 'displays no warning for deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'false'
      expect(scope).to receive(:warning).with(include('This method is deprecated')).never
      is_expected.to run.with_params(50).and_return(true)
    end
  end
end
