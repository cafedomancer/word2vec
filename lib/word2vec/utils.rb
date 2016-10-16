require "nmatrix"

module Word2Vec
  class WordVectors
    def self.unitvec(vec)
      (NMatrix[*vec] * (1.0 / NMatrix[*vec].norm2)).to_a
    end
  end
end
