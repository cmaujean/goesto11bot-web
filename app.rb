require 'sinatra'
require 'tire'
require 'yajl'

get '/' do
  result = Tire.search('louds') do 
    query do 
      boolean do
        must { string 'score:[1 TO *]' }
      end
    end

    sort do
      by :_script => { :script => "random()", :type => "number", :order => "desc" }
    end
  end.results.first

  response["Content-Type"] = "application/json"
  return Yajl.dump(
    {
      "loud"    => result[:loud],
      "channel" => result[:channel],
      "network" => result[:network],
      "score"   => result[:score],
      "nick"    => result[:nick]
    }
  )
end
