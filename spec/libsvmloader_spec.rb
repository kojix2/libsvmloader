require "spec_helper"

RSpec.describe LibSVMLoader do
  let(:matrix_int) do
    NMatrix.new([6, 4], [
                5, 3, 0, 8,
                3, 1, 2, 0,
                0, 0, 1, 0,
                0, 0, 0, 0,
                0, 0, 0, 2,
                0, 4, 0, 5,], dtype: :int32)
  end

  let(:matrix_dbl) do
    NMatrix.new([6, 4], [
                5.0, 3.1, 0.0, 8.4,
                3.2, 1.2, 2.5, 0.0,
                0.0, 0.0, 1.3, 0.0,
                0.0, 0.0, 0.0, 0.0,
                0.1, 0.0, 0.0, 2.56,
                0.0, 4.8, 0.0, 5.12,], dtype: :float64)
  end

  let(:labels) do
    NMatrix.new([6, 1], [1, 2, 2, 1, 1, 0], dtype: :int32)
  end

  let(:target_variables) do
    NMatrix.new([6, 1], [1.2, 2.0, 2.3, 1.0, 1.1, 0.64], dtype: :float64)
  end

  it 'loads libsvm .t file containing double features for regression task' do
    m, t = described_class.load_libsvm_file('spec/test_dbl.t', label_dtype: :float64)
    expect(m).to eq(matrix_dbl)
    expect(m.dtype).to eq(:float64)
    expect(t).to eq(target_variables)
    expect(t.dtype).to eq(:float64)
  end

  it 'loads libsvm .t file containing integer features for classification task' do
    m, l = described_class.load_libsvm_file('spec/test_int.t', value_dtype: :int32)
    expect(m).to eq(matrix_int)
    expect(m.dtype).to eq(:int32)
    expect(l).to eq(labels)
    expect(l.dtype).to eq(:int32)
  end

  it 'loads libsvm .t file with zero-based indexing' do
    m, j = described_class.load_libsvm_file('spec/test_zb.t', zero_based: true)
    expect(m).to eq(matrix_dbl)
  end

  it 'dumps double features with target variables' do
    described_class.dump_libsvm_file(matrix_dbl, target_variables, 'spec/dump_dbl.t')
    m, t = described_class.load_libsvm_file('spec/dump_dbl.t', label_dtype: :float64)
    expect(m).to eq(matrix_dbl)
    expect(t).to eq(target_variables)
  end

  it 'dumps integer features with labels' do
    described_class.dump_libsvm_file(matrix_int, labels, 'spec/dump_int.t')
    m, l = described_class.load_libsvm_file('spec/dump_int.t', value_dtype: :int32)
    expect(m).to eq(matrix_int)
    expect(l).to eq(labels)
  end

  it 'dumps features with zero-based indexing' do
    described_class.dump_libsvm_file(matrix_dbl, labels, 'spec/dump_zb.t', zero_based: true)
    m, l = described_class.load_libsvm_file('spec/dump_zb.t', zero_based: true,  label_dtype: :float64)
    expect(m).to eq(matrix_dbl)
    expect(l).to eq(labels)
  end
end
