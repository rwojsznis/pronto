module Pronto
  describe Config do
    let(:config) { described_class.new(config_hash) }
    let(:config_hash) { {} }

    describe '#default_commit' do
      subject { config.default_commit }

      context 'from env variable' do
        before { stub_const('ENV', 'PRONTO_DEFAULT_COMMIT' => 'development') }
        it { should == 'development' }
      end

      context 'from config hash' do
        let(:config_hash) { { 'default_commit' => 'development' } }
        it { should == 'development' }
      end

      context 'from default value' do
        it { should == 'master' }
      end
    end

    {
      max_warnings: {
        default_value: nil
      },
      warnings_per_review: {
        default_value: ConfigFile::DEFAULT_WARNINGS_PER_REVIEW
      }
    }.each do |setting_name, specifics|
      describe "##{setting_name}" do
        subject { config.public_send(setting_name) }

        context 'from env variable' do
          context 'with a valid value' do
            before { stub_const('ENV', "PRONTO_#{setting_name.upcase}" => '20') }
            it { should == 20 }
          end

          context 'with an invalid value' do
            before { stub_const('ENV', "PRONTO_#{setting_name.upcase}" => 'twenty') }

            specify do
              -> { subject }.should raise_error(ArgumentError)
            end
          end
        end

        context 'from config hash' do
          let(:config_hash) { { setting_name.to_s => 40 } }
          it { should == 40 }
        end

        context 'default' do
          let(:config_hash) { ConfigFile::EMPTY }
          it { should == specifics[:default_value] }
        end
      end
    end

    describe '#message_format' do
      subject { config.message_format('whatever') }

      context 'when there is an entry in the config file' do
        let(:config_hash) { { 'whatever' => { 'format' => whatever_format } } }
        let(:whatever_format) { "that's just like your opinion man" }

        it { should == whatever_format }
      end

      context 'when there is no entry in the config file' do
        let(:config_hash) { ConfigFile::EMPTY }

        it { should == ConfigFile::DEFAULT_MESSAGE_FORMAT }
      end
    end

    describe '#skip_runners' do
      subject { config.skip_runners }

      let(:env_variables) { {} }

      before do
        stub_const('ENV', env_variables)
      end

      context 'when runners are not skipped' do
        it { should be_empty }
      end

      context 'when runners are skipped via ENV variable' do
        let(:env_variables) { { 'PRONTO_SKIP_RUNNERS' => 'Runner,OtherRunner' } }

        it { should == %w[Runner OtherRunner] }
      end

      context 'when runners are skipped via config file' do
        let(:config_hash) { { 'skip_runners' => ['Runner'] } }

        it { should == %w[Runner] }
      end

      context 'when runners are skipped via config file and ENV variable' do
        let(:env_variables) { { 'PRONTO_SKIP_RUNNERS' => 'EnvRunner' } }
        let(:config_hash) { { 'skip_runners' => %w[ConfigRunner] } }

        it { should == %w[EnvRunner] }
      end
    end

    describe '#runners' do
      subject { config.runners }

      context 'when there is an entry in the config file' do
        let(:config_hash) { { 'runners' => ['Runner'] } }

        it { should == %w[Runner] }
      end

      context 'when there is no entry in the config file' do
        it { should be_empty }
      end
    end
  end
end
