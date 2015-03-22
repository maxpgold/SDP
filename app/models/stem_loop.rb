class StemLoop < ActiveRecord::Base
	belongs_to :genome
	belongs_to :feature
	belongs_to :gene

	def self.import_loops(file)
		f = File.open(file)
		lines = f.readlines
		rows = lines.map{|m| m.chomp}
		rows.each do |a|
			l = a.scan(/\d+|[a-zA-Z]+/)
			StemLoop.create(
				:loop_start_position => l[0].to_i,
				:strength => l[4].to_i,
				:genome_id => 6
				)
		end
	end

	def link_to_gene

		g1 = Gene.where(genome_id: self.genome_id, strand: "+").where("start_position <= #{self.loop_start_position} AND end_position >= #{self.loop_start_position}").first
		g2 = Gene.where(genome_id: self.genome_id, strand: "-").where("start_position >= #{self.loop_start_position} AND end_position <= #{self.loop_start_position}").first
		
		if g1 and g2 == nil
			self.update_attributes(gene_id: g1.id)
		elsif g2 and g1 == nil
			self.update_attributes(gene_id: g2.id)
		end
	end

	def link_to_feature
		if self.gene_id != nil
			gene = Gene.find(self.gene_id)
			features = Feature.where(gene_id: gene.id)
			features.each do |a|
				if a.strand = "+" and a.start_position <= self.loop_start_position and a.end_position >= self.loop_start_position
					self.update_attributes(feature_id: a.id)
				elsif a.strand = "-" and a.start_position >= self.loop_start_position and a.end_position <= self.loop_start_position
					self.update_attributes(feature_id: a.id)
				end
			end
		end
	end

	def find_r
		if self.feature_id != nil
			d = (self.loop_start_position - Feature.find(self.feature_id).start_position).abs + 1
			r = d%3
			self.update_attributes(:r_value => r)
		end
	end

  def find_multi_feature_r
  	g = self.gene
  	f = g.features

  	if g.strand == "+"
  		mf = f.select{|l| (l.start_position..l.end_position).cover?(self.loop_start_position)}
  	elsif g.strand == "-"
  		mf = f.select{|l| (l.end_position..l.start_position).cover?(self.loop_start_position)}
  	end

		if mf != []

			if self.gene.strand == "+"
				dist = (self.loop_start_position - g.start_position)
				start_exon = f.sort_by{|m| m.start_position}.first
				intron_features = f.select{|m| m.start_position <= mf.first.start_position}

				sum_array = []
				(1..intron_features.count-1).each do |a|
	        sum_array.push((intron_features[a].start_position - intron_features[a-1].end_position).abs)
	      end
	      cdna_pos = dist.to_i - (sum_array.sum).to_i
	      r = cdna_pos % 3

			elsif self.gene.strand == "-"

				start_exon = f.sort_by{|m| m.start_position}.last
				dist = (start_exon.start_position - self.loop_start_position)

				intron_features = f.select{|m| m.end_position >= mf.first.end_position}

	      sum_array = []
	      (1..intron_features.count-1).each do |a|
	        #for - strand, look at start_position of lower exon (higher genomic position) and substract stop_position of higher exon (lower genomic coordinate)
	       	sum_array.push((intron_features[a].end_position - intron_features[a-1].start_position).abs)
	        #sum_array.push((intron_features[a-1].end_position - intron_features[a].start_position).abs)
	        #sum_array.push((intron_features[a-1].start_position - intron_features[a].end_position).abs)
	      end
	      cdna_pos = dist.to_i - (sum_array.sum).to_i
	      r = cdna_pos % 3
			end
		else 
			return nil
		end

		self.update_attributes(r_value: r)

  end



end
