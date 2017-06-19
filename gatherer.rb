require 'selenium-webdriver'
require 'csv'

driver = Selenium::WebDriver.for :firefox

measures = 0

CSV.open('C:\Users\plame\Desktop\FMI\Statlab\Gatherer\info.csv', "a+") do |csv|

while (measures < 500)
	element = []
    driver.navigate.to "http://www.forex.com/uk/trading-platforms/forextrader/live-spreads.html"
    sleep(5)
    element = driver.find_element(:id, 'liveSpread_1_content')
    text = element.text.split("\n")
    if text != ""
      csv << [text[2],text[18],text[27],text[31],text[47]]
      measures = measures + 1
    end
    p measures
    sleep(3600)
end

end

driver.quit


