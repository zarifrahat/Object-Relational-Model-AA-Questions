require 'sqlite3'
require 'singleton'

class Questions_Database < SQLite3::Database
    include Singleton
    
    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Question
    attr_accessor :id, :title, :body, :author_id

    def self.find_by_id(arg_id)
        question = Questions_Database.instance.execute(<<-SQL, arg_id)
        SELECT
            *
        FROM
            questions
        WHERE
            id = ?
        SQL
        Question.new(question.first)
    end

    def self.find_by_author_id(author_id)
        questions = Questions_Database.instance.execute(<<-SQL, author_id)
        SELECT
            *
        FROM
            questions
        WHERE
            author_id = ?
        SQL
        questions.map {|ele| Question.new(ele)}
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['playwright_id']
    end

    def author 
        User.find_by_id(@author_id)
    end

    def replies
        Replies.find_by_question_id(@id)
    end

    def followers
        Questions_Follow.followers_for_question_id(@id)
    end
end

class User
    attr_accessor :id, :fname, :lname

    def self.find_by_id(id)
        user = Questions_Database.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            users
        WHERE
            id = ?
        SQL
        User.new(user.first)

    end

    def self.find_by_name(fname, lname)
        person = Questions_Database.instance.execute(<<-SQL, fname, lname)
        SELECT
            *
        FROM
            users
        WHERE
            fname = ? AND lname = ?
        SQL
        User.new(person.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions
        Question.find_by_author_id(@id)
    end

    def authored_replies
        Reply.find_by_user_id(@id)
    end

    def followed_questions
        Questions_Follow.followed_questions_for_user_id(@id)
    end

end


class Questions_Follow

    attr_accessor :id, :question_id, :follower_id

    def self.find_by_id(id)
        qf = Questions_Database.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            questions_follow
        WHERE
         id = ? 
        SQL
        Questions_Follow.new(qf.first)
    end

    def self.followers_for_question_id(question_id)
        followers_for_q = Questions_Database.instance.execute(<<-SQL, question_id)
        SELECT
            users.*
        FROM
            users
        INNER JOIN 
            questions_follow
            ON users.id = questions_follow.follower_id
        WHERE 
            question_id = ?
        SQL
        followers_for_q.map {|options| User.new(options)}
    end

    def self.followed_questions_for_user_id(user_id)
        followed_questions = Questions_Database.instance.execute(<<-SQL, user_id)
        SELECT
            questions.*
        FROM
            questions_follow
        INNER JOIN
            users
            ON
            users.id = questions_follow.follower_id
            INNER JOIN
            questions
            ON
            questions_follow.question_id = questions.id
        WHERE
            users.id = ?
        
        SQL
        followed_questions.map {|hash| Question.new(hash)}  
    end

    def self.most_followed_questions(n)
        most_followed_questions = Questions_Database.instance.execute(<<-SQL, n)
        SELECT DISTINCT
            questions.*
        FROM
            questions_follow
        INNER JOIN
            questions
            ON
            questions_follow.question_id = questions.id
        GROUP BY
            question_id 
        LIMIT 
            ?
        
        SQL
        most_followed_questions.map {|hash| Question.new(hash)}  

    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @follower_id = options['follower_id']
    end
end

class Replies

    attr_accessor :id, :body, :question_id, :parent_reply_id, :reply_author_id

    def self.find_by_id(id)
        replies = Questions_Database.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            replies
        WHERE
            id = ? 
            SQL
        Replies.new(replies.first)
    end

    def self.find_by_user_id(user_id)
        replies = Questions_Database.instance.execute(<<-SQL, user_id)
        SELECT
            *
        FROM
            replies
        WHERE
            user_id = ?
        SQL
        replies.map {|ele| Replies.new(ele)}
    end

    def self.find_by_question_id(question_id)
        replies = Questions_Database.instance.execute(<<-SQL, question_id)
        SELECT
            *
        FROM
            replies
        WHERE
            question_id = ?
        SQL
        replies.map {|ele| Replies.new(ele)}
    end

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @reply_author_id = options['reply_author_id']
    end

    def author 
        User.find_by_id(@reply_author_id)
    end

    def question
        Question.find_by_id(@question_id)
    end

    def parent_reply 
        Replies.find_by_id(@parent_reply_id)
    end

    def child_replies
        Replies.find_by_id(@id.to_i + 1)
    end
end

class Question_Likes

    attr_accessor :id, :question_id, :liker_id

    def self.find_by_id(id)
        question_likes = Questions_Database.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            question_likes
        WHERE
            id = ? 
            SQL
        Question_Likes.new(question_likes.first)
    end

    def initialize(options)
        @id = options['id']
        @liker_id = options['liker_id']
        @question_id = options['question_id']
    end
end


