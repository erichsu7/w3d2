require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follower'

class User

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
    *
    FROM
    users
    WHERE
    users.id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    results.map { |result| User.new(result) }.first
  end

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT
      *
      FROM
      users
      WHERE
      users.fname = ? AND users.lname = ?
      SQL

    results = QuestionsDatabase.instance.execute(query, fname, lname)
    results.map { |result| User.new(result) }
  end

  def self.most_liked_questions(n)

  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(self.id)
  end

  def average_karma
    query = <<-SQL
      SELECT
        (CAST(COUNT(question_likes.user_id) AS FLOAT))/COUNT(DISTINCT(questions.id))
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.user_id = ?
      SQL

    results = QuestionsDatabase.instance.execute(query, self.id)
    results.first.values.first
  end

  def save
    if self.id.nil?
      insert_query = <<-SQL
        INSERT INTO users (fname, lname)
        VALUES (?, ?)
      SQL

      QuestionsDatabase.instance.execute(insert_query, self.fname, self.lname)
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
