# Pulling & printing mediaFile assets from an account with a byAdded clause.
# Pulls the last 10 media that have been added to the account, as long as they have been added within the past 30 days.
# daniel.kraft@comcast.com

require 'cts/mpx'

username = 'mpx/Crackity.Jones@comcast.com'
password = 'crackityJones'
account = "http://access.auth.theplatform.com/data/Account/2189541263" # ID of the 'CIM New VMS Account'
service = 'Media Data Service'
endpoint = 'MediaFile'
return_fields = 'id,previousLocations,added'
range = '1-10'
start_search_time = Time.now.to_i * 1000; # Current epoch time in milliseconds
month_ms = 259_200_000 # 30 days in milliseconds
user = Cts::Mpx::User.create(username: username, password: password).sign_in

# Search everything in month preceding startSearchTime
added_q_string = (start_search_time - month_ms).to_s + "~" + start_search_time.to_s

puts "searching for #{added_q_string}"

# build our query, and immediately run it.

q = Cts::Mpx::Query.create(account: account, service: service, endpoint: endpoint, fields: return_fields, range: range, query: { byAdded: added_q_string, sort: 'added|desc' }).run user: user

# loop through each entry, print it's hash
q.entries.each do |asset|
  puts asset.to_h
end
user.sign_out
