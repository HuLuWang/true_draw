# hpb 5s 生成一个块
class TrueRandomService

  URL = "http://121.18.231.88:28545"

  def self.get_current_block_index
    options  = {"id": 1, "jsonrpc": "2.0", "method": "hpb_blockNumber", "params": []}.to_json
    header   = {'content-type': 'application/json'}
    response = RestClient.post(URL, options, header)
    body     = JSON.parse(response)
    body["result"]
  end

  def self.get_random_number block_index
    options  = {"id": 1, "jsonrpc": "2.0", "method": "hpb_getRandom", "params": [block_index]}.to_json
    header   = {'content-type': 'application/json'}
    response = RestClient.post(URL, options, header)
    body     = JSON.parse(response)
    body["result"]
  end


end