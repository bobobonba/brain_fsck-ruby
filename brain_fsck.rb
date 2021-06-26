class BrainFsck
  INITIAL = 0
  def initialize(src)
    @token = src.chars
    @tape = []
    @head = INITIAL
    @token_index = INITIAL
    @repeat_block = {}
  end

  def run
    while @token_index <= @token.size
      case @token[@token_index]
      when '+'
        plus
      when '-'
        minus
      when '>'
        increment
      when '<'
        decrement
      when '['
        add_repeat_point(@token_index)
        repeat_head(@token_index)
      when ']'
        repeat_tail(@token_index)
      when '.'
        print_ascii
      end
      @token_index += 1
    end
  end

  private

  def plus
    initialize_cell(@head)
    @tape[@head] += 1
  end

  def minus
    initialize_cell(@head)
    @tape[@head] -= 1
  end

  def print_ascii
    print @tape[@head].chr
  end

  def add_repeat_point(index)
    nest_count = INITIAL
    tail_count = INITIAL
    (index + 1...@token.size).each do |num|
      case @token[num]
      when '['
        nest_count += 1
      when ']'
        tail_count += 1
        if tail_count == nest_count + 1
          @repeat_block[index] = num
          break
        end
      end
    end
  end

  def repeat_head(index)
    if @tape[@head].zero?
      @token_index = @repeat_block[index]
    end
  end

  def repeat_tail(index)
    return if @tape[@head].zero?

    @token_index = @repeat_block.key(index)
  end

  def increment
    @head += 1
  end

  def decrement
    if @head.zero?
      @head = INITIAL
    else
      @head -= 1
    end
  end

  def initialize_cell(index)
    if @tape[index].nil?
      while @tape.size <= index
        @tape << INITIAL
      end
    end
  end
end

interpreter = BrainFsck.new(ARGF.read)
interpreter.run
