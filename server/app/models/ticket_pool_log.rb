# 票池
class TicketPoolLog < ApplicationRecord
  belongs_to :lottery
  belongs_to :user



end