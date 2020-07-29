module HashtagHelper

  def hashtag_sentence(sentence)
    sentence.split(" ").reject{ |word| word == "-"}.map(&:capitalize).unshift("#").join
  end

end