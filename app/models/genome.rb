class Genome < ActiveRecord::Base
	has_many :genes
	has_many :stem_loops
	has_many :sites

	def import_genome(file)
		f = File.open(file)
		lines = f.readlines
		values = lines.split("\r")
		
	end
end
