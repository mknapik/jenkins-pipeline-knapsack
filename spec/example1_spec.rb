require 'mysql2'

RSpec.describe 'Example1' do
  it 'is truthy' do
    expect(true).to eq(true)
  end

  it 'database test' do
    expect do
      client = Mysql2::Client.new(host: ENV.fetch('MYSQL_HOST', 'localhost'))
      client.query("SHOW DATABASES")
    end.not_to raise_error
  end
end
