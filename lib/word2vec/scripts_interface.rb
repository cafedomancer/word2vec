require 'open3'

module Word2Vec
  def self.word2vec(train, output, size: 100, window: 5, sample: '1e-3', hs: 0, negative: 5, threads: 12, iter: 5, min_count: 5, alpha: 0.025, debug: 2, binary: 1, cbow: 1, save_vocab: nil, read_vocab: nil, verbose: false)
    command = ['word2vec']
    args = ['-train', '-output', '-size', '-window', '-sample', '-hs', '-negative', '-threads', '-iter', '-min-count', '-alpha', '-debug', '-binary', '-cbow']
    values = [train, output, size, window, sample, hs, negative, threads, iter, min_count, alpha, debug, binary, cbow]

    args.zip(values).each do |arg, value|
      command << arg
      command << value.to_s
    end
    unless save_vocab.nil?
      command << '-save-vocab'
      command << save_vocab.to_s
    end
    unless read_vocab.nil?
      command << '-read-vocab'
      command << read_vocab.to_s
    end

    run_cmd(command, verbose: verbose)
  end

  def self.word2clusters(train, output, classes, size: 100, window: 5, sample: '1e-3', hs: 0, negative: 5, threads: 12, iter: 5, min_count: 5, alpha: 0.025, debug: 2, binary: 1, cbow: 1, save_vocab: nil, read_vocab: nil, verbose: false)
    command = ['word2vec']
    args = ['-train', '-output', '-size', '-window', '-sample', '-hs', '-negative', '-threads', '-iter', '-min-count', '-alpha', '-debug', '-binary', '-cbow', '-classes']
    values = [train, output, size, window, sample, hs, negative, threads, iter, min_count, alpha, debug, binary, cbow, classes]

    args.zip(values).each do |arg, value|
      command << arg
      command << value.to_s
    end
    unless save_vocab.nil?
      command << '-save-vocab'
      command << save_vocab.to_s
    end
    unless read_vocab.nil?
      command << '-read-vocab'
      command << read_vocab.to_s
    end

    run_cmd(command, verbose: verbose)
  end

  def self.word2phrase(train, output, min_count: 5, threshold: 100, debug: 2, verbose: false)
    command = ['word2phrase']
    args = ['-train', '-output', '-min-count', '-threshold', '-debug']
    values = [train, output, min_count, threshold, debug]

    args.zip(values).each do |arg, value|
      command << arg
      command << value.to_s
    end

    run_cmd(command, verbose: verbose)
  end

  def self.doc2vec(train, output, size: 100, window: 5, sample: '1e-3', hs: 0, negative: 5, threads: 12, iter: 5, min_count: 5, alpha: 0.025, debug: 2, binary: 1, cbow: 1, save_vocab: nil, read_vocab: nil, verbose: nil)
    raise NotImplementedError
  end

  def self.run_cmd(command, verbose: false)
    ext_path = Pathname.new('../../ext/word2vec').expand_path(File.dirname(__FILE__))
    command.unshift(ext_path.join(command.shift).to_s)

    output, = Open3.capture2e(command.join(' '))
    puts output if verbose

    # TODO: raise an exception if the output contains error messages
  end
end
