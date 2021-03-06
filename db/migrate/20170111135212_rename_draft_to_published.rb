class RenameDraftToPublished < ActiveRecord::Migration[4.2]
  def change
    reversible do |dir|
      dir.up do
        Event.all.each {|e| e.toggle!(:draft)}
      end
      dir.down do
        Event.all.each {|e| e.toggle!(:draft)}
      end
    end

    rename_column :events, :draft, :published
  end
end
