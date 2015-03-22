class HumanGene < ActiveRecord::Base
	has_many :human_transcripts
	has_many :ds_outputs

	def self.import_human_genes(source)
		file = File.open(source)
		lines = file.readlines
		lines.each do |l|
			array = l.delete("\n").split("\t")
			HumanGene.create(
				old_id: array[0],
				symbol: array[1],
				start_position: array[2],
				stop_position: array[3],
				strand: array[4],
				chromosome_id: array[5]
				)
		end
	end


	def link_ds
		if self.strand == "1"
			DsOutput.where(genome_id: self.genome_id, loop_start_position: self.start_position..self.stop_position).select{|m| m.transcripts != nil}.first


			all.each do |a|
				DsOutputGene.create(:gene_id => self.id, :ds_output_id => a.id)
			end
		elsif self.strand == "-"
			DsOutput.where(genome_id: self.genome_id, loop_start_position: self.end_position..self.start_position).all.each do |a| 
				DsOutputGene.create(:gene_id => self.id, :ds_output_id => a.id)
			end
		end
	end

end
