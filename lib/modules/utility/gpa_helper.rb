module Utility
  class GPAHelper

    def self.gpa(score)
      gpa = nil
      if score >= 3.5 and score <= 4.0
        gpa = 'A'
      elsif score >= 2.5 and score < 3.5
        gpa = 'B'
      elsif score >= 1.5 and score < 2.5
        gpa = 'C'
      elsif score >= 0.5 and score < 1.5
        gpa = 'D'
      elsif score >= 0 and score < 0.5
        gpa = 'F'
      end unless score.nil?
      gpa
    end

  end

end