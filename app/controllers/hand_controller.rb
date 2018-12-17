class HandController < ApplicationController
def top  #topページを表示する
end

def check  #受け取って判定して返す
  cards = params[:cards]
#空のときはtopページに戻る
  if cards == nil
    render("top")
  else
#なにか入ってるときは判別する
    hand = Hand.new(cards)
    @errors = hand.validate()
    render("check") and return if hand.validate()
    @hand_and_score = hand.judge()
    @hand = @hand_and_score[0]
  end
end

end
