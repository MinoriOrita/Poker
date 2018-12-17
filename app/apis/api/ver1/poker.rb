module API
  module Ver1
    class Poker < Grape::API
      format :json
      resource :poker do

        desc 'validation'
        params do
          requires :api_cards
        end

        desc "judge the hand"
        post do
          array = []
          array_score = []
          #カード群を受け取る
          api_cards = params[:api_cards]
          #それぞれのカードの役を判定する
          api_cards.each do |card|
            hand = Hand.new(card)
            results = {"card" => card}
            #バリデーション
            if hand.validate()
              errors = hand.validate()
              #エラー内容をハッシュに入れる
              errors.each do |error|
              results["error"] = error
              end
              #ハッシュを配列に入れる
              array << results
            else
              #正常な場合
              hand_and_score = hand.judge()
              #役を入れる
              results["hand"] = hand_and_score[0]
              #強さを表す数字（score）を入れる
              results["score"] = hand_and_score[1]
              #scoreだけの配列
              array_score << hand_and_score[1]
              #ハッシュを配列にいれる
              array << results
            end
          end
          #すべてのカードが正常な場合（カード郡の個数＝scoreの個数）
          if array_score.length == api_cards.length
            #数字（score）の一番大きいものをbestに入れる
           best = array_score.max
           #５枚セットそれぞれに対して、scoreが一番大きいか否かを判定する
           array.each do |a|
            if a["score"] == best
              a["best"] = true
            else
              a["best"] = false
            end
            # array  ←不要　　変更点
           end
          else
           array  #消すと、エラーver.がnilになりました
          end
        end
      end
    end
  end
end
