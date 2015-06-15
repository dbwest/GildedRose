require 'simplecov'
SimpleCov.start

require './gilded_rose.rb'
require "rspec"

require './regular_item_specs'

describe GildedRose do

  let(:store) { GildedRose.new }
  let(:vest) { store.items[0] }
  let(:brie) { store.items[1] }
  let(:elixir) { store.items[2] }
  let(:sulfuras) { store.items[3] }
  let(:tickets) {store.items[4]}
  let(:conjured_mana_cake) {store.items[5]}


  it "gets older when quality is updated" do
    starting_quality = vest.quality

    store.update_quality

    expect(vest.quality).to be < starting_quality
  end

  describe "vintage items" do
    describe 'brie' do
      it "should have brie increase in quality over time" do
        item_start_quality = brie.quality
        store.update_quality
        expect(brie.quality).to be > item_start_quality
      end
      it "cannot have quality greater than 50" do
        brie.quality = 0
        51.times { store.update_quality }
        expect(brie.quality).to be 50
      end
    end
  end

  describe "legendary items" do
    describe "sulfuras" do

      it "never has to be sold" do
        start_sell_in = sulfuras.sell_in
        expect(start_sell_in).to eq 0
        store.update_quality
        expect(start_sell_in).to eq 0
      end

      it "should not reduce in quality" do
        start_quality = sulfuras.quality
        store.update_quality
        expect(sulfuras.quality).to eq start_quality
      end

    end
  end

  describe "regular items" do
    store = GildedRose.new
    describe "elixir of the mongoose" do
      elixir = store.items[2]

      it_should_behave_like 'a regular item', store, elixir

    end
    describe 'the vest' do
      vest = store.items[0]

      it_should_behave_like 'a regular item', store, vest

    end
  end

  describe "hot tickets" do

    it 'should increase by one until within 10 days of the sell by' do
      tickets.sell_in = 15
      tickets.quality = 20

      store.update_quality

      expect(tickets.quality).to eq 21
    end
    it 'should increase by two within 10 days' do
      tickets.sell_in = 9
      tickets.quality = 20

      store.update_quality

      expect(tickets.quality).to eq 22
    end
    it 'should increase by 3 within 5 days' do
      tickets.sell_in = 4
      tickets.quality = 20

      store.update_quality

      expect(tickets.quality).to eq 23
    end
    it 'is worthless after the sell by' do
      tickets.sell_in = -1
      tickets.quality = 20

      store.update_quality

      expect(tickets.quality).to eq 0
    end
    it 'is worthless after the sell by corner case' do
      tickets.sell_in = 0
      tickets.quality = 20

      store.update_quality

      expect(tickets.quality).to eq 0
    end

  end

  describe "Conjured Items" do
    describe 'mana cake' do
      it 'should degrade in quality twice as fast' do
        conjured_mana_cake.sell_in = 9
        conjured_mana_cake.quality = 10

        store.update_quality

        expect(conjured_mana_cake.quality).to eq 8
      end
    end
  end

  describe Item do

    let(:item) { Item.new(1, 2, 3) }

    it "should have a sell_in attribute" do
      expect(item).to respond_to("sell_in")
    end

    it "should have a name attribute" do
      expect(item).to respond_to("name")
    end

    it "should have a quality attribute" do
      expect(item).to respond_to("quality")
    end

  end


end