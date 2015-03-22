class HumanFeature < ActiveRecord::Base
	belongs_to :human_transcript

	def self.import_human_features(source)
		file = File.open(source)
		lines = file.readlines
		lines.each do |l|
			array = l.delete("\n").split("\t")
			hf = HumanFeature.create(
				start_position: array[0],
				stop_position: array[1],
				gene_symbol: array[2],
				refseq_transcript_name: array[3],
				strand: array[4],
				refseq_exon_position: array[5],
				coding_start: array[6],
				coding_stop: array[7],
				canonical: true
				)
			ht = HumanTranscript.find_by_refseq_transcript_name(hf.refseq_transcript_name)
			if ht
				hf.update_attributes(human_transcript_id: ht.id)
			end
		end
	end

end
