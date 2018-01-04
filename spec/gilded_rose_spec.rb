require "gilded_rose"

describe GildedRose do

  class MockItem

    attr_accessor :name, :sell_in, :quality

    def initialize(name, sell_in, quality)
      @name = name
      @sell_in = sell_in
      @quality = quality
    end
  end

  let(:items) do
    items = [
      MockItem.new("Any item", 10, 20),
      MockItem.new("+5 Dexterity Vest", 10, 20),
      MockItem.new("+5 Dexterity Vest", -4, 20),
      MockItem.new("Aged Brie", 4, 40),
      MockItem.new("Aged Brie", -4, 20),
      MockItem.new("Backstage passes to a TAFKAL80ETC concert", 20, 20),
      MockItem.new("Backstage passes to a TAFKAL80ETC concert", 8, 20),
      MockItem.new("Backstage passes to a TAFKAL80ETC concert", 4, 20),
      MockItem.new("Backstage passes to a TAFKAL80ETC concert", 0, 20),
      MockItem.new("Conjured Mana Cake", 10, 20),
      MockItem.new("Conjured Mana Cake", -4, 20),
      MockItem.new("Sulfuras, Hand of Ragnaros", 20, 80)
    ]
  end

  let(:gilded_rose) { gilded_rose = GildedRose.new(items) }

  describe "#update_quality" do
    context "for every item (except 'Sulfuras, Hand of Ragnaros')" do
      it "reduces sell in days by one" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[0].sell_in}.by(-1)
      end

      it "doesn't reduce quality below zero" do
        20.times { gilded_rose.update_quality() }
        expect(gilded_rose.items[0].quality).to eq(0)
      end

      it "doesn't increase quality above fifty" do
        20.times { gilded_rose.update_quality() }
        expect(gilded_rose.items[3].quality).to eq(50)
      end
    end

    context "for normal items" do
      it "reduces quality by one during positive sell in days" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[1].quality}.by(-1)
      end

      it "reduces quality by two during negative sell in days" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[2].quality}.by(-2)
      end
    end

    context "for Aged Brie" do
      it "increases quality by one during positive sell in days" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[3].quality}.by(1)
      end

      it "increases quality by two during negative sell in days" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[4].quality}.by(2)
      end
    end

    context "for Backstage passes to a TAFKAL80ETC concert" do
      it "increases quality by one when there are more than ten sell in days left" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[5].quality}.by(1)
      end

      it "increases quality by two when there are between ten and five sell in days left" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[6].quality}.by(2)
      end

      it "increases quality by three when there are less than five sell in days left" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[7].quality}.by(3)
      end

      it "drops quality to zero after the concert" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[8].quality}.by(-20)
      end
    end

    context "for Conjured Mana Cake" do
      it "reduces quality by two during positive sell in days" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[9].quality}.by(-2)
      end

      it "reduces quality by four during negative sell in days" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[10].quality}.by(-4)
      end
    end

    context "for Sulfuras, Hand of Ragnaros" do
      it "sell_in days never decrease" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[11].sell_in}.by(0)
      end

      it "quality doesn't change" do
        expect{gilded_rose.update_quality()}.to change{gilded_rose.items[11].quality}.by(0)
      end
    end
  end
end
