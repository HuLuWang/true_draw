# 抽奖活动
class Lottery < ApplicationRecord
  has_many :awards, dependent: :destroy
  has_many :lottery_users
  has_many :award_users
  belongs_to :owner, foreign_key: :created_by, class_name: "User"

  enum state: {:start => "start", :end => "end"}

  # todo 按时抽奖的加入队列
  def self.generate option
    ActiveRecord::Base.transaction do
      # 获取index
      random_index = TrueRandomService.get_current_block_index
      # 创建活动
      @lottery = Lottery.New
      @lottery.title = option[:title]
      @lottery.image = option[:image]
      @lottery.content = option[:content]
      @lottery.lottery_type = option[:lottery_type]
      @lottery.condition = option[:condition]
      if option[:condition] == "time"
        @lottery.lottery_time = option[:lottery_time]
      else
        @lottery.lottery_num = option[:lottery_num]
      end
      @lottery.random_index = random_index
      @lottery.created_by = option[:user_id]
      @lottery.save!
      # 创建奖品
      option[:award_list].each do |a|
        Award.create!(
            lottery_id: @lottery.id,
            name:       a[:name],
            image:      a[:image],
            number:     a[:number] || 1,
        )
      end
    end
    @lottery
  end

  # 开奖条件类型不能切换
  def edit option
    ActiveRecord::Base.transaction do
      # 获取index
      random_index = TrueRandomService.get_current_block_index
      # 创建活动
      self.title = option[:title]
      self.image = option[:image]
      self.content = option[:content]
      self.lottery_type = option[:lottery_type]
      if self.condition == "time"
        self.lottery_time = option[:lottery_time]
      else
        self.lottery_num = option[:lottery_num]
      end
      self.random_index = random_index
      if option[:award_list].present?
        # 删除旧的奖品
        self.awards.destroy_all
        # 新增奖品
        option[:award_list].each do |a|
          Award.create!(
              lottery_id: self.id,
              name:       a[:name],
              image:      a[:image],
              number:     a[:number],
          )
        end
      end
    end
  end

  def base_info
    {
        id:           id,
        image:        image,
        title:        title,
        state:        state,
        condition:    condition,
        lottery_time: lottery_time,
        lottery_num:  lottery_num,
        content:      content,
        created_by:   created_by,
        created_name: owner.nickname
    }
  end

  def detail_info
    base_info.merge!(
        {
            awards_list:  award_list,
            winners_list: winners_list
        }
    )
  end

  def award_list
    awards = self.awards
    info   = awards.map do |a|
      {
          id:     a.id,
          name:   a.name,
          number: a.number
      }
    end
    info
  end

  def winners_list
    winners = self.award_users.joins(:user, :award)
    info    = winners.map do |w|
      {
          id:         w.user_id,
          nickname:   w.user.name,
          avatar:     w.user.avatar,
          award_name: w.award.name
      }
    end
    info
  end

  private
  def add_queue
    # if self.condition == "time"
    #   job = RunLotteryJob.set(wait_until: self.lottery_time).perform_later(self.id)
    #   jid = job.provider_job_id
    #   $redis.set("Lottery:#{self.id}", jid, {ex: 30 * 24 * 60 * 60})
    # end
  end

  def edit_job
    # jid = $redis.get("Lottery:#{self.id}")
    # return if jid.nil?
    # queue = Sidekiq::Queue.new("default")
    # queue.each do |job|
    #   job.delete if job.jid == jid
    # end
    # add_queue
  end
end