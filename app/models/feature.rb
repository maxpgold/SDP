class Feature < ActiveRecord::Base
	belongs_to :gene
	has_many :ds_outputs
	has_many :stem_loops

	def link_to_ds_output
		if self.strand == "+"
			DsOutput.where(genome_id: self.gene.genome_id, loop_start_position: self.start_position..self.end_position).all.each do |a|
				a.update_attributes(:feature_id => self.id)
			end
		elsif self.strand == "-"
			DsOutput.where(genome_id: self.gene.genome_id, loop_start_position: self.end_position..self.start_position).all.each do |a| 
				a.update_attributes(:feature_id => self.id)
			end
		end
	end

	def populate_thirds
		if self.strand == "+"
			third = ((self.end_position - self.start_position)/ 3).to_i
			half = ((self.end_position - self.start_position) / 2).to_i
			self.update_attributes(first_third: self.start_position + third,
														 half: self.start_position + half,
														 second_third: self.start_position + 2*third)
		elsif self.strand == "-"
			third = ((self.start_position - self.end_position)/ 3).to_i
			half = ((self.start_position - self.end_position) / 2).to_i
			self.update_attributes(first_third: self.start_position - third,
														 half: self.start_position - half,
														 second_third: self.start_position - 2*third)
		end
			
	end

end
