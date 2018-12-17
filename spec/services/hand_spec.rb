require "rails_helper"

RSpec.describe Hand do
  #空の場合
  describe "#validate()" do
    context "空の場合" do
      it "error message を出す" do
        hand = Hand.new("")
        expect(hand.validate()).to eq ["カードを入力してください。"]
      end
    end

#形式が違う場合
    context "４枚しか入ってない場合" do
      it "error message を出す"do
      hand = Hand.new("H3 H4 H5 H6")
      expect(hand.validate()).to eq ["5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
      end
    end

    context "６枚以上入ってる場合" do
      it "error message を出す"do
      hand = Hand.new("H6 H7 H8 H9 H10 H11")
      expect(hand.validate()).to eq ["5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
      end
    end

    context "前にスペースが入っている場合" do
      it "error message を出す"do
      hand = Hand.new(" H3 H4 H5 H6 H8")
      expect(hand.validate()).to eq ["5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
      end
    end

    context "間が全角スペースになっている場合" do
      it "error message を出す"do
      hand = Hand.new("H6　H7　H8　H9　H10")
      expect(hand.validate()).to eq ["5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
      end
    end

    context "前に全角スペースが入っている場合" do
      it "error message を出す"do
      hand = Hand.new("　H6 H7 H8 H9 H10")
      expect(hand.validate()).to eq ["5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
      end
    end

    context "複数のカードの間にスペースが無い∧4つ以外の半角スペースで区切られている" do
      it "error message を出す"do
      hand = Hand.new("H6H7 H8 H9 H10")
      expect(hand.validate()).to eq ["5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
      end
    end

    context "複数のカードの間にスペースが無い∧4つの半角スペースで区切られている場合" do
      it "error message を出す"do
      hand = Hand.new("H6H7 H8 H9 H10 H11")
      expect(hand.validate()).to eq ["#{1}番目のカード指定文字が不正です。（H6H7）"]
      end
    end

    context "半角じゃないものがある" do
      it "error message を出す"do
      hand = Hand.new("H6 H7 H8 H9 H１０")
      expect(hand.validate()).to eq ["5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
      end
    end

    context "間違った形式で入力した場合" do
      it "error message を出す"do
      hand = Hand.new("H3 H4 H5 H6 j9")
      expect(hand.validate()).to eq ["#{5}番目のカード指定文字が不正です。（j9）"]
      end
    end

    context "半角だが、間違ったものが複数ある場合" do
      it "error message を出す"do
      hand = Hand.new("H6 H7 H8 J9 j10")
      expect(hand.validate()).to eq ["#{4}番目のカード指定文字が不正です。（J9）","#{5}番目のカード指定文字が不正です。（j10）"]
      end
    end

    context "重複がある場合" do
      it "error message を出す"do
      hand = Hand.new("H3 H4 H5 H6 H6")
      expect(hand.validate()).to eq ["カードに重複があります。"]
      end
    end


  end

  describe "#judge()" do
    context "全部同じスートの場合" do
      it "フラッシュと６の配列を返す" do
        hand = Hand.new("H3 H4 H5 H6 H9")
        expect(hand.judge()).to eq ["フラッシュ",6]
      end
    end

    context "全部同じスートかつ連番の場合" do
      it "ストレートフラッシュと９の配列を返す" do
        hand = Hand.new("H3 H4 H5 H6 H7")
        expect(hand.judge()).to eq ["ストレートフラッシュ",9]
        end
      end

    context "四枚のカードの数字が一致する場合" do
      it "フォー・オブ・ア・カインドと４の配列を返す" do
        hand = Hand.new("H3 H4 C4 S4 D4")
        expect(hand.judge()).to eq ["フォー・オブ・ア・カインド",8]
      end
    end

    context "三枚のカードの数字が一致する場合" do
      it "スリー・オブ・ア・カインドと４の配列を返す" do
        hand = Hand.new("H3 H4 S5 C5 D5")
        expect(hand.judge()).to eq ["スリー・オブ・ア・カインド",4]
      end
    end

    context "三枚のカードの数字が一致かつ二枚のカードの数字が一致する場合" do
      it "フルハウスと７の配列を返す" do
        hand = Hand.new("H3 D3 D3 S7 H7")
        expect(hand.judge()).to eq ["フルハウス",7]
      end
    end

    context "二枚のカードの数字が一致する場合" do
      it "ワンペアと２の配列を返す" do
        hand = Hand.new("H3 D4 S5 S11 H11")
        expect(hand.judge()).to eq ["ワンペア",2]
      end
    end

    context "二枚のカードの数字が一致かつ他の二枚のカードの数字が一致する場合" do
      it "ツーペアと３の配列を返す" do
        hand = Hand.new("H3 D4 H4 S7 H7")
        expect(hand.judge()).to eq ["ツーペア",3]
      end
    end

    context "なにも一致しない場合" do
      it "ハイカードと１の配列を返す" do
        hand = Hand.new("H1 D4 H10 D6 S7")
        expect(hand.judge()).to eq ["ハイカード",1]
      end
    end

    context "連番の場合" do
      it "ストレートと５の配列を返す" do
        hand = Hand.new("H3 D4 H5 D6 S7")
        expect(hand.judge()).to eq ["ストレート",5]
      end
    end
  end
end
