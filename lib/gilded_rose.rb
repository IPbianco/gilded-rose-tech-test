require_relative 'item'

class GildedRose

  attr_reader :items

  def initialize(items = [])
    @items = items
  end

  def update_quality()
    non_legendary = @items.select { |item| item.name != "Sulfuras, Hand of Ragnaros" }
    non_legendary.each do |item|
      item.sell_in -= 1
      case item.name
      when "Aged Brie"
        item.sell_in < 0 ? item.quality += 2 : item.quality += 1
      when "Backstage passes to a TAFKAL80ETC concert"
        item.quality += 1 if item.sell_in > 10
        item.quality += 2 if item.sell_in.between?(6, 10)
        item.quality += 3 if item.sell_in.between?(0, 5)
        item.quality = 0 if item.sell_in < 0
      when "Conjured Mana Cake"
        item.sell_in < 0 ? item.quality -= 4 : item.quality -= 2
      else
        item.sell_in < 0 ? item.quality -= 2 : item.quality -= 1
      end
      item.quality = 0 if item.quality < 0
      item.quality = 50 if item.quality > 50
    end
  end
end
