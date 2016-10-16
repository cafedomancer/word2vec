require "nmatrix"

require "word2vec/utils"

module Word2Vec
  class WordVectors
    attr_accessor :vocab, :vectors, :clusters, :vocab_hash

    def initialize(vocab:, vectors:, clusters: nil)
      @vocab = vocab
      @vectors = vectors
      @clusters = clusters

      @vocab_hash = {}
      vocab.each_with_index do |word, i|
        @vocab_hash[word] = i
      end
    end

    def ix(word)
      self.vocab_hash[word]
    end

    def word(ix)
      self.vocab[ix]
    end

    def [](word)
      self.get_vector(word)
    end

    def include?(word)
      raise NotImplementedError
    end

    def get_vector(word)
      idx = self.ix(word)
      self.vectors[idx]
    end

    def cosine(word, n: 10)
      metrics = NMatrix[*self.vectors, dtype: :float32].dot(NMatrix[self[word], dtype: :float32].transpose)
      best = metrics.sorted_indices.reverse[1..n]
      best_metrics = metrics.to_a.values_at(*best).flatten
      [best, best_metrics]
    end

    def analogy(pos:, neg:, n: 10)
      exclude = pos + neg
      pos = pos.map { |word| [word, 1.0] }
      neg = neg.map { |word| [word, -1.0] }

      mean = []
      (pos + neg).each do |word, direction|
        mean << (NMatrix[*self[word], dtype: :float32] * direction).to_a
      end
      mean = NMatrix[*mean, dtype: :float32].mean

      metrics = NMatrix[*self.vectors, dtype: :float32].dot(mean.transpose)
      best = metrics.sorted_indices.reverse[0...(n + exclude.size)]

      exclude_idx = []
      exclude.each do |word|
        if best.include?(self.ix(word))
          exclude_idx << best.each_index.select { |i| best[i] == self.ix(word) }
        end
      end
      exclude_idx.flatten.uniq.each do |index|
        best.delete_at(index)
      end
      new_best = best
      best_metrics = metrics.to_a.flatten.values_at(*new_best)
      [new_best[0...n], best_metrics[0...n]]
    end

    def generate_response(indices, metrics, clusters: true)
      if self.clusters && clusters
        self.vocab.values_at(*indices)
          .zip(metrics, self.clusters.clusters.values_at(*indices))
      else
        self.vocab.values_at(*indices).zip(metrics)
      end
    end

    def to_mmap(fname)
      raise NotImplementedError
    end

    def self.from_binary(fname, vocab_unicode_size: 78, desired_vocab: nil, encoding: "utf-8")
      vocab = nil
      vectors = nil

      File.open(fname, 'rb') do |fin|
        header = fin.readline
        vocab_size, vector_size = header.split.map(&:to_i)

        # TODO: replace numpy with nmatrix
        # little-endian (<), Unicode (U), 78 characters == 2496 bytes (78)
        # vocab = numpy.empty(vocab_size, dtype = '<U%s' % vocab_unicode_size)
        # vectors = numpy.empty([vocab_size, vector_size], dtype = np.float)
        # binary_len = numpy.dtype(np.float32).itemsize * vector_size

        vocab = NMatrix.new([vocab_size], "", dtype: :object).to_a
        vectors = NMatrix.random([vocab_size, vector_size], dtype: :float64).to_a
        binary_len = 4 * vector_size # need to calculate from a data type

        vocab_size.times do |i|
          word = ''
          while true
            ch = fin.read(1)
            if ch == ' '
              break
            end
            word += ch
          end
          inklude = desired_vocab == nil || desired_vocab.include?(word)
          if inklude
            vocab[i] = word.force_encoding(encoding)
          end

          # read vector
          vector = NMatrix[*fin.read(binary_len).unpack('f*'), dtype: :float32].to_a
          if inklude
            vectors[i] = unitvec(vector)
          end
          fin.read(1) # newline
        end

        if desired_vocab != nil
          indices = vocab.each_with_index.map { |word, i| i if vocab != nil }.compact
          vectors = vectors.values_at(*indices)
          vocab = vocab.values_at(*indices)
        end
      end

      self.new(vocab: vocab, vectors: vectors)
    end

    def self.from_text(fname, vocab_unicode_size: 78, desired_vocab: nil, encoding: "utf-8")
      vocab = nil
      vectors = nil

      File.open(fname, 'rb') do |fin|
        header = fin.readline
        vocab_size, vector_size = header.split.map(&:to_i)

        # TODO: replace numpy with nmatrix
        # little-endian (<), Unicode (U), 78 characters == 2496 bytes (78)
        # vocab = numpy.empty(vocab_size, dtype = '<U%s' % vocab_unicode_size)
        # vectors = numpy.empty([vocab_size, vector_size], dtype = np.float)
        # binary_len = numpy.dtype(np.float32).itemsize * vector_size

        vocab = NMatrix.new([vocab_size], "", dtype: :object).to_a
        vectors = NMatrix.random([vocab_size, vector_size], dtype: :float64).to_a

        fin.each_line.with_index do |line, i|
          line = line.force_encoding(encoding).strip
          parts = line.split(" ")
          word = parts[0]
          inklude = desired_vocab == nil || desired_vocab.include?(word)
          if inklude
            vector = parts[1..-1].map(&:to_f)
            vocab[i] = word
            vectors[i] = unitvec(vector)
          end
        end

        if desired_vocab != nil
          indices = vocab.each_with_index.map { |word, i| i if vocab != nil }.compact
          vectors = vectors.values_at(*indices)
          vocab = vocab.values_at(*indices)
        end
      end

      self.new(vocab: vocab, vectors: vectors)
    end

    def self.from_mmap(fname)
      raise NotImplementedError
    end
  end
end
