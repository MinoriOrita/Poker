class Hand
#受け取ったStringを判定しやすい形に変える
def initialize(cards)
  @cards = cards;
  #受け取った文字列をカード毎の配列にする
  @card_list = @cards.split
  #スートだけの配列にする
  @suits = @card_list.map{|e| e.split(//,2)}.map(&:first).sort
  #数字だけの配列にする
  @numbers = @card_list.map{|e| e[1..2]}.map(&:to_i).sort
  #重複しているものの数を数えて配列にする
  @same_numbers = @numbers.uniq.map{|e| @numbers.count(e)}.sort
  # binding.pry
end

# バリデーション
def validate() #エラー部分を全部出すように作る
  @errors = []
  # 何も入ってないとき
  if @cards.blank?
    @errors << "カードを入力してください。"
  # 形式チェック
  elsif !(@cards =~ /\A\w+\s\w+\s\w+\s\w+\s\w+\z/) then #5枚以上でもこれではじくことできました
    @errors << "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
  # その他チェック
    #スートはSHCD、数字は１～13以外はエラーが出る
  elsif !(@cards =~ /\A[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\z/) then
        #どのカードが原因なのか特定する
        @card_list.each_with_index{|card,index|
          if !(card =~ /\A[SHCD]([1-9]|1[0-3])\z/)
            @errors << "#{index+1}番目のカード指定文字が不正です。（#{card}）"
          end}
      # 重複の時
  else
    if @card_list.uniq.size < 5
      @errors << "カードに重複があります。"
    end
  end
  return @errors if @errors.present?
end

  # 役を判定する処理のアクション
def judge()
  #違うスートの数が１個の時（=スートが全部一緒）
  if flush
    @hand = "フラッシュ"
    @score = 6
    #ストレート∧フラッシュ
   if straight
      @hand = "ストレートフラッシュ"
      @score = 9
    end
    #同じ数字の個数が４個の時
  elsif @same_numbers[-1] == 4 then
      @hand = "フォー・オブ・ア・カインド"
      @score = 8
    #同じ数字の個数が３個の時
  elsif @same_numbers[-1] == 3 then
      @hand = "スリー・オブ・ア・カインド"
      @score = 4
      #同じ数字の個数が３個∧同じ数字の個数が２個の時
       if @same_numbers[-2] == 2
         @hand = "フルハウス"
         @score = 7
       end
    #同じ数字の個数が２個の時
  elsif @same_numbers[-1] == 2 then   #@無いと違うメソッドで使えないんだった
         @hand = "ワンペア"
         @score = 2
         #同じ数字の個数が２個∧同じ数字の個数が２個の時
         if @same_numbers[-2] == 2
           @hand = "ツーペア"
           @score = 3
         end
      #同じ数字の個数が１個の時（＝全部違う数字）
    elsif @same_numbers[-1] == 1 then
         @hand = "ハイカード"
         @score = 1
         #連番の場合
       if straight
           @hand = "ストレート"
           @score = 5
         end
     else
       @hand = "正しく入力してください"
     end
  return @hand, @score if @hand.present?
end

def straight
  @numbers[-1] - @numbers[0] == 4
end

def flush
  @suits.uniq.size == 1
end

end
