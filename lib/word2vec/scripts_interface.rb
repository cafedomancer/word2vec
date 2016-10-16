module Word2Vec
  def self.word2vec(train, output, size: 100, window: 5, sample: '1e-3', hs: 0,
                    negative: 5, threads: 12, iter_: 5, min_count: 5, alpha: 0.025,
                    debug: 2, binary: 1, cbow: 1, save_vocab: nil, read_vocab: nil,
                    verbose: false)
    ext = File.expand_path('../../../ext/word2vec', __FILE__)
    command = [File.join(ext, 'word2vec')]
    args = ['-train', '-output', '-size', '-window', '-sample', '-hs',
            '-negative', '-threads', '-iter', '-min-count', '-alpha', '-debug',
            '-binary', '-cbow']
    values = [train, output, size, window, sample, hs, negative, threads,
              iter_, min_count, alpha, debug, binary, cbow]

    args.zip(values).each do |arg, value|
      command << arg
      command << value.to_s
    end
    if save_vocab != nil
      command << '-save-vocab'
      command << save_vocab.to_s
    end
    if read_vocab != nil
      command << '-read-vocab'
      command << read_vocab.to_s
    end

    run_cmd(command, verbose: verbose)
  end

  def self.word2clusters(train, output, classes, size: 100, window: 5, sample: '1e-3',
                         hs: 0, negative: 5, threads: 12, iter_: 5, min_count: 5,
                         alpha: 0.025, debug: 2, binary: 1, cbow: 1,
                         save_vocab: nil, read_vocab: nil, verbose: false)
    ext = File.expand_path('../../../ext/word2vec', __FILE__)
    command = [File.join(ext, 'word2vec')]

    args = ['-train', '-output', '-size', '-window', '-sample', '-hs',
            '-negative', '-threads', '-iter', '-min-count', '-alpha', '-debug',
            '-binary', '-cbow', '-classes']
    values = [train, output, size, window, sample, hs, negative, threads,
              iter_, min_count, alpha, debug, binary, cbow, classes]

    args.zip(values).each do |arg, value|
      command << arg
      command << value.to_s
    end

    if save_vocab != nil
      command << '-save-vocab'
      command << save_vocab.to_s
    end
    if read_vocab != nil
      command << '-read-vocab'
      command << read_vocab.to_s
    end

    run_cmd(command, verbose: verbose)
  end

  def self.word2phrase(train, output, min_count: 5, threshold: 100, debug: 2,
                       verbose: false)
    ext = File.expand_path('../../../ext/word2vec', __FILE__)
    command = [File.join(ext, 'word2phrase')]

    args = ['-train', '-output', '-min-count', '-threshold', '-debug']
    values = [train, output, min_count, threshold, debug]
    args.zip(values).each do |arg, value|
      command << arg
      command << value.to_s
    end

    run_cmd(command, verbose: verbose)
  end

  def self.doc2vec(train, output, size: 100, window: 5, sample: '1e-3', hs: 0, negative: 5,
                   threads: 12, iter_: 5, min_count: 5, alpha: 0.025, debug: 2, binary: 1,
                   cbow: 1,
                   save_vocab: nil, read_vocab: nil, verbose: nil)
    raise NotImplementedError
  end

  def self.run_cmd(command, verbose: false)
    p command.join(' ')
    system(command.join(' '))

    # TODO: implement it later
    # if verbose
    #   while line = stdout.readline
    #     $stdout.write(line)
    #     if line.include?('ERROR:')
    #       raise Exception(line)
    #     end
    #     $stdout.flush
    #   end
    # end
  end
end
