class Site < ActiveRecord::Base
	belongs_to :ds_output
	belongs_to :genome

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

	def find_hydrolyzed_base
		if self.ds_output.feature.strand == "+"
			hb = self.hb_codon[self.c_value - 1]
		elsif self.ds_output.feature.strand == "-"
			hb = reverse_complement(self.hb_codon)[self.c_value - 1]
		end
	end

	def find_codon
		if self.ds_output_id != nil and self.ds_output.feature != nil and self.ds_output.feature.strand == "+" and self.ds_output.loop_seq.first == "G"
			if r_value == 0 
				if self.loop_seq == "GAGG" or self.loop_seq == "GTGG"
					codon = self.loop_plus_two.first(3)
				elsif self.loop_seq = "GAGA"
					codon = self.loop_seq.last(3)
				end
			elsif r_value == 1
				if self.loop_seq == "GAGG" or self.loop_seq == "GTGG"
					codon = self.loop_seq.first(3)
				elsif self.loop_seq = "GAGA"
					codon = self.loop_seq.first(3)
				end
			elsif r_value == 2
				if self.loop_seq == "GAGG" or self.loop_seq == "GTGG"
					codon = self.loop_plus_one.first(3)
				elsif self.loop_seq = "GAGA"
					codon = self.loop_plus_one.first(3)
				end
			end
		elsif self.ds_output_id != nil and self.ds_output.feature != nil and self.ds_output.feature.strand == "-" and self.ds_output.loop_seq.first == "G"
			if r_value == 0 
				if self.loop_seq == "GAGG" or self.loop_seq == "GTGG"
					codon = reverse_complement(self.loop_seq.first(3))
				elsif self.loop_seq = "GAGA"
					codon = reverse_complement(self.loop_seq.first(3))
				end
			elsif r_value == 1
				if self.loop_seq == "GAGG" or self.loop_seq == "GTGG"
					codon = reverse_complement(self.loop_plus_two.first(3))
				elsif self.loop_seq = "GAGA"
					codon = reverse_complement(self.loop_seq.last(3))
				end
			elsif r_value == 2
				if self.loop_seq == "GAGG" or self.loop_seq == "GTGG"
					codon = reverse_complement(self.loop_plus_one.first(3))
				elsif self.loop_seq = "GAGA"
					codon = reverse_complement(self.loop_plus_one.first(3))
				end
			end
		elsif self.ds_output_id != nil and self.ds_output.feature != nil and self.ds_output.feature.strand == "+" and (self.ds_output.loop_seq.first == "C" or self.ds_output.loop_seq.first == "T")
			if r_value == 0 
				if self.ds_output.loop_seq == "CCTC" or self.ds_output.loop_seq == "CCAC"
					codon = self.ds_output.loop_seq.last(3)
				elsif self.ds_output.loop_seq = "TCTC"
					codon = self.ds_output.loop_seq.last(3)
				end
			elsif r_value == 1
				if self.ds_output.loop_seq == "CCTC" or self.ds_output.loop_seq == "CCAC"
					codon = self.ds_output.loop_plus_two.last(3)
				elsif self.ds_output.loop_seq = "TCTC"
					codon = self.loop_seq.first(3)
				end
			elsif r_value == 2
				if self.ds_output.loop_seq == "CCTC" or self.ds_output.loop_seq == "CCAC"
					codon = self.ds_output.loop_plus_one.last(3)
				elsif self.ds_output.loop_seq = "TCTC"
					codon = self.ds_output.loop_plus_one.last(3)
				end
			end
		elsif self.ds_output_id != nil and self.ds_output.feature != nil and self.ds_output.feature.strand == "-" and (self.ds_output.loop_seq.first == "C" or self.ds_output.loop_seq.first == "T")
			if r_value == 0 
				if self.ds_output.loop_seq == "CCTC" or self.ds_output.loop_seq == "CCAC"
					codon = reverse_complement(self.ds_output.loop_plus_two.last(3))
				elsif self.ds_output.loop_seq = "TCTC"
					codon = reverse_complement(self.ds_output.loop_seq.first(3))
				end
			elsif r_value == 1
				if self.ds_output.loop_seq == "CCTC" or self.ds_output.loop_seq == "CCAC"
					codon = reverse_complement(self.ds_output.loop_seq.last(3))
				elsif self.ds_output.loop_seq = "TCTC"
					codon = reverse_complement(self.ds_output.loop_seq.last(3))
				end
			elsif r_value == 2
				if self.ds_output.loop_seq == "CCTC" or self.ds_output.loop_seq == "CCAC"
					codon = reverse_complement(self.ds_output.loop_plus_one.last(3))
				elsif self.ds_output.loop_seq = "TCTC"
					codon = reverse_complement(self.ds_output.loop_plus_one.last(3))
				end
			end
		end

		self.update_attributes(hb_codon: codon)

	end

	def find_degeneracy
		if self.hb_codon != nil and self.ds_output.feature.strand == "+"

			if c_value == 1
				#turns "GAG" into [G, A, G]
				deg = 0
				true_amino_acid = Codon.find_by_symbol(self.hb_codon).amino_acid
				chars = self.hb_codon.chars.to_a
				#ASSUMES .CODON.amino_acid FUNCTION CAN GIVE THE AMINO ACID
				chars[0] = "G"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

				chars[0] = "T"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

				chars[0] = "C"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

				chars[0] = "A"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

			elsif c_value == 2

				deg = 0
				true_amino_acid = Codon.find_by_symbol(self.hb_codon).amino_acid
				chars = self.hb_codon.chars.to_a
				#ASSUMES .CODON.amino_acid FUNCTION CAN GIVE THE AMINO ACID
				chars[1] = "G"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

				chars[1] = "T"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

				chars[1] = "C"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

				chars[1] = "A"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end


			elsif c_value == 3

				deg = 0
				true_amino_acid = Codon.find_by_symbol(self.hb_codon).amino_acid
				chars = self.hb_codon.chars.to_a
				#ASSUMES .CODON.amino_acid FUNCTION CAN GIVE THE AMINO ACID
				chars[2] = "G"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

				chars[2] = "T"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

				chars[2] = "C"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

				chars[2] = "A"
				if Codon.find_by_symbol(chars.join).amino_acid == true_amino_acid
					deg = deg + 1
				end

			end

			synonymous = deg - 1
			non_synonymous = 3 - (deg - 1)

			return [synonymous, non_synonymous] 

		end
			


	end


end
