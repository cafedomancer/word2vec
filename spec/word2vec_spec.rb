require 'spec_helper'

input = File.expand_path('~/data/text')
output_phrases = File.expand_path('~/data/text-phrases.txt')
output_clusters = File.expand_path('~/data/text-clusters.txt')
output_bin = File.expand_path('~/data/vectors.bin')
output_txt = File.expand_path('~/data/vectors.txt')

describe Word2Vec do
  before do
    Word2Vec.word2phrase(input, output_phrases, verbose: false)
    Word2Vec.word2vec(input, output_bin, size: 10, binary: 1, verbose: false)
    Word2Vec.word2vec(input, output_txt, size: 10, binary: 0, verbose: false)
    Word2Vec.word2clusters(input, output_clusters, 10, verbose: true)
  end

  it 'test_files_create' do
    expect(FileTest.exist?(input)).to be true
    expect(FileTest.exist?(output_phrases)).to be true
    expect(FileTest.exist?(output_clusters)).to be true
    expect(FileTest.exist?(output_bin)).to be true
    expect(FileTest.exist?(output_txt)).to be true
  end

  it 'test_load_bin' do
    model = Word2Vec.load(output_bin)
    vocab = model.vocab
    vectors = model.vectors

    expect(vectors.size).to eq(vocab.size)
    expect(vectors.size).to be > 3000
    expect(vectors.first.size).to eq(10)
  end

  it 'test_load_txt' do
    model = Word2Vec.load(output_txt)
    vocab = model.vocab
    vectors = model.vectors

    expect(vectors.size).to eq(vocab.size)
    expect(vectors.size).to be > 3000
    expect(vectors.first.size).to eq(10)
  end

  it 'test_prediction' do
    model = Word2Vec.load(output_bin)
    indices, metrics = model.cosine('the')
    expect(indices.size).to eq(10)
    expect(indices.size).to eq(metrics.size)

    rb_response = model.generate_response(indices, metrics)
    expect(rb_response.size).to eq(10)
    expect(rb_response[0].size).to eq(2)
  end

  it 'test_analogy' do
    model = Word2Vec.load(output_txt)
    indices, metrics = model.analogy(pos: ['the', 'the'], neg: ['the'], n: 20)
    expect(indices.size).to eq(20)
    expect(indices.size).to eq(metrics.size)

    rb_response = model.generate_response(indices, metrics)
    expect(rb_response.size).to eq(20)
    expect(rb_response[0].size).to eq(2)
  end

  it 'test_clusters' do
    clusters = Word2Vec.load_clusters(output_clusters)
    expect(clusters.vocab.size).to eq(clusters.clusters.size)
    expect(clusters.get_words_on_cluster(1).size).to be > 10  # sanity check
    expect(clusters.get_words_on_cluster(1).all?).to be true
  end

  it 'test_model_with_clusters' do
    clusters = Word2Vec.load_clusters(output_clusters)
    model = Word2Vec.load(output_bin)
    expect(clusters.vocab.size).to eq(model.vocab.size)

    model.clusters = clusters
    indices, metrics = model.analogy(pos: ['the', 'the'], neg: ['the'], n: 30)
    expect(indices.size).to eq(30)
    expect(indices.size).to eq(metrics.size)

    rb_response = model.generate_response(indices, metrics)
    expect(rb_response.size).to eq(30)
    expect(rb_response[0].size).to eq(3)
  end

  # it 'has a version number' do
  #   expect(Word2Vec::VERSION).not_to be nil
  # end

  # it 'does something useful' do
  #   expect(false).to eq(true)
  # end
end
