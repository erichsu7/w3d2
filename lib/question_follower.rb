require_relative 'questions_database'
require_relative 'user'
require_relative 'question'


class QuestionFollower
  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
    *
    FROM
    question_followers
    WHERE
    question_followers.id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    results.map { |result| QuestionFollower.new(result) }.first
  end

  def self.followers_for_question_id(question_id)
    query = <<-SQL
    SELECT
    users.*
    FROM
    question_followers
    JOIN
    users ON user.id = question_followers.user_id
    WHERE
    question_followers.question_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, question_id)
    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    query = <<-SQL
    SELECT
    questions.*
    FROM
    question_followers
    JOIN
    questions ON questions.id = question_followers.question_id
    WHERE
    question_followers.user_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, user_id)
    results.map { |result| Question.new(result) }
  end

  def self.most_followed_questions(n)
    query = <<-SQL
    SELECT
      questions.*
    FROM
      question_followers
    JOIN
      questions ON questions.id = question_followers.question_id
    GROUP BY
      question_followers.question_id
    ORDER BY
      COUNT(*) DESC
    LIMIT ?
    SQL

    results = QuestionsDatabase.instance.execute(query, n)
    results.map { |result| Question.new(result) }
  end

end
