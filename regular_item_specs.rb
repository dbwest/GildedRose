shared_examples_for 'a regular item' do |store, item|

  it "degrades by 1 when it ages" do
    item.quality = 20

    store.update_quality

    expect(item.quality).to eq (19)
  end

  it "should degrade twice as fast after sell_in day amount" do
    start_quality = item.quality
    start_sell_in = item.sell_in

    (item.sell_in + 1).times do
      store.update_quality
    end

    expected_quality = (start_quality - start_sell_in - 2)
    expect(item.quality).to be expected_quality
  end


end

