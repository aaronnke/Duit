class AddColumnsToAllocation < ActiveRecord::Migration
  def self.up
    change_table :allocations do |t|
      t.belongs_to :group, index: true
      t.belongs_to :user, index: true
    end
  end

  def self.down
    change_table :alloctions do |t|
      t.remove :group
      r.remove :user
    end
  end
end


# class AddGroupToUsers < ActiveRecord::Migration
#   def self.up
#     change_table :users do |t|
#       t.belongs_to :group, index: true
#     end
#   end
#
#   def self.down
#       change_table :users do |t|
#         t.remove :group
#       end
#   end
#
# end
