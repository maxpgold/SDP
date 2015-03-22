class DsOutputGene < ActiveRecord::Base
	belongs_to :ds_output
	belongs_to :gene
end
