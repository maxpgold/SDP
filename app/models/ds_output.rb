class DsOutput < ActiveRecord::Base
	has_one :site
	has_many :ds_output_genes
	has_many :genes, :through => :ds_output_genes
	belongs_to :feature
	belongs_to :human_gene

	def self.import_excel(source)
		file = File.open(source)
		lines = file.readlines
		#found on internet as a way to take in CSV and make it readable
		rows = lines.first.encode("UTF-8", "binary", :invalid => :replace, :undef => :replace, :replace => " ")
		values = rows.split("\r")
		values.each do |v|
			a = v.scan(/\d+|[a-zA-Z]+/)
			unless a == []
				if a.include? "complement"
					DsOutput.create(
						sequence: a[10],
						loop_plus_two: a[17],
						loop_plus_one: a[16],
						loop_seq: a[15],
						loop_start_position: a[0],
						strength: a[4],
						site_type: a[1]
						)
				else
					if a[11] == "x"
					DsOutput.create(
						sequence: a[10],
						loop_plus_two: a[14],
						loop_plus_one: a[13],
						loop_seq: a[12],
						loop_start_position: a[0],
						strength: a[4],
						site_type: a[1]
						)
					else
					DsOutput.create(
						sequence: a[10],
						loop_plus_two: a[16],
						loop_plus_one: a[15],
						loop_seq: a[14],
						loop_start_position: a[0],
						strength: a[4],
						site_type: a[1]
						)
					end
				end
			end
		end
	end

	def assign_loop_seq
		seq = self.sequence
		gtgg = seq.split("GTGG")
		gagg = seq.split("GAGG")
		gaga = seq.split("GAGA")
		cctc = seq.split("CCTC")
		ccac = seq.split("CCAC")
		tctc = seq.split("TCTC")
		p = [0, 1]

		if gtgg[0] != nil and gtgg[1] != nil and p.include? (gtgg[0].length - gtgg[1].length).abs
			self.update_attributes(
				loop_plus_two: gtgg[0].last(2) + "GTGG" + gtgg[1].first(2),
				loop_plus_one: gtgg[0].last(1) + "GTGG" + gtgg[1].first(1),
				loop_seq: "GTGG"
			)
		elsif gagg[0] != nil and gagg[1] != nil and p.include? (gagg[0].length - gagg[1].length).abs
			self.update_attributes(
				loop_plus_two: gagg[0].last(2) + "GAGG" + gagg[1].first(2),
				loop_plus_one: gagg[0].last(1) + "GAGG" + gagg[1].first(1),
				loop_seq: "GAGG"
			)
		elsif gaga[0] != nil and gaga[1] != nil and p.include? (gaga[0].length - gaga[1].length).abs
			self.update_attributes(
				loop_plus_two: gaga[0].last(2) + "GAGA" + gaga[1].first(2),
				loop_plus_one: gaga[0].last(1) + "GAGA" + gaga[1].first(1),
				loop_seq: "GAGA"
			)
		elsif cctc[0] != nil and cctc[1] != nil and p.include? (cctc[0].length - cctc[1].length).abs
			self.update_attributes(
				loop_plus_two: cctc[0].last(2) + "CCTC" + cctc[1].first(2),
				loop_plus_one: cctc[0].last(1) + "CCTC" + cctc[1].first(1),
				loop_seq: "CCTC"
			)	

		elsif ccac[0] != nil and ccac[1] != nil and p.include? (ccac[0].length - ccac[1].length).abs
			self.update_attributes(
				loop_plus_two: ccac[0].last(2) + "CCAC" + ccac[1].first(2),
				loop_plus_one: ccac[0].last(1) + "CCAC" + ccac[1].first(1),
				loop_seq: "CCAC"
			)

		elsif tctc[0] != nil and tctc[1] != nil and p.include? (tctc[0].length - tctc[1].length).abs
			self.update_attributes(
				loop_plus_two: tctc[0].last(2) + "TCTC" + tctc[1].first(2),
				loop_plus_one: tctc[0].last(1) + "TCTC" + tctc[1].first(1),
				loop_seq: "TCTC"
			)		
		end
	end

	def assign_rest_loop_seq
		seq = self.sequence
		gtgg = seq.rpartition("GTGG")
		gagg = seq.rpartition("GAGG")
		gaga = seq.rpartition("GAGA")
		cctc = seq.rpartition("CCTC")
		ccac = seq.rpartition("CCAC")
		tctc = seq.rpartition("TCTC")
		p = [0, 1]

		if gtgg[0] != nil and gtgg[2] != nil and p.include? (gtgg[0].length - gtgg[2].length).abs
			self.update_attributes(
				loop_plus_two: gtgg[0].last(2) + "GTGG" + gtgg[2].first(2),
				loop_plus_one: gtgg[0].last(1) + "GTGG" + gtgg[2].first(1),
				loop_seq: "GTGG"
			)
		elsif gagg[0] != nil and gagg[2] != nil and p.include? (gagg[0].length - gagg[2].length).abs
			self.update_attributes(
				loop_plus_two: gagg[0].last(2) + "GAGG" + gagg[2].first(2),
				loop_plus_one: gagg[0].last(1) + "GAGG" + gagg[2].first(1),
				loop_seq: "GAGG"
			)
		elsif gaga[0] != nil and gaga[2] != nil and p.include? (gaga[0].length - gaga[2].length).abs
			self.update_attributes(
				loop_plus_two: gaga[0].last(2) + "GAGA" + gaga[2].first(2),
				loop_plus_one: gaga[0].last(1) + "GAGA" + gaga[2].first(1),
				loop_seq: "GAGA"
			)
		elsif cctc[0] != nil and cctc[2] != nil and p.include? (cctc[0].length - cctc[2].length).abs
			self.update_attributes(
				loop_plus_two: cctc[0].last(2) + "CCTC" + cctc[2].first(2),
				loop_plus_one: cctc[0].last(1) + "CCTC" + cctc[2].first(1),
				loop_seq: "CCTC"
			)	

		elsif ccac[0] != nil and ccac[2] != nil and p.include? (ccac[0].length - ccac[2].length).abs
			self.update_attributes(
				loop_plus_two: ccac[0].last(2) + "CCAC" + ccac[2].first(2),
				loop_plus_one: ccac[0].last(1) + "CCAC" + ccac[2].first(1),
				loop_seq: "CCAC"
			)

		elsif tctc[0] != nil and tctc[2] != nil and p.include? (tctc[0].length - tctc[2].length).abs
			self.update_attributes(
				loop_plus_two: tctc[0].last(2) + "TCTC" + tctc[2].first(2),
				loop_plus_one: tctc[0].last(1) + "TCTC" + tctc[2].first(1),
				loop_seq: "TCTC"
			)		
		end
		
	end

	def self.import_text(source)
		file = File.open(source)
		lines = file.readlines.map{|m| m.chomp}
		lines.delete("")
		lines.each do |l|
			a = l.scan(/\d+|[a-zA-Z]+/)
			DsOutput.create(
				loop_start_position: a[0],
				strength: a[4],
				site_type: a[1],
				sequence: a[10],
				genome_id: 18
				)
		end
	end

	def find_r
		if self.feature_id != nil
			d = (self.loop_start_position - Feature.find(self.feature_id).start_position).abs + 1
			r = d%3
			self.update_attributes(:r_value => r)
		end
	end

	  def make_cdna_name
    t = self.gene.transcripts.select{|m| m.canonical == true}.first
    f = t.features
    mf = f.select{|l| (l.start_position..l.stop_position).cover?(self.start_position)}
    # ep = mf.exon_position.to_i
    if self.gene.strand == 1
      dist = (self.start_position - t.coding_start)
      start_exon = f.select{|k| (k.start_position..k.stop_position).cover?(t.coding_start)}.first.exon_position
      intron_features = f.select{|m| m.exon_position <= mf.first.exon_position}.sort_by{|l| l.exon_position}
      sum_array = []
      (start_exon..intron_features.count-1).each do |a|
        sum_array.push((intron_features[a].start_position - intron_features[a-1].stop_position).abs)
      end
      cdna_pos = dist.to_i - (sum_array.sum).to_i
      name = "c." + cdna_pos.to_s + "#{self.wildtype_allele}>#{self.mutant_allele}"
    elsif self.gene.strand == -1
      #dist is coding_stop - end_position + 1, but not exactly sure why 
      #it may be due to the difference between how coding_start and coding_stop positions are calculated
      dist = (t.coding_stop - self.end_position + 1)
      start_exon = f.select{|k| (k.start_position..k.stop_position).cover?(t.coding_stop)}.first.exon_position
      intron_features = f.select{|m| m.exon_position <= mf.first.exon_position}.sort_by{|l| l.exon_position}
      sum_array = []
      (start_exon..intron_features.count-1).each do |a|
        #for - strand, look at start_position of lower exon (higher genomic position) and substract stop_position of higher exon (lower genomic coordinate)
        sum_array.push((intron_features[a-1].start_position - intron_features[a].stop_position).abs)
      end
      cdna_pos = dist.to_i - (sum_array.sum).to_i
      name = "c." + cdna_pos.to_s + "#{self.wildtype_allele}>#{self.mutant_allele}"
    end
    return name
  end

  def find_multi_feature_r
		t = self.human_gene.human_transcripts.first
		f = t.human_features
		mf = f.select{|l| (l.start_position..l.stop_position).cover?(self.loop_start_position)}

		if mf != []

			if self.human_gene.strand == 1
				dist = (self.loop_start_position - t.coding_start)
				start_exon = f.select{|k| (k.start_position..k.stop_position).cover?(t.coding_start)}.first.refseq_exon_position
				intron_features = f.select{|m| m.refseq_exon_position <= mf.first.refseq_exon_position}.sort_by{|l| l.refseq_exon_position}
				sum_array = []
				(start_exon..intron_features.count-1).each do |a|
	        sum_array.push((intron_features[a].start_position - intron_features[a-1].stop_position).abs)
	      end
	      cdna_pos = dist.to_i - (sum_array.sum).to_i
	      r = cdna_pos % 3

			elsif self.human_gene.strand == -1

	      dist = (t.coding_stop - self.loop_start_position + 1)
	      start_exon = f.select{|k| (k.start_position..k.stop_position).cover?(t.coding_stop)}.first.refseq_exon_position
	      intron_features = f.select{|m| m.refseq_exon_position <= mf.first.refseq_exon_position}.sort_by{|l| l.refseq_exon_position}
	      sum_array = []
	      (start_exon..intron_features.count-1).each do |a|
	        #for - strand, look at start_position of lower exon (higher genomic position) and substract stop_position of higher exon (lower genomic coordinate)
	        sum_array.push((intron_features[a-1].start_position - intron_features[a].stop_position).abs)
	      end
	      cdna_pos = dist.to_i - (sum_array.sum).to_i
	      r = cdna_pos % 3
			end
		else 
			return nil
		end

		self.update_attributes(r_value: r)

  end

	def fer
		t = self.human_gene.human_transcripts.first
		f = t.human_features
		mf = f.select{|l| (l.start_position..l.stop_position).cover?(self.loop_start_position)}

		if mf != []

			if self.human_gene.strand == 1
				dist = (self.loop_start_position - t.coding_start)
				start_exon = f.select{|k| (k.start_position..k.stop_position).cover?(t.coding_start)}.first.refseq_exon_position
				intron_features = f.select{|m| m.refseq_exon_position <= mf.first.refseq_exon_position}.sort_by{|l| l.refseq_exon_position}
				sum_array = []
				(start_exon..intron_features.count-1).each do |a|
	        sum_array.push((intron_features[a].start_position - intron_features[a-1].stop_position).abs)
	      end
	      cdna_pos = dist.to_i - (sum_array.sum).to_i
	      r = cdna_pos % 3

			elsif self.human_gene.strand == -1

	      dist = (t.coding_stop - self.loop_start_position + 1)
	      start_exon = f.select{|k| (k.start_position..k.stop_position).cover?(t.coding_stop)}.first.refseq_exon_position
	      intron_features = f.select{|m| m.refseq_exon_position <= mf.first.refseq_exon_position}.sort_by{|l| l.refseq_exon_position}
	      sum_array = []
	      (start_exon..intron_features.count-1).each do |a|
	        #for - strand, look at start_position of lower exon (higher genomic position) and substract stop_position of higher exon (lower genomic coordinate)
	        sum_array.push((intron_features[a-1].start_position - intron_features[a].stop_position).abs)
	      end
	      cdna_pos = dist.to_i - (sum_array.sum).to_i
	      r = cdna_pos % 3
			end
		else 
			return nil
		end

		self.update_attributes(r_value: r)

	end

	def link_human_gene
		hg = HumanGene.joins(:human_transcripts).where("human_genes.start_position < #{self.loop_start_position} and human_genes.stop_position > #{self.loop_start_position}").first
		if hg
			self.update_attributes(human_gene_id: hg.id)
		end
	end

	def reverse_complement(string)
		array = string.scan(/\w/)
		comp = array.map do |a|
			if a.upcase == "T"
				"A"
			elsif a.upcase == "A"
				"T"
			elsif a.upcase == "C"
				"G"
			elsif a.upcase == "G"
				"C"
			elsif a == "+"
				"-"
			elsif a == "-"
				"+"
			end
		end
		rev_comp = comp.reverse.join("")
		return rev_comp
	end

	def update_genome_id
		self.update_attributes(genome_id: self.genes.first.id)
		
	end

	def make_sites
		if self.loop_seq == "CCTC" or self.loop_seq == "CCAC"
			a = Site.create(
				loop_plus_two: reverse_complement(self.loop_plus_two),
				loop_plus_one: reverse_complement(self.loop_plus_one),
				loop_seq: reverse_complement(self.loop_seq),
				loop_start_position: self.loop_start_position,
				strength: self.strength,
				r_value: self.r_value,
				sequence: reverse_complement(self.sequence),
				ds_output_id: self.id,
				genome_id: self.genome_id
				# if self.genes != []
				# 	strand: reverse_complement(self.genes.first.strand)
				# end
				)

			if self.r_value == 1 
				a.update_attributes(c_value: 1)
			elsif self.r_value == 2
				a.update_attributes(c_value: 2)
			elsif self.r_value == 0
				a.update_attributes(c_value: 3)
			end

		elsif self.loop_seq == "TCTC"
			b = Site.create(
				loop_plus_two: reverse_complement(self.loop_plus_two),
				loop_plus_one: reverse_complement(self.loop_plus_one),
				loop_seq: reverse_complement(self.loop_seq),
				loop_start_position: self.loop_start_position,
				strength: self.strength,
				r_value: self.r_value,
				sequence: reverse_complement(self.sequence),
				ds_output_id: self.id,
				genome_id: self.genome_id
				# if self.genes != []
				# 	strand: reverse_complement(self.genes.first.strand)
				# end
				)
			if self.genes != []
				if self.genes.first.strand == "+"
					if self.r_value == 0 
						b.update_attributes(c_value: 2)
					elsif self.r_value == 1
						b.update_attributes(c_value: 3)
					elsif self.r_value == 2
						b.update_attributes(c_value: 1)
					end
				elsif self.genes.first.strand == "-"
					b.update_attributes(c_value: self.r_value + 1)
				end
			end

		elsif self.loop_seq == "GAGG" or self.loop_seq == "GTGG"

			c = Site.create(
				loop_plus_two: self.loop_plus_two,
				loop_plus_one: self.loop_plus_one,
				loop_seq: self.loop_seq,
				loop_start_position: self.loop_start_position,
				strength: self.strength,
				r_value: self.r_value,
				sequence: self.sequence,
				ds_output_id: self.id,
				genome_id: self.genome_id
				# if self.genes != []
				# 	strand: self.genes.first.strand
				# end
				)

				if self.r_value == 1 
					c.update_attributes(c_value: 1)
				elsif self.r_value == 2
					c.update_attributes(c_value: 2)
				elsif self.r_value == 0
					c.update_attributes(c_value: 3)
				end

		elsif self.loop_seq == "GAGA"	

			d = Site.create(
					loop_plus_two: self.loop_plus_two,
					loop_plus_one: self.loop_plus_one,
					loop_seq: self.loop_seq,
					loop_start_position: self.loop_start_position,
					strength: self.strength,
					r_value: self.r_value,
					sequence: self.sequence,
					ds_output_id: self.id,
					genome_id: self.genome_id
					# if self.genes != []
					# 	strand: self.genes.first.strand
					# end
					)

		# + and - strand are switched here from the TCTC
			if self.genes != []
				if self.genes.first.strand == "-"
					if self.r_value == 0 
						d.update_attributes(c_value: 2)
					elsif self.r_value == 1
						d.update_attributes(c_value: 3)
					elsif self.r_value == 2
						d.update_attributes(c_value: 1)
					end
				elsif self.genes.first.strand == "+"
					d.update_attributes(c_value: self.r_value + 1)
				end	
			end	

		end
		
	end


	def make_human_sites
		if self.loop_seq == "CCTC" or self.loop_seq == "CCAC"
			a = Site.create(
				loop_plus_two: reverse_complement(self.loop_plus_two),
				loop_plus_one: reverse_complement(self.loop_plus_one),
				loop_seq: reverse_complement(self.loop_seq),
				loop_start_position: self.loop_start_position,
				strength: self.strength,
				r_value: self.r_value,
				sequence: reverse_complement(self.sequence),
				ds_output_id: self.id,
				genome_id: self.genome_id
				# if self.genes != []
				# 	strand: reverse_complement(self.genes.first.strand)
				# end
				)

			if self.r_value == 1 
				a.update_attributes(c_value: 1)
			elsif self.r_value == 2
				a.update_attributes(c_value: 2)
			elsif self.r_value == 0
				a.update_attributes(c_value: 3)
			end

		elsif self.loop_seq == "TCTC"
			b = Site.create(
				loop_plus_two: reverse_complement(self.loop_plus_two),
				loop_plus_one: reverse_complement(self.loop_plus_one),
				loop_seq: reverse_complement(self.loop_seq),
				loop_start_position: self.loop_start_position,
				strength: self.strength,
				r_value: self.r_value,
				sequence: reverse_complement(self.sequence),
				ds_output_id: self.id,
				genome_id: self.genome_id
				# if self.genes != []
				# 	strand: reverse_complement(self.genes.first.strand)
				# end
				)
			if self.human_gene != []
				if self.human_gene.strand == 1
					if self.r_value == 0 
						b.update_attributes(c_value: 2)
					elsif self.r_value == 1
						b.update_attributes(c_value: 3)
					elsif self.r_value == 2
						b.update_attributes(c_value: 1)
					end
				elsif self.human_gene.strand == -1
					b.update_attributes(c_value: self.r_value + 1)
				end
			end

		elsif self.loop_seq == "GAGG" or self.loop_seq == "GTGG"

			c = Site.create(
				loop_plus_two: self.loop_plus_two,
				loop_plus_one: self.loop_plus_one,
				loop_seq: self.loop_seq,
				loop_start_position: self.loop_start_position,
				strength: self.strength,
				r_value: self.r_value,
				sequence: self.sequence,
				ds_output_id: self.id,
				genome_id: self.genome_id
				# if self.genes != []
				# 	strand: self.genes.first.strand
				# end
				)

				if self.r_value == 1 
					c.update_attributes(c_value: 1)
				elsif self.r_value == 2
					c.update_attributes(c_value: 2)
				elsif self.r_value == 0
					c.update_attributes(c_value: 3)
				end

		elsif self.loop_seq == "GAGA"	

			d = Site.create(
					loop_plus_two: self.loop_plus_two,
					loop_plus_one: self.loop_plus_one,
					loop_seq: self.loop_seq,
					loop_start_position: self.loop_start_position,
					strength: self.strength,
					r_value: self.r_value,
					sequence: self.sequence,
					ds_output_id: self.id,
					genome_id: self.genome_id
					# if self.genes != []
					# 	strand: self.genes.first.strand
					# end
					)

		# + and - strand are switched here from the TCTC
			if self.human_gene != []
				if self.human_gene.strand == -1
					if self.r_value == 0 
						d.update_attributes(c_value: 2)
					elsif self.r_value == 1
						d.update_attributes(c_value: 3)
					elsif self.r_value == 2
						d.update_attributes(c_value: 1)
					end
				elsif self.human_gene.strand == 1
					d.update_attributes(c_value: self.r_value + 1)
				end	
			end	

		end
		
	end


end
