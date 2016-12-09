
RANKS = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
SUITS = ["C", "D", "H", "S"]
SORTED_CARDS = [
    "AC", "AD", "AH", "AS", "2C", "2D", "2H", "2S", "3C", "3D", "3H", "3S",
    "4C", "4D", "4H", "4S", "5C", "5D", "5H", "5S", "6C", "6D", "6H", "6S",
    "7C", "7D", "7H", "7S", "8C", "8D", "8H", "8S", "9C", "9D", "9H", "9S",
    "10C", "10D", "10H", "10S", "JC", "JD", "JH", "JS", "QC", "QD", "QH", "QS",
    "KC", "KD", "KH", "KS"
]

class PlayingCard
  attr_reader :card, :face
  def initialize(hash)
    @card = {
      :rank=>hash[:rank],
      :suit=>hash[:suit]
    }

    @face = @card[:rank] + @card[:suit]
  end

  def rank
    @card[:rank]
  end

  def suit
    @card[:suit]
  end

  def to_s
    @face
  end
end

class CardDeck
  attr_reader :cards

  def initialize(shuffled=true)
    @cards = []
    generate_deck
    shuffle if shuffled
  end

  def generate_deck
       52.times do |i|
         @cards << PlayingCard.new({:rank=>SORTED_CARDS[i][0], :suit=>SORTED_CARDS[i][1..-1]})
       end
  end

  def shuffle
    @cards.shuffle!
  end

  def draw(n=1)
    flipped_cards = []

    n = n>=self.cards.size ? self.cards.size : n

    n.times do
      flipped_cards << self.cards.pop
    end
    flipped_cards
  end

  def draw_one
    self.cards.pop
  end
end

class HandOfCards < CardDeck
  attr_reader :hand
  def initialize(hand=[])
    @hand = hand
  end

  def cards
    @hand
  end

  def to_s
    @hand.join(" ")
  end

  def any?(card)
    return @hand.join(" ").include? card[:rank] if card[:rank]
    return @hand.join(" ").include? card[:suit] if card[:suit]
  end

  def take!(card)
    arr = @hand.select{|c| c.rank==card[:rank]} if card[:rank]
    arr = @hand.select{|c| c.suit==card[:suit]} if card[:suit]
    arr.each{|element| @hand.delete(element)}
  end

  def push(*cards)
    cards.each {|card|
      @hand << card
    }
  end
end

class CardPlayer < HandOfCards
  def initialize(hash)
    @hand = hash[:hand]
  end
end


# Driver Code
if __FILE__ == $0
  puts "This will only print if you run `ruby go_fish.rb`"
  deck = CardDeck.new
  # # puts "cards: #{deck.cards}"
  # # puts "cards: #{deck}"
  # # puts "shuffled: #{deck.shuffle}"
  # puts "one drawn card: #{deck.draw_one}"
  # puts "two drawn cards: #{deck.draw(2)}"

  cards1 = deck.draw(5)
  cards2 = deck.draw(5)
  puts "cards1: #{cards1.join(" ")}"
  puts "cards2: #{cards2.join(" ")}"

  h1 = HandOfCards.new(cards1)
  h2 = HandOfCards.new(cards2)

  puts "hand1: #{h1}"
  puts "hand2: #{h2}"

  p1 = CardPlayer.new(hand: h1)
  p2 = CardPlayer.new(hand: h2 )

  puts "Hands: [ #{p1.hand} ], [ #{p2.hand} ] (before)"

  ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
  ranks.each do |rank|
    print "p1, do you have any... #{rank}'s?"
    if p1.hand.any?(rank: rank)
      cards = p1.hand.take!(rank: rank)
      print " -- YES: [ #{ cards.join(" ") } ]\n"
      p2.hand.push(*cards)
      break
    end
    print " -- NO!\n"
  end

  puts "Hands: [ #{p1.hand} ], [ #{p2.hand} ] (after)"
end
