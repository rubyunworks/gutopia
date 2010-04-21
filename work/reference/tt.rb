require 'benchmark'

include Benchmark

n = 100000

def a1
  a = 1
end

def a2
  a1
end

def a3
end

bm do |x|

  GC.start
  x.report("a1") { n.times { a1 } }

  GC.start
  x.report("a2") { n.times { a2 } }

  GC.start
  x.report("a=1") { n.times { a=1 } }
  
  GC.start
  x.report("a=1; a") { n.times { a=1; a } }

  GC.start
  x.report("a3") { n.times { a3 } }

  GC.start
  x.report("a3; a=1") { n.times { a3; a=1 } }

end