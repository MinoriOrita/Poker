class Hand
  def initialize(cards)
    @cards = cards;
    @cardList = @cards.split  #受け取った文字列をカード毎の配列にする
    @suits = @cards.delete("0-9").split(/\s*/)  #スートだけの配列にする
    @numbers = @cardList.map{|e| e[1..2]}.map(&:to_i).sort  #数字だけの配列にする
    @sameNumbers = @numbers.uniq.map{|e| @numbers.count(e)}.sort  #重複しているものの数を数えて配列にする
  end


  def params_style_invalid()
    if @cards.blank?
      @errors = "カードを入力してください"
    elsif !(@cards =~ /.+\s.+\s.+\s.+\s.+\z/)
      @errors = "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
    end
    return @errors if @errors.present?
  end

  # バリデーション処理のアクション
  def repeated_invalid()
    if @cardList.uniq.size != 5
      @errors = "カードに重複があります"
    end
    return @errors if @errors.present?
  end

  def validation()
     if !(@cards =~ /[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\s[SHCD]([1-9]|1[0-3])\z/)
       @cardList.each_with_index{|card,index|
         if !(card =~ /[SHCD]([1-9]|1[0-3])\z/)
           @errors = "#{index+1}番目のカード指定文字が不正です。（#{card}）"
         end}
     end
     return @errors if @errors.present?
  end

  # 役を判定する処理のアクション
  def hand()
    if @suits.uniq.size == 1
      @hand = "フラッシュ"
      @score = 6
      if @numbers[-1] - @numbers[0] == 4
        @hand = "ストレートフラッシュ"
        @score = 9
      end
    else
      if @sameNumbers[-1] == 4
        @hand = "フォー・オブ・ア・カインド"
        @score = 8
      elsif @sameNumbers[-1] == 3 then
        @hand = "スリー・オブ・ア・カインド"
        @score = 4
         if @sameNumbers[-2] == 2
           @hand = "フルハウス"
           @score = 7
         end
       elsif @sameNumbers[-1] == 2 then
           @hand = "ワンペア"
           @score = 2
           if @sameNumbers[-2] == 2
             @hand = "ツーペア"
             @score = 3
           end
        elsif @sameNumbers[-1] == 1
           @hand = "ハイカード"
           @score = 1
           if @numbers[-1] - @numbers[0] == 4
             @hand = "ストレート"
             @score = 5
           end
         end
    end
    return @hand, @score
  end

end
