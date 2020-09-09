class LotteryService

  def initialize lottery_id
    @lottery        = Lottery.where(id: lottery_id).first
    @begin_time     = @lottery.begin_time
    @lottery_time   = @lottery.lottery_time
    @lottery_ticket = []
    block_index     = TrueRandomService.get_current_block_index
    random          = TrueRandomService.get_random_number block_index
    srand(random.to_i(16))
    @lottery.update(random_index: block_index)
  end

  def participants
    logs         = VisitCustomerLog.where(last_visit_time: [@begin_time..@lottery_time])
    customer_ids = logs.pluck(:customer_id).uniq
    # 票池
    logs.each do |l|
      @lottery_ticket << l.customer.member_user_id
    end
    # 参与者
    customer_ids.each do |id|
      customer           = Customer.find id
      visitors           = logs.where(customer_id: id).pluck(:member_user_id)
      lottery_user       = LotteryUser.where(member_user_id: customer.member_user_id, lottery_id: @lottery.id).first_or_initialize
      lottery_user.votes = visitors.count
      lottery_user.save!
    end
    @lottery_ticket
  end

  #开奖
  def run_lottery
    size  = @lottery_ticket.size
    index = rand(size)
    @lottery_ticket[index]
  end

  # 发放奖品
  def offer_award
    return if @lottery.state == "END"
    participants
    awards = @lottery.awards
    awards.each do |a|
      issued_num = 0
      while a.number - issued_num > 0
        user_id = run_lottery
        break if user_id.nil?
        LotteryWinner.create!(
            lottery_id:     @lottery.id,
            member_user_id: user_id,
            award_id:       a.id
        )
        @lottery_ticket -= [user_id]
        issued_num += 1
      end
    end
    @lottery.update!(state: "END")
  end

end