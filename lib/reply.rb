require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class Reply
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
    *
    FROM
    replies
    WHERE
    replies.id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    results.map { |result| Reply.new(result) }.first
  end

  def self.find_by_question_id(question_id)
    query = <<-SQL
    SELECT
    *
    FROM
    replies
    WHERE
    replies.question_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, question_id)
    results.map { |result| Reply.new(result) }
  end

  def self.find_by_user_id(user_id)
    query = <<-SQL
    SELECT
    *
    FROM
    replies
    WHERE
    replies.user_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, user_id)
    results.map { |result| Reply.new(result) }
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.user_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_reply_id)
  end

  def child_replies
    query = <<-SQL
    SELECT
    *
    FROM
    replies
    WHERE
    replies.parent_reply_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, self.id)
    results.map { |result| Reply.new(result) }
  end
end
