module VachanasHelper

	def get_height_for_graph
		if @vachanakaaras.count > 10
			@vachanakaaras.count * 50
		elsif @vachanakaaras.count < 5
		    @vachanakaaras.count * 200
		else
			@vachanakaaras.count * 100
		end
	end
end
