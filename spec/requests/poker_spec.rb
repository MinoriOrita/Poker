require "rails_helper"

RSpec.describe "Poker", type: :request do
  context "エラーと正常が含まれている場合" do
    it "エラー・役を出す" do
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
  context "すべてエラー" do
    it "エラーを出す" do
      post "/api/poker", {api_cards:["　C13 D12 C11 H3 S5","C13 D12 C11 H8","","C13 D12 C11 H8 H"]}
      body = JSON.parse(response.body)
      expect(body).to eq [
    {
        "card" => "　C13 D12 C11 H3 S5",
        "error" => "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
    },
    {
        "card" => "C13 D12 C11 H8",
        "error" => "5つのカードを半角英数字を使って半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
    },
    {
        "card" => "",
        "error" => "カードを入力してください。"
    },
    {
        "card" => "C13 D12 C11 H8 H",
        "error" => "5番目のカード指定文字が不正です。（H）"
    }
]
    end
  end
  context "すべて正常で、役の強さが同じものがある場合" do
    it "役と強さを出す" do
      post "/api/poker", {api_cards:[ "C13 D12 C11 H3 S5", "C13 D12 C11 H8 H9","D9 D8 D7 D10 D4", "C13 D12 C11 H10 H9"]}
      body = JSON.parse(response.body)
      expect(body).to eq [
      {
          "card" => "C13 D12 C11 H3 S5",
          "hand" => "ハイカード",
          "score" => 1,
          "best" => false
      },
      {
          "card" => "C13 D12 C11 H8 H9",
          "hand" => "ハイカード",
          "score" => 1,
          "best" => false
      },
      {
          "card" => "D9 D8 D7 D10 D4",
          "hand" => "フラッシュ",
          "score" => 6,
          "best" => true
      },
      {
          "card" => "C13 D12 C11 H10 H9",
          "hand" => "ストレート",
          "score" => 5,
          "best" => false
      }
      ]
    end
  end

context "すべて正常で、役の強さが全部同じ場合" do
  it "役と強さを出す" do
    post "/api/poker", {api_cards:["C13 D12 C11 H3 S5","C13 D12 C11 H8 H9","D9 D8 D7 H10 S4","C13 D12 C11 H8 H10"]}
    body = JSON.parse(response.body)
    expect(body).to eq [
    {
        "card" => "C13 D12 C11 H3 S5",
        "hand" => "ハイカード",
        "score" => 1,
        "best" => true
    },
    {
        "card" => "C13 D12 C11 H8 H9",
        "hand" => "ハイカード",
        "score" => 1,
        "best" => true
    },
    {
        "card" => "D9 D8 D7 H10 S4",
        "hand" => "ハイカード",
        "score" => 1,
        "best" => true
    },
    {
        "card" => "C13 D12 C11 H8 H10",
        "hand" => "ハイカード",
        "score" => 1,
        "best" => true
    }
]
  end
end


  context "すべて正常で、役の強さが全て違う場合" do
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
