class Gene
  
  @@number_of_genes = 0
  attr_accessor :gene_id
  attr_accessor :chromosome
  attr_accessor :location
  attr_accessor :strand
  attr_accessor :conditions
  attr_accessor :genes
  
  def initialize (params = {})
    @gene_id = params.fetch(:gene_id, "NA")
    @chromosome = params.fetch(:chromosome, "NA")
    @location = params.fetch(:location, "NA")
    @strand = params.fetch(:strand, "NA")
    @conditions = params.fetch(:conditions, "NA")
    @@number_of_genes +=1
  end
  
  def Gene.genes
    return @genes
  end

  def Gene.gene_ids
    list = Array.new()
    unless @genes.is_a?(NilClass)
      @genes.each do |gene| 
        list << gene.gene_id
      end
    end
    return list
  end
  
  def Gene.load_gene_ids(file, condition) # function to load gene ids from a file
    newlist = Array.new()
    newlist.concat(@genes) unless @genes.is_a?(NilClass)
    records =  IO.readlines(file)
    records.each do |gene|
      if gene.to_s != ""  # this is to discard empty lines from the input file
        if gene =~ /^(.+)\t.+\t.+\t(.+)\t.+\t.+\t(.+)\t.+\tgene=(.+);$/ && gene.class != NilClass
          chromosome = $1
          location = $2 # feature start
          strand = $3
          gene = $4.upcase
          if !Gene.gene_ids.include?(gene)
            new_gene = Gene.new(
            :gene_id => gene, # all gene ids will be converted to uppercase
            :chromosome => chromosome,
            :location => location,
            :strand => strand,
            :conditions => [condition],
            )
            newlist << new_gene
          # this part is to record the expression conditions of repeated genes
          # without creating a new instance of the 'Gene' object
          elsif Gene.gene_ids.include?(gene)
            Gene.genes.each do |old_gene|
              if old_gene.gene_id == gene
                old_gene.conditions.concat([condition])
                old_gene.conditions = old_gene.conditions.uniq
              end
            end
          end
        else
          next
        end
      end
    end
    @genes = newlist
  end
  
  def Gene.how_many # this function returns the total number of instances of the Gene object
    return @@number_of_genes
  end
  
end
