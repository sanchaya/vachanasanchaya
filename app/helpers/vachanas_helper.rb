module VachanasHelper

	def get_height_for_graph
	if @vachanakaaras.count > 5
		@vachanakaaras.count * 40
else
@vachanakaaras.count * 100
end
	end
end
