require "csv"

module Word2Vec
  class WordClusters
    attr_accessor :vocab, :clusters

    def initialize(vocab:, clusters:)
      self.vocab = vocab
      self.clusters = clusters
    end

    def ix(word)
      raise NotImplementedError
    end

    def [](word)
      raise NotImplementedError
    end

    def get_cluster(word)
      raise NotImplementedError
    end

    def get_words_on_cluster(cluster)
      indices = clusters.each_with_index.map { |clst, i| i if clst == cluster }.compact
      self.vocab.values_at(*indices)
    end

    def self.from_text(fname)
      csv = CSV.read(fname, col_sep: " ")
      vocab = csv.transpose[0]
      clusters = csv.transpose[1].map(&:to_i)
      self.new(vocab: vocab, clusters: clusters)
    end
  end
end
