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

get '/dump' do
  dump_ary = []

  these_results = Tire.search('louds') do
    query do 
      all
    end
  end.results

  these_results = Tire.search('louds') do
    query do
      all
    end
    size these_results.total
  end.results

  these_results.each do |item|
    dump_ary.push(
      {
        "loud"    => item[:loud],
        "channel" => item[:channel],
        "nick"    => item[:nick],
        "score"   => item[:score]
      }
    )
  end

  response["Content-Type"] = "application/json"
  return Yajl.dump(dump_ary)
end
