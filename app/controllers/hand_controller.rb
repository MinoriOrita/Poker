class HandController < ApplicationController

def check  #受け取って判定して返す
  cards = params[:cards]
#空のときはtopページに戻る
  if cards != nil
    hand = Hand.new(cards)
    @errors = hand.validate()
    unless hand.validate()
      @hand_and_score = hand.judge()
      @hand = @hand_and_score[0]
    end
  end
end

end
