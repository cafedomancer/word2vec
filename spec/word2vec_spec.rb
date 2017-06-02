require 'spec_helper'

RSpec.describe Word2Vec do
  input = Pathname.new(File.join('spec', 'fixtures', 'text'))
  output_phrases = Pathname.new(File.join('spec', 'fixtures', 'text-phrases.txt'))
  output_clusters = Pathname.new(File.join('spec', 'fixtures', 'text-clusters.txt'))
  output_bin = Pathname.new(File.join('spec', 'fixtures', 'vectors.bin'))
  output_txt = Pathname.new(File.join('spec', 'fixtures', 'vectors.txt'))

  describe '.run_cmd' do
    context 'verbose: true' do
      it 'runs the given command with a verbose output' do
        expect { Word2Vec.run_cmd(['word2vec'], verbose: true) }.to output(/WORD VECTOR estimation toolkit v 0.1c/).to_stdout
      end
    end

    context 'verbose: false' do
      it 'runs the given command without a verbose output' do
        expect { Word2Vec.run_cmd(['word2vec'], verbose: false) }.to_not output.to_stdout
      end
    end
  end

  describe '.word2vec' do
    context 'binary: 1' do
      it 'generates a binary vectors file' do
        Word2Vec.word2vec(input, output_bin, size: 10, binary: 1, verbose: false)
        expect(output_bin).to exist
      end
    end

    context 'binary: 0' do
      it 'generates a text vectors file' do
        Word2Vec.word2vec(input, output_txt, size: 10, binary: 0, verbose: false)
        expect(output_txt).to exist
      end
    end
  end

  describe '.word2clusters' do
    it 'generates a text clusters file' do
      Word2Vec.word2clusters(input, output_clusters, 10, verbose: false)
      expect(output_clusters).to exist
    end
  end

  describe '.word2phrases' do
    it 'generates a text phrases file' do
      Word2Vec.word2phrase(input, output_phrases, verbose: false)
      expect(output_phrases).to exist
    end
  end

  describe '.doc2vec' do
    context 'binary: 1' do
      it 'raises a not implemented error' do
        expect { Word2Vec.doc2vec(input, output_bin, size: 10, binary: 1, verbose: false) }.to raise_error(NotImplementedError)
      end
    end

    context 'binary: 0' do
      it 'raises a not implemented error' do
        expect { Word2Vec.doc2vec(input, output_txt, size: 10, binary: 1, verbose: false) }.to raise_error(NotImplementedError)
      end
    end
  end
end
