class HumanTranscript < ActiveRecord::Base
	belongs_to :human_gene
	has_many :human_features

	def self.import_human_transcripts(source)
		file = File.open(source)
		lines = file.readlines
		lines.each do |l|
			array = l.delete("\n").split("\t")
			ht = HumanTranscript.create(
				refseq_transcript_name: array[0],
				chromosome_id: array[1],
				strand: array[2],
				start_position: array[3],
				stop_position: array[4],
				coding_start: array[5],
				coding_stop: array[6],
				symbol: array[7]
				)
			hg = HumanGene.find_by_symbol(ht.symbol)
			if hg
				ht.update_attributes(human_gene_id: hg.id)
			end
		end
	end
end
