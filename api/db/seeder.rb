# frozen_string_literal: true

class Seeder
  def initialize(*klasses)
    @klasses = klasses
  end

  def seed!
    @klasses.each { |klass| send(:"seed_#{klass.table_name}!") }
  end

  def seed_users!
    return if skip?(User)

    log 'Seeding User'
    count = rand(10..100)
    attrs = FactoryBot.attributes_for_list(:user, count).map do |user_attrs|
      # Transform the 'password' attribute to 'password_digest'
      user_attrs[:password_digest] = user_attrs.delete(:password)
      user_attrs
    end

    @user_ids = batch_insert!(user_attributes, User)
  end

  def seed_categories!
    return if skip?(Category)

    log 'Seeding Category'
    count = rand(10..100)
    attrs = FactoryBot.attributes_for_list(:category, count)
    @category_ids = batch_insert!(attrs, Category)
  end

  def seed_gardens!
    return if skip?(Garden)

    log 'Seeding Garden'
    attrs = FactoryBot.attributes_for_list(:garden, user_count).map do |attrs|
      attrs[:name] = "#{attrs[:name]}'s Garden"
      attrs.merge(user_id: user_ids.sample)
    end
    @garden_ids = batch_insert!(attrs, Garden)
  end

  def seed_trees!
    return if skip?(Tree)

    log 'Seeding Tree'
    count = garden_ids.count * rand(2..3)
    attrs = FactoryBot.attributes_for_list(:tree, count).map do |attributes|
      attributes.merge(garden_id: garden_ids.sample)
    end
    @tree_ids = batch_insert!(attrs, Tree)
  end

  def seed_exams!
    return if skip?(Exam)

    log 'Seeding Exam'
    attrs = FactoryBot.attributes_for_list(:exam, 10, :with_questions)
    @exam_ids = batch_insert!(attrs, Exam)
  end

  def seed_questions!
    return if skip?(Question)

    log 'Seeding Question'
    count = exam_count * rand(2..4) 
    attrs = FactoryBot.attributes_for_list(:question, count).map do |attributes|
      attributes.merge(exam_id: exam_ids.sample)
    end
    @question_ids = batch_insert!(attrs, Question)
  end

  def seed_options!
    return if skip?(Option)

    log 'Seeding Option'
    count = question_count * rand(3..4)
    attrs = FactoryBot.attributes_for_list(:option, count).map do |attributes|
      attributes.merge(question_id: question_ids.sample)
    end
    @option_ids = batch_insert!(attrs, Option)
  end

  private

  def user_ids
    @user_ids ||= User.pluck(:id)
  end

  def user_count
    @user_count ||= user_ids.count
  end

  def garden_ids
    @garden_ids ||= Garden.pluck(:id)
  end

  def exam_ids
    @exam_ids ||= Exam.pluck(:id)
  end

  def exam_count
    @exam_count ||= exam_ids.count
  end

  def question_ids
    @question_ids ||= Question.pluck(:id)
  end

  def question_count
    @question_count ||= question_ids.count
  end

  def skip?(klass)
    if klass.any?
      log "Skipping #{klass}, #{klass.table_name} table is populated already."
      return true
    end

    false
  end

  def batch_insert!(attributes_list, klass, batch_size: 100)
    log "Total of #{klass} records: #{attributes_list.count}"

    attributes_list.each_slice(batch_size).flat_map do |attributes_slice|
      log "Inserting a batch of #{attributes_slice.count} records"
      klass.insert_all!(attributes_slice).pluck('id')
    end
  end

  def log(message)
    puts message
  end
end
