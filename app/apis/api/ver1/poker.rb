module API
  module Ver1
    class Poker < Grape::API
      format :json
      resource :poker do


        # GET /api/ver1/poker
        desc 'ポーカーの役を返す'
        # prefix 'poker/'
        params do
          requires :apiCards
        end

        post  do
          apiCards = params[:apiCards]
          array = []
          array_score = []
          apiCards.each do |card|
            hand = Hand.new(card)
            handAndScore = hand.hand()
            results = {"card" => card}
            results["hand"] = handAndScore[0]
            results["score"] = handAndScore[1]
           array << results
           array_score << handAndScore[1]
           end
           best = array_score.max
          array.each do |a|
           if a["score"] == best
             a["best"] = true
           else
             a["best"] = false
           end
           array
         end
         end
        end
      end
    end
  end
