require "rails_helper"

RSpec.describe "Poker", type: :request do
  context "エラーが入ってる場合" do
    it "エラーを出す" do
        post "/api/poker", {api_cards:["S6 S7 S13 S10 S10","C13 D12 C11 H8 H7","C13 D12 C11 H8",""]}
      body = JSON.parse(response.body)
      expect(body).to eq [
    {
        "card" => "S6 S7 S13 S10 S10",
        "error" => "カードに重複があります。"
    },
    {
        "card" => "C13 D12 C11 H8 H7",
        "hand" => "ハイカード",
        "score" => 1
    },
    {
        "card" => "C13 D12 C11 H8",
        "error" => "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
    },
    {
        "card" => "",
        "error" => "カードを入力してください。"
    }
]
    end
  end
  context "正常の場合" do
  it "役と強さを出す" do
      post "/api/poker", {api_cards:["S6 S7 S13 S10 S1","C13 D12 C11 H10 H9","C13 D12 C11 H8 H7"]}
    body = JSON.parse(response.body)
    expect(body).to eq [
    {
        "card" => "S6 S7 S13 S10 S1",
        "hand" => "フラッシュ",
        "score" => 6,
        "best" => true
    },
    {
        "card" => "C13 D12 C11 H10 H9",
        "hand" => "ストレート",
        "score" => 5,
        "best" => false
    },
    {
        "card" => "C13 D12 C11 H8 H7",
        "hand" => "ハイカード",
        "score" => 1,
        "best" => false
    }
]
end
end
end