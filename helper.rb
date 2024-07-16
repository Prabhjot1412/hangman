module Helper
  def lose_message(coded_value, total_score)
    puts "you lose, answer #{coded_value.value}"
    puts "your total score is #{total_score}"
    exit
  end

  def win_message(coded_value)
    puts "you won, it was: #{coded_value.value}"

    4.times do
      print '.'
      sleep 0.5
    end
  end
end