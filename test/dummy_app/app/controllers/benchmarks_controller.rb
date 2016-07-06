require 'benchmark/ips'

class BenchmarksController < ApplicationController
  def index(n = '100')
    @comments = 1.upto(n.to_i).map {|i| Comment.new(i, nil, "comment #{i}")}

    jb = render_to_string 'index_jb'
    jbuilder = render_to_string 'index_jbuilder'
    raise 'jb != jbuilder' unless jb == jbuilder

    result = Benchmark.ips do |x|
      x.report('jb') { render_to_string 'index_jb' }
      x.report('jbuilder') { render_to_string 'index_jbuilder' }
      x.compare!
    end
    render plain: result.data.to_s
  end
end
