require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class QuestionLike
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
    question_likes
    WHERE
    question_likes.id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    results.map { |result| QuestionLike.new(result) }.first
  end

  def self.likers_for_question_id(question_id)
    query = <<-SQL
    SELECT
    users.*
    FROM
    question_likes
    JOIN
    users ON users.id = question_likes.user_id
    WHERE
    question_likes.question_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, question_id)
    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    query = <<-SQL
    SELECT
    COUNT(*)
    FROM
    question_likes
    WHERE
    question_likes.question_id = ?
    GROUP BY
    question_likes.question_id
    SQL

    results = QuestionsDatabase.instance.execute(query, question_id)
    results.map { |result| result.values.first }.first
  end

  def self.liked_questions_for_user_id(user_id)
    query = <<-SQL
    SELECT
    questions.*
    FROM
    question_likes
    JOIN
    questions ON questions.id = question_likes.question_id
    WHERE
    question_likes.user_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, user_id)
    results.map { |result| Question.new(result) }
  end

  def self.most_liked_questions(n)
    query = <<-SQL
    SELECT
      questions.*
    FROM
      question_likes
    JOIN
      questions ON questions.id = question_likes.question_id
    GROUP BY
      question_likes.question_id
    ORDER BY
      COUNT(*) DESC
    LIMIT ?
    SQL

    results = QuestionsDatabase.instance.execute(query, n)
    results.map { |result| Question.new(result) }
  end
end
