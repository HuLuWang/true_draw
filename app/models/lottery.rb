# 抽奖活动
class Lottery < ApplicationRecord
  has_many :awards, dependent: :destroy
  has_many :lottery_users
  has_many :award_users
  belongs_to :owner, foreign_key: :created_by, class_name: "User"

  enum state: {:not_start => "not_start", :start => "start", :end => "end"}
  after_create :add_queue
  after_update :edit_queue


  def self.generate option
    ActiveRecord::Base.transaction do
      # 获取index
      random_index = TrueRandomService.get_current_block_index
      # 创建活动
      @lottery = Lottery.create!(
          title:        option[:title],
          image:        option[:image],
          content:      option[:content].to_json,
          lottery_type: option[:type] || "common",
          begin_time:   option[:begin_time],
          lottery_time: option[:lottery_time],
          random_index: random_index,
          created_by:   @member_user.id
      )
      # 创建奖品
      option[:award_list].each do |a|
        Award.create!(
            lottery_id: @lottery.id,
            name:       a[:name],
            image:      a[:image],
            number:     a[:number] || 1,
            level:      a[:level] || 5
        )
      end
    end
    @lottery.id
  end

  def edit option
    ActiveRecord::Base.transaction do
      old_time = self.lottery_time
      new_time = option[:lottery_time]
      # 获取index
      random_index = TrueRandomService.get_current_block_index
      # 创建活动
      self.update!(
          title:        option[:title],
          content:      option[:content].to_json,
          lottery_type: option[:type] || "common",
          begin_time:   option[:begin_time],
          lottery_time: option[:lottery_time],
          random_index: random_index
      )
      if option[:award_list].present?
        # 删除旧的奖品
        self.awards.destroy_all
        # 新增奖品
        option[:award_list].each do |a|
          Award.create!(
              lottery_id: self.id,
              name:       a[:name],
              number:     a[:number] || 1,
              level:      a[:level] || 5
          )
        end
      end
      if new_time != old_time
        edit_job
      end
    end
  end

  def base_info
    {
        id:           id,
        image:        image,
        title:        title,
        state:        state,
        lottery_time: lottery_time,
        content:      content,
        created_by:   created_by,
        created_name: owner.nickname
    }
  end

  def detail_info
    base_info.merge!(
        {
            awards_list:  awards_list,
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
          id:         w.member_user_id,
          nickname:   w.user.name,
          avatar:     w.user.avatar,
          award_name: w.award.name
      }
    end
    info
  end

  private
  def add_queue
    job = RunLotteryJob.set(wait_until: self.lottery_time).perform_later(self.id)
    jid = job.provider_job_id
    $redis.set("Lottery:#{self.id}", jid, {ex: 30 * 24 * 60 * 60})
  end

  def edit_job
    jid = $redis.get("Lottery:#{self.id}")
    return if jid.nil?
    queue = Sidekiq::Queue.new("default")
    queue.each do |job|
      job.delete if job.jid == jid
    end
    add_queue
  end
end