# 到时开奖
class LotteryService

  def initialize lottery_id
    @lottery     = Lottery.where(id: lottery_id).first
    @awards      = @lottery.awards
    random_index = @lottery.random_index
    random       = TrueRandomService.get_random_number random_index
    @seed        = random.to_i(16).to_s[-8..-1].to_i
    @user_pool   = []
  end

  # 获取奖池
  def user_pool
    @user_pool =  $redis.lrange("USER_POOL:#{lottery.id}", 1, -1)
  end

  #开奖
  def run_lottery
    size  = @user_pool.size
    index = @seed % size
    @user_pool[index]
  end

  # 发放奖品
  def offer_award
    return unless @lottery.state == "start"
    user_pool
    awards = @lottery.awards
    awards.each do |a|
      issued_num = 0
      while a.number - issued_num > 0
        user_id = run_lottery
        break if user_id.nil?
        AwardUser.create!(
            lottery_id: @lottery.id,
            user_id:    user_id,
            award_id:   a.id
        )
        @user_pool -= [user_id]
        issued_num += 1
      end
    end
    @lottery.end!
  end

end