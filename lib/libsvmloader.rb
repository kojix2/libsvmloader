
require 'libsvmloader/version'
require 'nmatrix/nmatrix'

# LibSVMLoader loads (and dumps) dataset file with the libsvm file format.
class LibSVMLoader
  class << self
    # Load a dataset with the libsvm file format into NMatrix.
    #
    # @param filename    [String]  A path to a dataset file.
    # @param zero_based  [Boolean] Whether the column index starts from 0 (true) or 1 (false).
    # @param stype       [Symbol]  The strorage type of the nmatrix consisting of feature vectors.
    # @param label_dtype [Symbol]  The data type of the NMatrix consisting of labels or target values.
    # @param value_dtype [Symbol]  The data type of the NMatrix consisting of feature vectors.
    #
    # @return [Array<NMatrix>]
    #   Returns array containing the (n_samples x n_features) matrix for feature vectors
    #   and (n_samples x 1) matrix for labels or target values.
    def load_libsvm_file(filename, zero_based: false, stype: :yale, label_dtype: :int32, value_dtype: :float64)
      ftvecs = []
      labels = []
      n_features = 0
      File.read(filename).split("\n").each do |line|
        label, ftvec, max_idx = parse_libsvm_line(line, zero_based)
        labels.push(label)
        ftvecs.push(ftvec)
        n_features = [n_features, max_idx].max
      end
      [convert_to_nmatrix(ftvecs, n_features, value_dtype, stype),
       NMatrix.new([labels.size, 1], labels, dtype: label_dtype)]
    end

    # Dump the dataset with the libsvm file format.
    #
    # @param data       [NMatrix] (n_samples x n_features) matrix consisting of feature vectors.
    # @param labels     [NMatrix] (n_samples x 1) matrix consisting of labels or target values.
    # @param filename   [String]  A path to the output libsvm file.
    # @param zero_based [Boolean] Whether the column index starts from 0 (true) or 1 (false).
    def dump_libsvm_file(data, labels, filename, zero_based: false)
      n_samples = [data.rows, labels.rows].min
      label_type = detect_dtype(labels)
      value_type = detect_dtype(data)
      File.open(filename, 'w') do |file|
        n_samples.times do |n|
          file.puts(dump_libsvm_line(labels[n], data.row(n),
                                     label_type, value_type, zero_based))
        end
      end
    end

    private

    def parse_libsvm_line(line, zero_based)
      tokens = line.split
      label = tokens.shift.to_f
      ftvec = tokens.map do |el|
        idx, val = el.split(':')
        idx = idx.to_i - (zero_based == false ? 1 : 0)
        [idx, val.to_f]
      end
      max_idx = ftvec.map { |el| el[0] }.max
      max_idx ||= 0
      [label, ftvec, max_idx]
    end

    def convert_to_nmatrix(data, n_features, value_dtype, stype)
      n_samples = data.size
      mat = NMatrix.zeros([n_samples, n_features + 1],
                          dtype: value_dtype, stype: stype)
      data.each_with_index do |ftvec, n|
        ftvec.each do |el|
          mat[n, el[0]] = el[1]
        end
      end
      mat
    end

    def detect_dtype(data)
      type = '%s'
      type = '%d' if %i[int8 int16 int32 int64].include?(data.dtype)
      type = '%.10g' if %i[float32 float64].include?(data.dtype)
      type
    end

    def dump_libsvm_line(label, ftvec, label_type, value_type, zero_based)
      line = format(label_type.to_s, label)
      ftvec.to_a.each_with_index do |val, n|
        idx = n + (zero_based == false ? 1 : 0)
        line += format(" %d:#{value_type}", idx, val) if val != 0.0
      end
      line
    end
  end
end
