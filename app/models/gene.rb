class Gene < ActiveRecord::Base
	has_many :ds_output_genes
	has_many :ds_outputs, :through => :ds_output_genes
	belongs_to :genome
	has_many :features
	has_many :stem_loops

#copy and paste the whole genome from genbank
#use %w()
#split that array on "CDS"

# NEED TO REDO AND DEAL WITH JOIN((A..B)(C..D))
#also need to prepare for complement(join()(()))
	def self.import_genes(array)
		array.each do |a|
			unless a.first == "of" or a.first == "source"
				if a.first.scan(/\d+|[a-zA-Z]+/).include? "complement"
					if a.first.scan(/\d+|[a-zA-Z]+/).include? "join"
						f = Gene.create(
							start_position: a.first.scan(/\d+|[a-zA-Z]+/).last.to_i,
							end_position: a.first.scan(/\d+|[a-zA-Z]+/)[2].to_i,
							strand: "-",
							name: a.second.scan(/\d+|[a-zA-Z]+/)[1],
							genome_id: 17
						)
						if a.third.scan(/\d+|[a-zA-Z]+/)[1] == "Hypothetical"
							f.update_attributes(hypothetical: true)
						end
						a.first.delete("join").delete("complement").delete(")").delete("(").split(",").each do |x|
						Feature.create(
							start_position: x.split("..")[1].to_i,
							end_position: x.split("..")[0].to_i,
							strand: "-",
							feature_type: "exon",
							gene_id: f.id
							)
						end
					else
						f = Gene.create(
							start_position: a.first.scan(/\d+|[a-zA-Z]+/)[2].to_i,
							end_position: a.first.scan(/\d+|[a-zA-Z]+/)[1].to_i,
							strand: "-",
							name: a.second.scan(/\d+|[a-zA-Z]+/)[1],
							genome_id: 17
						)
						if a.third.scan(/\d+|[a-zA-Z]+/)[1] == "Hypothetical"
							f.update_attributes(hypothetical: true)
						end
						a.first.delete("join").delete("complement").delete(")").delete("(").split(",").each do |x|
						Feature.create(
							start_position: x.split("..")[1].to_i,
							end_position: x.split("..")[0].to_i,
							strand: "-",
							feature_type: "exon",
							gene_id: f.id
						)
						end
					end
				else
					if a.first.scan(/\d+|[a-zA-Z]+/).include? "join"
						f = Gene.create(
							start_position: a.first.scan(/\d+|[a-zA-Z]+/)[1].to_i,
							end_position: a.first.scan(/\d+|[a-zA-Z]+/).last.to_i,
							strand: "-",
							name: a.second.scan(/\d+|[a-zA-Z]+/)[1],
							genome_id: 17
						)
						if a.third.scan(/\d+|[a-zA-Z]+/)[1] == "Hypothetical"
							f.update_attributes(hypothetical: true)
						end
						a.first.delete("join").delete("complement").delete(")").delete("(").split(",").each do |x|
						Feature.create(
							start_position: x.split("..")[0].to_i,
							end_position: x.split("..")[1].to_i,
							strand: "+",
							feature_type: "exon",
							gene_id: f.id
						)
						end
					else
						f = Gene.create(
							start_position: a.first.scan(/\d+|[a-zA-Z]+/)[0].to_i,
							end_position: a.first.scan(/\d+|[a-zA-Z]+/)[1].to_i,
							strand: "+",
							name: a.second.scan(/\d+|[a-zA-Z]+/)[1],
							genome_id: 17
						)
						if a.third.scan(/\d+|[a-zA-Z]+/)[1] == "Hypothetical"
							f.update_attributes(hypothetical: true)
						end
						a.first.delete("join").delete("complement").delete(")").delete("(").split(",").each do |x|
						Feature.create(
							start_position: x.split("..")[0].to_i,
							end_position: x.split("..")[1].to_i,
							strand: "+",
							feature_type: "exon",
							gene_id: f.id
						)
						end
					end
				end
			end
		end
	end

	def link_ds
		if self.strand == "+"
			DsOutput.where(genome_id: self.genome_id, loop_start_position: self.start_position..self.end_position).all.each do |a|
				DsOutputGene.create(:gene_id => self.id, :ds_output_id => a.id)
			end
		elsif self.strand == "-"
			DsOutput.where(genome_id: self.genome_id, loop_start_position: self.end_position..self.start_position).all.each do |a| 
				DsOutputGene.create(:gene_id => self.id, :ds_output_id => a.id)
			end
		end
	end

end
