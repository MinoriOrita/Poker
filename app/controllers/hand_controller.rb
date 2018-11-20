class HandController < ApplicationController

def top  #topページを表示する
end

def check  #受け取って判定して返す
   if params[:cards].blank?
      @errors = "カードを入力してください"
   elsif !(params[:cards] =~ /.+\s.+\s.+\s.+\s.+\z/)
     @errors = "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"

   elsif
    @cards = params[:cards]  # 入力されたカードを受け取る
    # session[:cards] = @cards
    @cardList = @cards.split  #受け取った文字列をカード毎の配列にする
    @suits = @cards.delete("0-9").split(/\s*/)  #スートだけの配列にする
    @numbers = @cardList.map{|e| e[1..2]}.map(&:to_i).sort  #数字だけの配列にする
    @sameNumbers = @numbers.uniq.map{|e| @numbers.count(e)}.sort  #重複しているものの数を数えて配列にする
    # session[:hand] = nil
    validation_second()  #バリデーションをかける
    hand()  # 役の判定をする
   end
     #redirect_to("/result")
     # render ("result")
end

# バリデーション処理のアクション
def validation_second()
  if @cardList.uniq.size != 5
    @errors = "カードに重複があります"
     render("check")
  end
   if !(params[:cards] =~ /[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\z/)
     if !(@cardList[0] =~ /[SHCD]([1-9]|1[0-3])\z/)
       @errors = "１番目のカード指定文字が不正です。"+"（"+@cardList[0]+"）"
     elsif !(@cardList[1] =~ /[SHCD]([1-9]|1[0-3])\z/)
       @errors = "２番目のカード指定文字が不正です。"+"（"+@cardList[1]+"）"
     elsif !(@cardList[2] =~ /[SHCD]([1-9]|1[0-3])\z/)
       @errors = "３番目のカード指定文字が不正です。"+"（"+@cardList[2]+"）"
     elsif !(@cardList[3] =~ /[SHCD]([1-9]|1[0-3])\z/)
       @errors = "４番目のカード指定文字が不正です。"+"（"+@cardList[3]+"）"
     elsif !(@cardList[4] =~ /[SHCD]([1-9]|1[0-3])\z/)
       @errors = "５番目のカード指定文字が不正です。"+"（"+@cardList[4]+"）"
     else
       @errors = "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
     end
     render("check")
   end
end

# 役を判定する処理のアクション
def hand()
  if @suits.uniq.size == 1
    @hand = "フラッシュ"
    # session[:hand] = @hand
    if @numbers[-1] - @numbers[0] == 4
      @hand = "ストレートフラッシュ"
      # session[:hand] = @hand
    end
  else
    if @sameNumbers[-1] == 4
      @hand = "フォー・オブ・ア・カインド"
      # session[:hand]=@hand
    elsif @sameNumbers[-1] == 3 then
      @hand = "スリー・オブ・ア・カインド"
      # session[:hand] = @hand
       if @sameNumbers[-2] == 2
         @hand = "フルハウス"
         # session[:hand]=@hand
       end
     elsif @sameNumbers[-1] == 2 then
         @hand = "ワンペア"
       # session[:hand]=@hand
         if @sameNumbers[-2] == 2
           @hand = "ツーペア"
       # session[:hand] = @hand
         end
      elsif @sameNumbers[-1] == 1
         @hand = "ハイカード"
         # session[:hand] = @hand
         if @numbers[-1] - @numbers[0] == 4
           @hand = "ストレート"
           # session[:hand] = @hand
         end
       end
  end
end

end
