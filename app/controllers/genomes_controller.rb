class GenomesController < ApplicationController
  def index
  	@genomes = Genome.all
  end

  def show
  	@genome = Genome.find(params[:id])
  	@sites = @genome.sites.all
  	@stem_loops = @genome.stem_loops.all

  	#stem loop distribution
  	@stem_0 = @stem_loops.select{|m| m.r_value == 0}
  	@stem_1 = @stem_loops.select{|m| m.r_value == 1}
  	@stem_2 = @stem_loops.select{|m| m.r_value == 2}

  	@real_stem_0 = StemLoop.where(genome_id: @genome.id).where("stem_loops.r_value = 0 and stem_loops.feature_id in (select features.id from features inner join ds_outputs on features.id = ds_outputs.feature_id where ds_outputs.genome_id = '#{@genome.id}')")
  	@real_stem_1 = StemLoop.where(genome_id: @genome.id).where("stem_loops.r_value = 1 and stem_loops.feature_id in (select features.id from features inner join ds_outputs on features.id = ds_outputs.feature_id where ds_outputs.genome_id = '#{@genome.id}')")
  	@real_stem_2 = StemLoop.where(genome_id: @genome.id).where("stem_loops.r_value = 2 and stem_loops.feature_id in (select features.id from features inner join ds_outputs on features.id = ds_outputs.feature_id where ds_outputs.genome_id = '#{@genome.id}')")

  	#total sites
  	@real_sites = @sites.select{|m| m.c_value != nil}
  	@real_stem_loops = @stem_loops.select{|m| m.r_value != nil}
  	@plus_strand = @real_sites.select{|m| m.ds_output.loop_seq.first == "G"}
  	@minus_strand = @real_sites.select{|m| m.ds_output.loop_seq.first == "C" or m.ds_output.loop_seq.first == "T"}
  	@coding_strand = @plus_strand.select{|m| m.ds_output.feature.strand == "+"} + @minus_strand.select{|m| m.ds_output.feature.strand == "-"}
  	@template_strand = @minus_strand.select{|m| m.ds_output.feature.strand == "+"} + @plus_strand.select{|m| m.ds_output.feature.strand == "-"}




  	#position within gene
  	@first_third = Site.joins(ds_output: :feature).where("sites.genome_id = '#{@genome.id}' and (features.strand = '+' and sites.loop_start_position BETWEEN features.start_position and features.first_third) 
  																																														or (features.strand = '-' and sites.loop_start_position BETWEEN features.first_third and features.start_position) ")
  	@second_third = Site.joins(ds_output: :feature).where("sites.genome_id = '#{@genome.id}' and (features.strand = '+' and sites.loop_start_position BETWEEN features.first_third and features.second_third)
  																																														or (features.strand = '-' and sites.loop_start_position BETWEEN features.second_third and features.first_third)")
  	@last_third = Site.joins(ds_output: :feature).where("sites.genome_id = '#{@genome.id}' and (features.strand = '+' and sites.loop_start_position BETWEEN features.second_third and features.end_position)
  																																														or (features.strand = '-' and sites.loop_start_position BETWEEN features.end_position and features.second_third)")

  	@first_half = Site.joins(ds_output: :feature).where("sites.genome_id = '#{@genome.id}' and (features.strand = '+' and sites.loop_start_position BETWEEN features.start_position and features.half)
  																																														or (features.strand = '-' and sites.loop_start_position BETWEEN features.half and features.start_position)")
  	@second_half = Site.joins(ds_output: :feature).where("sites.genome_id = '#{@genome.id}' and (features.strand = '+' and sites.loop_start_position BETWEEN features.half and features.end_position)
  																																														or (features.strand = '-' and sites.loop_start_position BETWEEN features.end_position and features.half)")




  	#strength
  	@stem_four = @real_sites.select{|m| m.strength == 4}
  	@stem_five = @real_sites.select{|m| m.strength == 5}
		@stem_six = @real_sites.select{|m| m.strength == 6}	
		@stem_high = @real_sites.select{|m| m.strength >= 7}

  	#gtgg
  	@gtgg = @real_sites.select{|m| m.loop_seq == 'GTGG'}
  	@gtgg_plus = @plus_strand.select{|m| m.loop_seq == 'GTGG'}
  	@gtgg_minus = @minus_strand.select{|m| m.loop_seq == 'GTGG'}
  	@gtgg_coding = @coding_strand.select{|m| m.loop_seq == 'GTGG'}
  	@gtgg_template = @template_strand.select{|m| m.loop_seq == 'GTGG'}

  	#gagg
  	@gagg = @real_sites.select{|m| m.loop_seq == 'GAGG'}
  	@gagg_plus = @plus_strand.select{|m| m.loop_seq == 'GAGG'}
  	@gagg_minus = @minus_strand.select{|m| m.loop_seq == 'GAGG'}
  	@gagg_coding = @coding_strand.select{|m| m.loop_seq == 'GAGG'}
  	@gagg_template = @template_strand.select{|m| m.loop_seq == 'GAGG'}

  	#gaga
  	@gaga = @real_sites.select{|m| m.loop_seq == 'GAGA'}
  	@gaga_plus = @plus_strand.select{|m| m.loop_seq == 'GAGA'}
  	@gaga_minus = @minus_strand.select{|m| m.loop_seq == 'GAGA'}
  	@gaga_coding = @coding_strand.select{|m| m.loop_seq == 'GAGA'}
  	@gaga_template = @template_strand.select{|m| m.loop_seq == 'GAGA'}

# => FIX THESE GUYS BECAUSE THEY DON'T WORK

  	@gaga_plus_coding = (@gaga_plus + @gaga_coding).uniq!
  	@gaga_plus_template = (@gaga_plus + @gaga_template).uniq!
  	@gaga_minus_coding = (@gaga_minus + @gaga_coding).uniq!
  	@gaga_minus_template = (@gaga_minus + @gaga_template).uniq!

  	#position
  	# @first_third = @real_sites.select{|m| (m.loop_position - m.ds_output.feature.start_position).to_i 
  	# 	< (m.ds_output.feature.start_position.to_i + ((m.ds_output.feature.stop_position - m.ds_output.feature.start_position).to_i)/3).to_i }



  	# @real_sites.select{|m| m.ds_output.loop_seq.first == "G" and m.ds_output.feature.strand == "+" or
  	# 																				m.ds_output.feature.strand == "-" and m.ds_output.loop_seq.first == "C" 
  	# 																																						or  m.ds_output.loop_seq.first == "T"}
  	# @template_strand = @real_sites.select{|m| m.ds_output.loop_seq.first == "G" and m.ds_output.feature.strand == "-" or
  	# 																				  m.ds_output.feature.strand == "+" and m.ds_output.loop_seq.first == "C" 
  	# 																																						  or  m.ds_output.loop_seq.first == "T"}
  end
end
