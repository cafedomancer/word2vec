module Word2Vec
  def self.load(fname, *args, kind: 'auto', **kwargs)
    if kind == 'auto'
      case File.extname(fname)
      when '.bin'
        kind = 'bin'
      when '.txt'
        kind = 'txt'
      else
        raise 'Could not identify kind'
      end
    end

    case kind
    when 'bin'
      Word2Vec::WordVectors.from_binary(fname, *args, **kwargs)
    when 'txt'
      Word2Vec::WordVectors.from_text(fname, *args, **kwargs)
    when 'mmap'
      Word2Vec::WordVectors.from_mmap(fname, *args, **kwargs)
    else
      raise ArgumentError, 'Unknown kind'
    end
  end

  def self.load_clusters(fname)
    Word2Vec::WordClusters.from_text(fname)
  end
end
