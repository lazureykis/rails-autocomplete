require 'spec_helper'

describe Rails::Autocomplete do
  let(:r) { Rails::Autocomplete.redis }

  it 'has a version number' do
    expect(Rails::Autocomplete::VERSION).not_to be nil
  end

  before(:each) do
    r.del 'test_ra'
  end

  context '#save_terms' do
    it 'stores array of terms to Redis' do
      expect(r.zcard('test_ra')).to eql 0

      values = ['one', 'two', 'three']
      RA.save_terms('test_ra', values)
      expect(r.zcard('test_ra')).to eql 3
      expect(r.zrange('test_ra', 0, 10).sort).to eql values.sort
    end
  end

  context '#find_terms' do
    before(:each) do
      RA.save_terms('test_ra', %w(bb cc aa b bbb))
      RA.save_terms('test_ra', %w(with data), {id: 1, params: 2})
    end

    it 'searches for all matches' do
      expect(RA.find_terms('test_ra', ['b'])).to eql %w(b bb bbb).map{|v| [v, nil]}
    end

    it 'respects limit option' do
      expect(RA.find_terms('test_ra', ['b'], 2)).to eql %w(b bb).map{|v| [v, nil]}
    end

    it 'returns data with term' do
      expect(RA.find_terms('test_ra', ['with'], 2)).to eql [['with', {'id' => 1, 'params' => 2}]]
    end
  end
end
