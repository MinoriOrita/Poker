require "rails_helper"

RSpec.describe Hand do
  describe "#params_style_invalid()" do
    context "空の場合" do
      it "error message を出す" do
        hand = Hand.new("")
        expect(hand.params_style_invalid()).to eq "カードを入力してください"
      end
    end
    context "五枚入ってない場合" do
      it "error message を出す"do
      hand = Hand.new("H3 H4 H5 H6")
      expect(hand.params_style_invalid()).to eq "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
      end
    end
  end
  describe "#repeated_invalid()" do
    context "重複がある場合" do
      it "error message を出す"do
      hand = Hand.new("H3 H4 H5 H6 H6")
      expect(hand.repeated_invalid()).to eq "カードに重複があります"
      end
    end
  end
  describe "#validation()" do
    context "間違った形式で入力した場合" do
      it "error message を出す"do
      hand = Hand.new("H3 H4 H5 H6 j9")
      expect(hand.validation()).to eq "#{5}番目のカード指定文字が不正です。（j9）"
      end
    end
  end
  describe "#hand()" do
    context "全部同じスートの場合" do
      it "フラッシュと６の配列を返す" do
        hand = Hand.new("H3 H4 H5 H6 H9")
        expect(hand.hand()).to eq ["フラッシュ",6]
      end
    end
    context "全部同じスートかつ連番の場合" do
      it "ストレートフラッシュと９の配列を返す" do
        hand = Hand.new("H3 H4 H5 H6 H7")
        expect(hand.hand()).to eq ["ストレートフラッシュ",9]
        end
      end
    context "四枚のカードの数字が一致する場合" do
      it "フォー・オブ・ア・カインドと４の配列を返す" do
        hand = Hand.new("H3 H4 C4 S4 D4")
        expect(hand.hand()).to eq ["フォー・オブ・ア・カインド",8]
      end
    end
    context "三枚のカードの数字が一致する場合" do
      it "スリー・オブ・ア・カインドと４の配列を返す" do
        hand = Hand.new("H3 H4 S5 C5 D5")
        expect(hand.hand()).to eq ["スリー・オブ・ア・カインド",4]
      end
    end
    context "三枚のカードの数字が一致かつ二枚のカードの数字が一致する場合" do
      it "フルハウスと７の配列を返す" do
        hand = Hand.new("H3 D3 D3 S7 H7")
        expect(hand.hand()).to eq ["フルハウス",7]
      end
    end
    context "二枚のカードの数字が一致する場合" do
      it "ワンペアと２の配列を返す" do
        hand = Hand.new("H3 D4 S5 S11 H11")
        expect(hand.hand()).to eq ["ワンペア",2]
      end
    end
    context "二枚のカードの数字が一致かつ他の二枚のカードの数字が一致する場合" do
      it "ツーペアと３の配列を返す" do
        hand = Hand.new("H3 D4 H4 S7 H7")
        expect(hand.hand()).to eq ["ツーペア",3]
      end
    end
    context "なにも一致しない場合" do
      it "ハイカードと１の配列を返す" do
        hand = Hand.new("H1 D4 H10 D6 S7")
        expect(hand.hand()).to eq ["ハイカード",1]
      end
    end
    context "連番の場合" do
      it "ストレートと５の配列を返す" do
        hand = Hand.new("H3 D4 H5 D6 S7")
        expect(hand.hand()).to eq ["ストレート",5]
      end
    end
  end
end

RSpec.describe Hand::HandController, type: :controller do
  describe 'GET #top' do
    it "get top template" do
      get "top"
      expect(response).to render_template(:top)
    end
  end
    describe "POST #check"do
      context "cardsに何も入ってなかった場合" do
        it "topページにrenderする" do
          post :check, cards:nil
          expect(response).to render_template(:top)
        end
      end
      context "params_style_invalid()に引っかかる場合" do
        it "error message を出す、checkページにrenderする" do
          post :check, cards:
          hand = Hand.new("S6 S7 S13 S10")
          expect(hand.params_style_invalid()).to eq "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
          expect(response).to render_template(:check)
        end
      end
      context "repeated_invalid()に引っかかる場合" do
        it "error message を出す、checkページにrenderする" do
          post :check, cards:
          hand = Hand.new("S6 S7 S13 S10 S10")
          expect(hand.repeated_invalid()).to eq "カードに重複があります"
          expect(response).to render_template(:check)
        end
      end
      context "validation()に引っかかる場合" do
        it "error message を出す、checkページにrenderする" do
          post :check, cards:
          hand = Hand.new("S6 S7 S13 S10 H19")
          expect(hand.validation()).to eq "#{5}番目のカード指定文字が不正です。（H19）"
          expect(response).to render_template(:check)
        end
      end
      context "正常な場合" do
        it "役とスコアの配列を返す、checkページにrenderする" do
          post :check, cards:
          hand = Hand.new("S6 S7 S13 S4 S9")
          expect(hand.hand()).to eq ["フラッシュ",6]
          @hand = hand.hand()[0]
          expect(@hand).to eq "フラッシュ"
          expect(response).to render_template(:check)
        end
      end
    end
  end
# context "with 2 or more comments" do
#   it "orders them in reverse chronologically" do
    #post = Post.create!
    #comment1 = post.comments.create!(:body => "first comment")
    #comment2 = post.comments.create!(:body => "second comment")
    #expect(post.reload.comments).to eq([comment2, comment1])
#   end
# end
