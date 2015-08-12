require_relative '../caesar_cipher'

describe '#caesar_cipher' do
  it 'shifts lowercase letters' do
    expect(caesar_cipher('a', 6)).to eq('g')
  end
  it 'shifts uppercase letters' do
    expect(caesar_cipher('A', 6)).to eq('G')
  end
  it 'does not shift other characters' do
    expect(caesar_cipher('!@#$%', 6)).to eq('!@#$%')
  end
  it 'shifts between z and a' do
    expect(caesar_cipher('Zz', 1)).to eq('Aa')
  end
  it 'shifts backward between z and a' do
    expect(caesar_cipher('Aa', -1)).to eq('Zz')
  end
  it 'handles large values' do
    expect(caesar_cipher('abc', 47)).to eq('vwx')
  end
end
