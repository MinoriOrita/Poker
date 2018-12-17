require "rails_helper"

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

      context "入力されてない場合" do
        it "error message を出す、checkページにrenderする" do
          post :check, {cards: ""}
          expect(:errors).to be_truthy
          # expect(controller.instance_variable_get(:@errors)).to eq ["カードを入力してください。"]
          expect(response).to render_template(:check)
        end
      end

      context "カードが一枚足りない場合" do
        it "error message を出す、checkページにrenderする" do
          post :check, {cards:"S6 S7 S13 S10"}
          expect(:errors).to be_truthy
          # expect(controller.instance_variable_get("@errors")).to eq ["5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
          expect(response).to render_template(:check)
        end
      end

      # context "最初にスペースが入っている場合" do
      #   it "error message を出す、checkページにrenderする" do
      #     post :check, {cards:" S6 S7 S13 S10 H9"}
      #     expect(controller.instance_variable_get("@errors")).to eq ["5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
      #     expect(response).to render_template(:check)
      #   end
      # end
      #
      # context "重複している場合" do
      #   it "error message を出す、checkページにrenderする" do
      #     post :check, {cards:"S6 S7 S13 S10 S10"}
      #     expect(controller.instance_variable_get("@errors")).to eq ["カードに重複があります。"]
      #     expect(response).to render_template(:check)
      #   end
      # end
      #
      # context "スートと数字の形式が異常な場合" do
      #   it "error message を出す、checkページにrenderする" do
      #     post :check, {cards:"S6 S7 S13 S10 J10"}
      #     expect(controller.instance_variable_get("@errors")).to eq ["#{5}番目のカード指定文字が不正です。（J10）"]
      #     expect(response).to render_template(:check)
      #   end
      # end

      context "正常な場合" do
       it "役とスコアの配列を返す、checkページにrenderする" do
         post :check, {cards:"S6 S7 S13 S4 S9"}
         expect(:hand_and_score).to be_truthy
         expect(:hand).to be_truthy
         # expect(controller.instance_variable_get("@hand_and_score")).to eq ["フラッシュ",6]
         # expect(controller.instance_variable_get("@hand")).to eq "フラッシュ"
         expect(response).to render_template(:check)
       end
      end

    end
  end
