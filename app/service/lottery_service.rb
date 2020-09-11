# 开奖
class LotteryService

  def initialize lottery_id
    @lottery        = Lottery.where(id: lottery_id).first
    @begin_time     = @lottery.begin_time
    @lottery_time   = @lottery.lottery_time
    @lottery_ticket = []
    random_index = "0x" + (@lottery.random_index.to_i(16) + 30).to_s(16)
    @random          = TrueRandomService.get_random_number random_index
  end

  # 票池
  def participants
    @lottery_ticket = []
  end

  #开奖
  def run_lottery

  end

  # 发放奖品
  def offer_award

  end

end