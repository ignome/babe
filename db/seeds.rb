# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'net/http'
require 'nokogiri'

# create 100 users from weibo
url = 'http://weibo.com/p/1005051580291744/follow?relate=fans&page=2#place'

for page in 1..20 do
   target = url.sub /page=(\d+)/, "page=#{page}"

   page = Nokogiri::HTML(open(target), '', 'UTF-8')
   page.css('ul.cnfList li.S_line1').each do |li|
     name = li.css('div.name a')
   end
end