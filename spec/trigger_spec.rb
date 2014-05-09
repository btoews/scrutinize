require 'scrutinize/trigger'

describe Scrutinize::Trigger, "#match?" do
  describe "targets matching any method" do
    subject do
      Scrutinize::Trigger.new.tap do |target|
        target.add 'targets' => %w(File IO)
      end
    end

    it "matches any method for the targets" do
      expect(subject.match?('File', :write)).to eq(true)
      expect(subject.match?('IO', :read)).to eq(true)
    end

    it "doesn't match methods for other targets" do
      expect(subject.match?('Foo', :bar)).to eq(false)
    end
  end

  describe "methods matching any target" do
    subject do
      Scrutinize::Trigger.new.tap do |target|
        target.add 'methods' => %w(read write)
      end
    end

    it "matches any targets for the methods" do
      expect(subject.match?('Foo', :write)).to eq(true)
      expect(subject.match?('Bar', :read)).to eq(true)
    end

    it "matches nil targets for the method" do
      expect(subject.match?(nil, :write)).to eq(true)
    end

    it "doesn't match methods for other targets" do
      expect(subject.match?('Foo', :bar)).to eq(false)
    end
  end

  describe "any target matching any method" do
    subject do
      Scrutinize::Trigger.new.tap do |target|
        target.add 'target' => nil, 'method' => nil
      end
    end

    it "matches any method and any target" do
      expect(subject.match?('Foo', :write)).to eq(true)
      expect(subject.match?('Bar', :read)).to eq(true)
    end
  end

  describe "specific methods and targets" do
    subject do
      Scrutinize::Trigger.new.tap do |target|
        target.add 'target' => 'IO', 'methods' => %w(select read)
        target.add 'target' => 'File', 'methods' => %w(read write)
      end
    end

    it "matches specified methods/targets" do
      expect(subject.match?('IO', :select)).to eq(true)
      expect(subject.match?('IO', :read)).to eq(true)
      expect(subject.match?('File', :read)).to eq(true)
      expect(subject.match?('File', :write)).to eq(true)
    end

    it "doesn't match other methods/targets" do
      expect(subject.match?('File', :select)).to eq(false)
      expect(subject.match?('IO', :write)).to eq(false)
      expect(subject.match?('Foo', :bar)).to eq(false)
    end
  end

  describe "none target with specific methods" do
    subject do
      Scrutinize::Trigger.new.tap do |target|
        target.add 'target' => false, 'methods' => %w(read)
      end
    end

    it "matches specific methods with none target" do
      expect(subject.match?(nil, :read)).to eq(true)
    end

    it "doesn't match methods with a target" do
      expect(subject.match?('IO', :read)).to eq(false)
    end

    it "doesn't match other methods with none target" do
      expect(subject.match?(nil, :foo)).to eq(false)
    end
  end
end
