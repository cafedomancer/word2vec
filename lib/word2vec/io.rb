module Word2Vec
  def self.load(fname, *args, kind: 'auto', **kwargs)
    if kind == 'auto'
      if fname.end_with?('.bin')
        kind = 'bin'
      elsif fname.end_with?('.txt')
        kind = 'txt'
      else
        raise 'Could not identify kind'
      end
    end

    if kind == 'bin'
      Word2Vec::WordVectors.from_binary(fname, *args, **kwargs)
    elsif kind == 'txt'
      Word2Vec::WordVectors.from_text(fname, *args, **kwargs)
    elsif kind == 'mmap'
      Word2Vec::WordVectors.from_mmap(fname, *args, **kwargs)
    else
      raise 'Unknown kind'
    end
  end

  def self.load_clusters(fname)
    Word2Vec::WordClusters.from_text(fname)
  end
end
