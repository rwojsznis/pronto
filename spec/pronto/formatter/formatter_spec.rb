module Pronto
  module Formatter
    describe '.get' do
      context 'single' do
        subject { Formatter.get(name).first }

        context 'json' do
          let(:name) { 'json' }
          it { should be_an_instance_of JsonFormatter }
        end

        context 'text' do
          let(:name) { 'text' }
          it { should be_an_instance_of TextFormatter }
        end

        context 'checkstyle' do
          let(:name) { 'checkstyle' }
          it { should be_an_instance_of CheckstyleFormatter }
        end

        context 'null' do
          let(:name) { 'null' }
          it { should be_an_instance_of NullFormatter }
        end

        context 'empty' do
          let(:name) { '' }
          it { should be_an_instance_of TextFormatter }
        end

        context 'nil' do
          let(:name) { nil }
          it { should be_an_instance_of TextFormatter }
        end
      end

      context 'multiple' do
        subject { Formatter.get(names) }

        context 'nil and empty' do
          let(:names) { [nil, ''] }

          its(:count) { should == 1 }
          its(:first) { should be_an_instance_of TextFormatter }
        end
      end
    end

    describe '.names' do
      subject { Formatter.names }
      it do
        should =~ %w[json checkstyle text null]
      end
    end
  end
end
