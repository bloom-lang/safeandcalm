require 'rubygems'
require 'bud'

class Counters
	include Bud

	state do
		lmap :cell
		lbool :safety
		scratch :out, [:key]=>[:cnt, :val]
	end

	bootstrap do
		cell <= {1 => Bud::MaxLattice.new(18)}
		safety <= false
	end

	bloom do
		# increment is a monotone function of ctr.cnt
		cell <+ {1 => cell.at(1)+1}

		safety <= cell.at(1, Bud::MaxLattice).gt(18)

		out <= [[1, cell.at(1), safety]]
		stdio <~ out.inspected
	end
end

c=Counters.new
c.tick
c.tick
c.tick