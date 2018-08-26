# frozen_string_literal: true

require 'libsvmloader/version'
require 'csv'

# LibSVMLoader loads (and dumps) dataset file with the libsvm file format.
class LibSVMLoader
  class << self
    # Load a dataset with the libsvm file format.
    #
    # @param filename    [String]  Path to a dataset file.
    # @param zero_based  [Boolean] Whether the column index starts from 0 (true) or 1 (false).
    # @param label_dtype [String]  Data type of labels or target values ('int', 'float', 'complex').
    # @param value_dtype [String]  Data type of feature vectors ('int', 'float', 'complex').
    #
    # @return [Array<Array>]
    #   Returns array containing the (n_samples x n_features) matrix for feature vectors
    #   and (n_samples) vector for labels or target values.
    def load_libsvm_file(filename, zero_based: false, label_dtype: 'int', value_dtype: 'float')
      labels = []
      ftvecs = []
      maxids = []
      label_class = parse_dtype(label_dtype)
      value_class = parse_dtype(value_dtype)
      CSV.foreach(filename, col_sep: "\s", headers: false) do |row|
        label, ftvec, maxid = parse_libsvm_row(row, zero_based, label_class, value_class)
        labels.push(label)
        ftvecs.push(ftvec)
        maxids.push(maxid)
      end
      [convert_to_matrix(ftvecs, maxids.max + 1, value_class), labels]
    end

    # Dump the dataset with the libsvm file format.
    #
    # @param data       [Array] (n_samples x n_features) matrix consisting of feature vectors.
    # @param labels     [Array] (n_samples) vector consisting of labels or target values.
    # @param filename   [String]  Path to the output libsvm file.
    # @param zero_based [Boolean] Whether the column index starts from 0 (true) or 1 (false).
    def dump_libsvm_file(data, labels, filename, zero_based: false)
      n_samples = [data.size, labels.size].min
      label_format = detect_format(labels.first)
      value_format = detect_format(data.flatten.first)
      File.open(filename, 'w') do |file|
        n_samples.times { |n| file.puts(dump_libsvm_line(labels[n], data[n], label_format, value_format, zero_based)) }
      end
    end

    private

    def parse_libsvm_row(row, zero_based, label_type, value_type)
      label = convert_type(row.shift, label_type)
      adj_idx = zero_based == false ? 1 : 0
      max_idx = -1
      ftvec = []
      while el = row.shift
        idx, val = el.split(':')
        idx = idx.to_i - adj_idx
        max_idx = idx if max_idx < idx
        ftvec.push([idx, convert_type(val, value_type)])
      end
      [label, ftvec, max_idx]
    end

    def parse_dtype(dtype)
      case dtype.to_s
      when /^(int)/i
        :int
      when /^(float)/i
        :float
      when /^(complex)/i
        :complex
      else
        :string
      end
    end

    def convert_type(value, dtype)
      case dtype
      when :int
        value.to_i
      when :float
        value.to_f
      when :complex
        value.to_c
      else
        value
      end
    end

    def convert_to_matrix(data, n_features, value_type)
      z = convert_type(0, value_type)
      data.map do |ft|
        vec = Array.new(n_features) { z }
        ft.each { |idx, val| vec[idx] = val }
        vec
      end
    end

    def detect_format(data)
      type = '%s'
      type = '%d' if data.is_a?(Integer)
      type = '%.10g' if data.is_a?(Float)
      type
    end

    def dump_libsvm_line(label, ftvec, label_format, value_format, zero_based)
      line = format(label_format, label)
      ftvec.each_with_index do |val, n|
        unless val.zero?
          idx = n + (zero_based == false ? 1 : 0)
          line += format(" %d:#{value_format}", idx, val)
        end
      end
      line
    end
  end
end
