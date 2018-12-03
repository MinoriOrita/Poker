class HandController < ApplicationController
def top  #topページを表示する
end

def check  #受け取って判定して返す
  cards = params[:cards]
  if cards == nil
    render("top")
  else
  hand = Hand.new(cards)
  @errors = hand.params_style_invalid()
  render("check") and return if hand.params_style_invalid()
  @errors = hand.repeated_invalid()
  render("check") and return if hand.repeated_invalid()
  @errors = hand.validation()
  render("check") and return if hand.validation()
  @handAndScore = hand.hand()
  @hand = @handAndScore[0]
end
end

# def initialzie()
#   @cardList = @cards.split  #受け取った文字列をカード毎の配列にする
#   @suits = @cards.delete("0-9").split  #スートだけの配列にする
#   @numbers = @cardList.map{|e| e[1..2]}.map(&:to_i).sort  #数字だけの配列にする
#   @sameNumbers = @numbers.uniq.map{|e| @numbers.count(e)}.sort  #重複しているものの数を数えて配列にする
# end
#
# def params_style_invalid?
#   if @cards.blank?
#     @errors = "カードを入力してください"
#   elsif !(@cards =~ /.+\s.+\s.+\s.+\s.+\z/)
#     @errors = "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
#   end
#   return true if @errors.present?
# end
#
# # バリデーション処理のアクション
# def validation()
#   if @cardList.uniq.size != 5
#     @errors = "カードに重複があります"
#      render("check") and return
#   end
#    if !(@cards =~ /[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\z/)
#      @cardList.each_with_index{|card,index|
#        if !(card =~ /[SHCD]([1-9]|1[0-3])\z/)
#          @errors = "#{index+1}番目のカード指定文字が不正です。（#{card}） "
#        end}
#      render("check")
#    end
# end
#
# # 役を判定する処理のアクション
# def hand()
#   if @suits.uniq.size == 1
#     @hand = "フラッシュ"
#     if @numbers[-1] - @numbers[0] == 4
#       @hand = "ストレートフラッシュ"
#     end
#   else
#     if @sameNumbers[-1] == 4
#       @hand = "フォー・オブ・ア・カインド"
#     elsif @sameNumbers[-1] == 3 then
#       @hand = "スリー・オブ・ア・カインド"
#        if @sameNumbers[-2] == 2
#          @hand = "フルハウス"
#        end
#      elsif @sameNumbers[-1] == 2 then
#          @hand = "ワンペア"
#          if @sameNumbers[-2] == 2
#            @hand = "ツーペア"
#          end
#       elsif @sameNumbers[-1] == 1
#          @hand = "ハイカード"
#          if @numbers[-1] - @numbers[0] == 4
#            @hand = "ストレート"
#          end
#        end
#   end
# end


end
