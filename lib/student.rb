require "pry"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  ATTRIBUTES = {
    id: "INTEGER PRIMARY KEY",
    name: "TEXT",
    grade: "INTEGER"
  }

  def self.public_attributes
    ATTRIBUTES.keys.reject { |key| key == :id }
  end

  def values
    self.class.public_attributes.map do |key|
      self.send(key)
    end
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]



  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    # binding.pry
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(attributes = {})
    student = Student.new(attributes[:name], attributes[:grade], attributes[:id])
    student.save
    student
  end

end
