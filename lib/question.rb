require_relative 'questions_database'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follower'
require_relative 'question_like'

class Question
  attr_accessor :id, :title, :body, :user_id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
    *
    FROM
    questions
    WHERE
    questions.id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    results.map { |result| Question.new(result) }.first
  end

  def self.find_by_author_id(author_id)
    query = <<-SQL
    SELECT
    *
    FROM
    questions
    WHERE
    questions.user_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, author_id)
    results.map { |result| Question.new(result) }
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def author
    User.find_by_id(self.user_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollower.followers_for_question_id(self.id)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end

end
