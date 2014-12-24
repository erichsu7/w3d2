module Save
  def save
    instance_vars_strs = self.instance_variables.map { |var| var.to_s[1..-1] }

    if self.id.nil?
      instance_vars_strs.delete("id")
      no_id_vars_str = instance_vars_strs.join(", ")

      insert_query = <<-SQL
      INSERT INTO #{self.class.to_s.downcase}s (#{no_id_vars_str})
      VALUES (#{instance_vars_strs.map{|v| '?'}.join(", ")})
      SQL

      params = self.instance_variables
      params.delete(:@id)
      QuestionsDatabase.instance.execute(insert_query, *params)
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      update_query = <<-SQL
      UPDATE users
      SET fname = ?, lname = ?
      WHERE id = ?
      SQL

      QuestionsDatabase.instance.execute(update_query, self.fname, self.lname, self.id)
    end

    self
  end
end
