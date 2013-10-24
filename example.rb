require_relative 'whatpulse'

class Whatpulse < WhatpulseAPI

 	def printInfo
 		parsedUser = self.getUserData
 		puts "User: #{@user}"
 		puts "Total Keys: #{parsedUser["Keys"]}"
 		puts "Total Clicks: #{parsedUser["Clicks"]}"
 		ratio = sprintf('%.2f',(parsedUser["Keys"].gsub(/\,/, "").to_f / parsedUser["Clicks"].gsub(/\,/, "").to_f))
 		puts "Avg Key/Click Ratio: #{ratio}"
 		puts ''
 	end

 	def printPulses(dayshist = 1)
 		parsedPulses = self.getPulses
 		now = Date.today 		
 		dayshist.times do |n|
	 		totalKeysToday = 0
	 		totalClicksToday = 0
	 		pulseCountToday = 0
 			day = (now - n)
 			
	 		parsedPulses.each do |pulse|
	 			timeAdjusted = Time.parse(pulse[1]["Timedate"]) - (6 * 60 * 60) # Adjustment of 6 hours for timezone
				if timeAdjusted.to_s.match(/^#{day}/)
					pulseCountToday += 1
					totalKeysToday += removeFormat(pulse[1]["Keys"])
	 				totalClicksToday += removeFormat(pulse[1]["Clicks"])
	 			end
			end
			if totalKeysToday > 0
				puts "Day: #{day}"
				puts "Keys: #{self.addFormat(totalKeysToday)}"
				puts "Clicks: #{self.addFormat(totalClicksToday)}"
				ratio = sprintf('%.2f',(totalKeysToday.to_f / totalClicksToday.to_f))
				puts "Key/Click Ratio: #{ratio}"
				puts "Pulses: #{pulseCountToday}"
				puts ''
			end
		end
 	end

 	def adjustTime(datestring)
 		return (Time.parse(datestring) - (6 * 60 * 60)).to_s
 	end

 	def addFormat(num)
 		return num.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
 	end

 	def removeFormat(numString)
 		return numString.gsub(/\,/, "").to_i
 	end


end

if __FILE__ == $0

	puts "What username would you like to view?"
	username = gets.chomp
  wp = Whatpulse.new(username) # creates object
  wp.printInfo
	puts "How many days of history would you like to view?"
	days = gets.chomp.to_i
	wp.printPulses(days)
end