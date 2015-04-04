class Genome < ActiveRecord::Base
	has_many :genes
	has_many :stem_loops
	has_many :sites

	def import_genome(file)
		f = File.open(file)
		lines = f.readlines
		values = lines.split("\r")
		
	end

	def print_data
    sites = Site.joins(ds_output: {feature: :gene}).where("sites.genome_id = #{self.id} and sites.c_value is not NULL and genes.pseudo_gene is not 'true'").all
    repeat_array = sites.map{|m| [m.sequence, m.c_value, m.ds_output.feature.gene.name]}.uniq!
		filtered_sites = []
    repeat_array.each do |a|
      site = Site.joins(ds_output: {feature: :gene}).where("sites.sequence = '#{a[0]}' and sites.c_value = #{a[1]} and genes.name = '#{a[2]}'").first
      filtered_sites.push(site)
    end
    
    r_value = filtered_sites.map{|fs| fs.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    r_value_percents = r_value.map{|m| (m[1].to_f / filtered_sites.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    c_value = filtered_sites.map{|fs| fs.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    c_value_percents = c_value.map{|m| (m[1].to_f / filtered_sites.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #GTGG sites
    gtgg = filtered_sites.select{|m| m.ds_output.loop_seq == "GTGG"}
    gtgg_coding = gtgg.select{|m| m.ds_output.feature.gene.strand == "+"}
    gtgg_template = gtgg - gtgg_coding
    ccac = filtered_sites.select{|m| m.ds_output.loop_seq == "CCAC"}
    ccac_coding = ccac.select{|m| m.ds_output.feature.gene.strand == "-"}
    ccac_template = ccac - ccac_coding  
    gtgg_r_summary = (gtgg + ccac).map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    gtgg_r_percents = gtgg_r_summary.map{|m| (m[1].to_f / (gtgg + ccac).count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    gtgg_c_summary = (gtgg + ccac).map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    gtgg_c_percents = gtgg_c_summary.map{|m| (m[1].to_f / (gtgg + ccac).count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #GAGG sites
    gagg = filtered_sites.select{|m| m.ds_output.loop_seq == "GAGG"}
    gagg_coding = gagg.select{|m| m.ds_output.feature.gene.strand == "+"}
    gagg_template = gagg - gagg_coding
    cctc = filtered_sites.select{|m| m.ds_output.loop_seq == "CCTC"}
    cctc_coding = cctc.select{|m| m.ds_output.feature.gene.strand == "-"}
    cctc_template = cctc - cctc_coding   
    gagg_r_summary = (gagg + cctc).map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    gagg_r_percents = gagg_r_summary.map{|m| (m[1].to_f / (gagg + cctc).count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}    
    gagg_c_summary = (gagg + cctc).map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    gagg_c_percents = gagg_c_summary.map{|m| (m[1].to_f/ (gagg + cctc).count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #GAGA sites
    gaga = filtered_sites.select{|m| m.ds_output.loop_seq == "GAGA"}
    gaga_coding = gaga.select{|m| m.ds_output.feature.gene.strand == "+"}
    gaga_template = gaga - gaga_coding
    tctc = filtered_sites.select{|m| m.ds_output.loop_seq == "TCTC"}
    tctc_coding = tctc.select{|m| m.ds_output.feature.gene.strand == "-"}
    tctc_template = tctc - tctc_coding  
    gaga_r_summary = (gaga + tctc).map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    gaga_r_percents = gaga_r_summary.map{|m| (m[1].to_f / (gaga + tctc).count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    gaga_c_summary = (gaga + tctc).map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    gaga_c_percents = gaga_c_summary.map{|m| (m[1].to_f / (gaga + tctc).count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #plus sites
    plus = gtgg + gagg + gaga
    plus_r_summary = plus.map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    plus_r_percents = plus_r_summary.map{|m| (m[1].to_f / plus.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    plus_c_summary = plus.map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    plus_c_percents = plus_c_summary.map{|m| (m[1].to_f / plus.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #minus sites
    minus = cctc + ccac + tctc
    minus_r_summary = minus.map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    minus_r_percents = minus_r_summary.map{|m| (m[1].to_f/ minus.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    minus_c_summary = minus.map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    minus_c_percents = minus_c_summary.map{|m| (m[1].to_f / minus.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #coding sites
    coding = gtgg_coding + gagg_coding + gaga_coding + cctc_coding + ccac_coding + tctc_coding
    coding_r_summary = coding.map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    coding_r_percents = coding_r_summary.map{|m| (m[1].to_f / coding.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    coding_c_summary = coding.map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    coding_c_percents = coding_c_summary.map{|m| (m[1].to_f / coding.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #template sites
    template = gtgg_template + gagg_template + gaga_template + cctc_template + ccac_template + tctc_template
    template_r_summary = template.map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    template_r_percents = template_r_summary.map{|m| (m[1].to_f / template.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    template_c_summary = template.map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]} 
    template_c_percents = template_c_summary.map{|m| (m[1].to_f / template.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #stem_strength

    #4 base
    four_base = filtered_sites.select{|m| m.strength == 4}
    four_base_r_summary = four_base.map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    four_base_r_percents = four_base_r_summary.map{|m| (m[1].to_f/ four_base.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    four_base_c_summary = four_base.map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    four_base_c_percents = four_base_c_summary.map{|m| (m[1].to_f / four_base.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #5 base
    five_base = filtered_sites.select{|m| m.strength == 5}
    five_base_r_summary = five_base.map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    five_base_r_percents = five_base_r_summary.map{|m| (m[1].to_f/ five_base.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    five_base_c_summary = five_base.map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    five_base_c_percents = five_base_c_summary.map{|m| (m[1].to_f / five_base.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #6 base
    six_base = filtered_sites.select{|m| m.strength == 6}
    six_base_r_summary = six_base.map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    six_base_r_percents = six_base_r_summary.map{|m| (m[1].to_f/ six_base.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    six_base_c_summary = six_base.map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    six_base_c_percents = six_base_c_summary.map{|m| (m[1].to_f / six_base.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}

    #7+ base
    seven_up_base = filtered_sites.select{|m| m.strength == 7}
    seven_up_base_r_summary = seven_up_base.map{|m| m.r_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    seven_up_base_r_percents = seven_up_base_r_summary.map{|m| (m[1].to_f/ seven_up_base.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}
    seven_up_base_c_summary = seven_up_base.map{|m| m.c_value}.group_by{|x| x}.map{|k,v| [k, v.count]}.sort_by{|p| p[0]}
    seven_up_base_c_percents = seven_up_base_c_summary.map{|m| (m[1].to_f / seven_up_base.count.to_f) * 100}.map{|o| o.round(2).to_s + "%"}


    
    #strings for summary messages
    summary = "Overall Summary \n" + ""

    r_value_summary = "The Distribution of r-values is #{r_value.map{|m| m.join(" => ")}.join(", ")} representing #{r_value_percents.join(" and ")}\n"

    c_value_summary = "The Distribution of c-values is #{c_value.map{|m| m.join(" => ")}.join(", ")} representing #{c_value_percents.join(" and ")}\n"

    strand_summary = "There are #{plus.count} plus strand sites and #{minus.count} minus strand sites\n"

    gtgg_summary = "There are #{(gtgg + ccac).count} GTGG sites.\n" + "#{gtgg.count} are GTGG and #{ccac.count} are CCAC.\n" + 
    "The r-value distribution is #{gtgg_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{gtgg_r_percents.join(" and ")} \n" + 
    "The c-value distribution is #{gtgg_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{gtgg_c_percents.join(" and ")} \n"

    gagg_summary = "There are #{(gagg + cctc).count} GAGG sites.\n" + "#{gagg.count} are GAGG and #{cctc.count} are CCTC.\n" + 
    "The r-value distribution is #{gagg_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{gagg_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{gagg_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{gagg_c_percents.join(" and ")}\n"

    gaga_summary = "There are #{(gaga + tctc).count} GAGA sites.\n" + "#{gaga.count} are GAGA and #{tctc.count} are TCTC.\n" + 
    "The r-value distribution is #{gaga_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{gaga_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{gaga_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{gaga_c_percents.join(" and ")}\n"

    plus_strand_summary = "There are #{plus.count} plus strand sites. \n" + 
    "The r-value distribution is #{plus_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{plus_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{plus_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{plus_c_percents.join(" and ")}\n"

    minus_strand_summary = "There are #{minus.count} minus strand sites. \n" + 
    "The r-value distribution is #{minus_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{minus_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{minus_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{minus_c_percents.join(" and ")}\n"

    coding_strand_summary = "There are #{coding.count} coding strand sites. \n" + 
    "The r-value distribution is #{coding_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{coding_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{coding_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{coding_c_percents.join(" and ")}\n"

    template_strand_summary = "There are #{template.count} template strand sites. \n" + 
    "The r-value distribution is #{template_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{template_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{template_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{template_c_percents.join(" and ")}\n"

    four_base_summary = "There are #{four_base.count} four_base strand sites. \n" + 
    "The r-value distribution is #{four_base_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{four_base_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{four_base_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{four_base_c_percents.join(" and ")}\n"

    five_base_summary = "There are #{five_base.count} five_base strand sites. \n" + 
    "The r-value distribution is #{five_base_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{five_base_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{five_base_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{five_base_c_percents.join(" and ")}\n"

    six_base_summary = "There are #{six_base.count} six_base strand sites. \n" + 
    "The r-value distribution is #{six_base_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{six_base_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{six_base_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{six_base_c_percents.join(" and ")}\n"

    seven_up_base_summary = "There are #{seven_up_base.count} seven_up_base strand sites. \n" + 
    "The r-value distribution is #{seven_up_base_r_summary.map{|m| m.join(" => ")}.join(", ")} representing #{seven_up_base_r_percents.join(" and ")}\n" + 
    "The c-value distribution is #{seven_up_base_c_summary.map{|m| m.join(" => ")}.join(", ")} representing #{seven_up_base_c_percents.join(" and ")}\n"    



    report = [summary, r_value_summary, c_value_summary, strand_summary, gtgg_summary, gagg_summary, gaga_summary, plus_strand_summary, minus_strand_summary, coding_strand_summary, template_strand_summary, four_base_summary, five_base_summary, six_base_summary, seven_up_base_summary].join("\n")

    return report
	end
end
