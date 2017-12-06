require 'scrutinize/config'

describe Scrutinize::Config do
  describe "with unspecified ruby_version" do
    subject { Scrutinize::Config.new }

    it "uses RUBY_VERSION" do
      expected = \
        case RUBY_VERSION
        when /^1\.8\./
          'ruby18'
        when /^1\.9\./
          'ruby19'
        when /^2\.0\./
          'ruby20'
        when /^2\.1\./
          'ruby21'
        when /^2\.2\./
          'ruby22'
        when /^2\.3\./
          'ruby23'
        when /^2\.4\./
          'ruby24'
        end

      expect(subject.ruby_version).to eq(expected)
    end

    it "can be set to other versions" do
      subject.ruby_version = "1.8.7"
      expect(subject.ruby_version).to eq('ruby18')
    end

    it "parses crazy versions" do
      subject.ruby_version = "1.8.7.0.0alpha"
      expect(subject.ruby_version).to eq('ruby18')
    end

    it "selects a parser accordingly" do
      subject.ruby_version = "1.8.7"
      expect(subject.ruby_parser.to_s).to eq("Parser::Ruby18")
    end

    it "raises for bad ruby versions" do
      expect { subject.ruby_version = "9.9.9" }.to raise_error(NotImplementedError)
    end
  end

  describe "with specified trigger options" do
    it "allows target/method at top level of options" do
      c = Scrutinize::Config.new 'target' => 'File', 'method' => 'read'

      expect(c.trigger.match?('File', :read)).to eq(true)
      expect(c.trigger.match?('Foo', :read)).to eq(false)
      expect(c.trigger.match?('File', :foo)).to eq(false)
    end

    it "allows target/method under trigger key" do
      c = Scrutinize::Config.new(
        'trigger' => {
          'target' => 'File',
          'method' => 'read'
        }
      )

      expect(c.trigger.match?('File', :read)).to eq(true)
      expect(c.trigger.match?('Foo', :read)).to eq(false)
      expect(c.trigger.match?('File', :foo)).to eq(false)
    end

    it "allows target/method under triggers key" do
      c = Scrutinize::Config.new(
        'triggers' => [{
          'target' => 'File',
          'method' => 'read'
        }]
      )

      expect(c.trigger.match?('File', :read)).to eq(true)
      expect(c.trigger.match?('Foo', :read)).to eq(false)
      expect(c.trigger.match?('File', :foo)).to eq(false)
    end
  end
end
