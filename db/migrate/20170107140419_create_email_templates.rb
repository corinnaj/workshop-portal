class CreateEmailTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :email_templates do |t|
      t.integer :status
      t.string :subject
      t.text :content
      t.boolean :hide_recipients
    end
  end
end
