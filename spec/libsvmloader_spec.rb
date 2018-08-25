# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LibSVMLoader do
  let(:mat_integer) do
    [[5, 3, 0, 8],
     [3, 1, 2, 0],
     [0, 0, 1, 0],
     [0, 0, 0, 0],
     [0, 0, 0, 2],
     [0, 4, 0, 5]]
  end
  let(:mat_float) do
    [[5.0, 3.1, 0.0, 8.4],
     [3.2, 1.2, 2.5, 0.0],
     [0.0, 0.0, 1.3, 0.0],
     [0.0, 0.0, 0.0, 0.0],
     [0.1, 0.0, 0.0, 2.56],
     [0.0, 4.8, 0.0, 5.12]]
  end
  let(:mat_complex) do
    [[5+0i,     3.1+0i, 0+0i,     8.4+1.2i],
     [3.2+0i,   1.2+0i, -2.5+0i,  0+0i],
     [0+0i,     0+0i,   1.3+2.2i, 0+0i],
     [0+0i,     0+0i,   0+0i,     0+0i],
     [0.1+1.5i, 0+0i,   0+0i,     2.5+0i],
     [0+0i,     4.8-4i, 0+0i,     5.1+0i]]
  end
  let(:labels) { [1, 2, 2, 1, 1, 0] }
  let(:str_labels) { ['c', 'c', 'c', 'b', 'b', 'a'] }
  let(:target_variables) { [1.2, 2.0, 2.3, 1.0, 1.1, 0.64] }

  it 'loads libsvm .t file containing float features for regression task' do
    m, t = described_class.load_libsvm_file('spec/test_dbl.t', label_dtype: 'float')
    expect(m).to eq(mat_float)
    expect(t).to eq(target_variables)
    expect(m.flatten.count { |el| el.is_a?(Float) }).to eq(mat_float.size * mat_float[0].size)
    expect(t.count { |el| el.is_a?(Float) }).to eq(target_variables.size)
  end

  it 'loads libsvm .t file containing integer features for classification task' do
    m, l = described_class.load_libsvm_file('spec/test_int.t', value_dtype: 'int')
    expect(m).to eq(mat_integer)
    expect(l).to eq(labels)
    expect(m.flatten.count { |el| el.is_a?(Integer) }).to eq(mat_integer.size * mat_integer[0].size)
    expect(l.count { |el| el.is_a?(Integer) }).to eq(labels.size)
  end

  it 'loads libsvm .t file containing complex features for classification task' do
    m, l = described_class.load_libsvm_file('spec/test_cmp.t', value_dtype: 'complex')
    expect(m).to eq(mat_complex)
    expect(l).to eq(labels)
    expect(m.flatten.count { |el| el.is_a?(Complex) }).to eq(mat_integer.size * mat_integer[0].size)
    expect(l.count { |el| el.is_a?(Integer) }).to eq(labels.size)
  end

  it 'loads libsvm .t file containing string labels' do
    m, l = described_class.load_libsvm_file('spec/test_str.t', label_dtype: 'string')
    expect(m).to eq(mat_float)
    expect(l).to eq(str_labels)
    expect(m.flatten.count { |el| el.is_a?(Float) }).to eq(mat_float.size * mat_float[0].size)
    expect(l.count { |el| el.is_a?(String) }).to eq(str_labels.size)
  end

  it 'loads libsvm .t file with zero-based indexing' do
    m, j = described_class.load_libsvm_file('spec/test_zb.t', zero_based: true)
    expect(m).to eq(mat_float)
  end

  it 'dumps float features with target variables' do
    described_class.dump_libsvm_file(mat_float, target_variables, 'spec/dump_dbl.t')
    m, t = described_class.load_libsvm_file('spec/dump_dbl.t', label_dtype: :float64)
    expect(m).to eq(mat_float)
    expect(t).to eq(target_variables)
  end

  it 'dumps integer features with labels' do
    described_class.dump_libsvm_file(mat_integer, labels, 'spec/dump_int.t')
    m, l = described_class.load_libsvm_file('spec/dump_int.t', value_dtype: :int32)
    expect(m).to eq(mat_integer)
    expect(l).to eq(labels)
  end

  it 'dumps complex features with labels' do
    described_class.dump_libsvm_file(mat_complex, labels, 'spec/dump_cmp.t')
    m, l = described_class.load_libsvm_file('spec/dump_cmp.t', value_dtype: :complex)
    expect(m).to eq(mat_complex)
    expect(l).to eq(labels)
  end

  it 'dumps features with zero-based indexing' do
    described_class.dump_libsvm_file(mat_float, labels, 'spec/dump_zb.t', zero_based: true)
    m, l = described_class.load_libsvm_file('spec/dump_zb.t', zero_based: true,  label_dtype: :float64)
    expect(m).to eq(mat_float)
    expect(l).to eq(labels)
  end
end
