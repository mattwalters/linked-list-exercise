require 'minitest/autorun'

require './lib/list'
require './lib/node'

describe List do

  let(:list) { List.new }

  describe "#add" do
    describe "with regular list" do
      let(:list) { List.new(sorted: false) }

      it "should add elements to end of list" do
        list.length.must_equal 0

        list.add('foo')
        list.elements.must_equal(['foo'])

        list.add('bar')
        list.elements.must_equal(['foo', 'bar'])

        list.add('baz')
        list.elements.must_equal(['foo', 'bar', 'baz'])
      end
    end

    describe "with sorted list" do
      let(:list) { List.new(sorted: true) }

      it "should add elements based on sort order" do
        list.length.must_equal 0

        list.add('foo')
        list.elements.must_equal(['foo'])

        list.add('bar')
        list.elements.must_equal(['bar', 'foo'])

        list.add('baz')
        list.elements.must_equal(['bar', 'baz', 'foo'])

        list.add('zed')
        list.elements.must_equal(['bar', 'baz', 'foo', 'zed'])

        list.add('alf')
        list.elements.must_equal(['alf', 'bar', 'baz', 'foo', 'zed'])
      end
    end

    describe 'with custom comparator' do
      # reverse comparator
      let(:comparator) { Proc.new { |a, b| b <=> a } }
      let(:list) { List.new(sorted: comparator) }

      it "should add elements based on sort order" do
        list.length.must_equal 0

        list.add('foo')
        list.elements.must_equal(['foo'])

        list.add('bar')
        list.elements.must_equal(['foo', 'bar'])

        list.add('baz')
        list.elements.must_equal(['foo', 'baz', 'bar'])

        list.add('zed')
        list.elements.must_equal(['zed', 'foo', 'baz', 'bar'])

        list.add('alf')
        list.elements.must_equal(['zed', 'foo', 'baz', 'bar', 'alf'])
      end
    end

  end

  describe '#length' do

    it 'should count the number of elements' do
      list.length.must_equal 0
      list.add(nil)
      list.length.must_equal 1
      list.add(nil)
      list.length.must_equal 2
      list.add(nil)
      list.length.must_equal 3

      list.pop
      list.length.must_equal 2
    end
  end

  describe "#member?" do
    let(:data) { [1,2] }

    before do
      data.each do |i|
        list.add(i)
      end
    end

    describe "when object is member of list" do
      it "should return true" do
        list.member?(data[0]).must_equal true
      end
    end

    describe "when object is not member of list" do
      it "should return false" do
        list.member?('xxx').must_equal false
      end
    end
  end

  describe "#pop" do
    describe "with empty list" do
      it "should return nil" do
        list.length.must_equal 0
        list.pop.must_equal nil
        list.length.must_equal 0
      end
    end

    describe "with non-empty list" do
      let(:data) { [1,2] }

      before do
        data.each do |i|
          list.add(i)
        end
      end

      it "should get and remove first element from list" do
        list.length.must_equal data.length
        list.elements.must_equal(data)

        list.pop.must_equal(data[0])
        list.length.must_equal (data.length - 1)

        list.elements.must_equal(data.slice(1, data.length))
      end
    end
  end

  describe '#empty?' do
    describe 'with an empty list' do
      it 'should return true' do
        list.empty?.must_equal true
      end
    end

    describe 'with a non-empty list' do
      let(:data) { [1,2] }

      before do
        data.each do |i|
          list.add(i)
        end
      end

      it 'should return false' do
        list.empty?.must_equal false
      end
    end
  end

  describe '#each' do
    describe 'without passing a block' do
      it 'returns an Enumerable' do
        check = list.each
        assert_kind_of(Enumerable, check)
      end
    end

    describe 'with passing a block' do
      let(:data) { ['foo', 'bar'] }

      before do
        data.each do |i|
          list.add(i)
        end
      end

      it 'returns an Enumerable' do
        check = list.each { |item| _ }
        assert_kind_of(Enumerable, check)
      end

      it 'yields each object' do
        check = ""
        list.each { |item| check << item }
        check.must_equal('foobar')
      end
    end
  end

  describe '#elements' do
    let(:data) { ['foo', 'bar'] }

    before do
      data.each do |i|
        list.add(i)
      end
    end

    it 'returns an Array' do
      assert_kind_of(Array, list.elements)
    end

    it 'returns the elements in the correct order' do
      list.elements.must_equal data
    end
  end
end
